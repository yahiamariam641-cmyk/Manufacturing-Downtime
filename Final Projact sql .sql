--  start Data cleaning

CREATE TABLE Manufacturing_Line_Productivity(
    date DATE,
    product VARCHAR(50),
    batch INT,
    operator VARCHAR(50),
    start_time TIME,
    end_time TIME
); 

-- check raw data

SELECT * from manufacturing_Line_Productivity  ; 

-- check missing values

SELECT *
FROM Manufacturing_Line_Productivity 

WHERE date IS NULL
   OR product IS NULL
   OR batch IS NULL
   OR operator IS NULL
   OR start_time IS NULL
   OR end_time IS NULL; 
   
-- check for duplicates   
   
SELECT batch, COUNT(*)
FROM Manufacturing_Line_Productivity
GROUP BY batch
HAVING COUNT(*) > 1; 

--standarize product Names

SELECT DISTINCT product
FROM Manufacturing_Line_Productivity; 

-- standeries operator Names

SELECT DISTINCT operator
FROM manufacturing_line_productivity;

UPDATE manufacturing_line_productivity
SET operator = 'Charlie'
WHERE operator = 'charlie'; 

-- production duration

SELECT *,
(strftime('%s', end_time) - strftime('%s', start_time)) / 60 AS production_minutes
FROM manufacturing_line_productivity;  

--Detect incorrect Time Data

SELECT *
FROM manufacturing_line_productivity
WHERE end_time < start_time; 

--clean final dataset

CREATE VIEW clean_productivity AS
SELECT 
    date,
    product,
    batch,
    operator,
    start_time,
    end_time,
    (strftime('%s', end_time) - strftime('%s', start_time)) / 60 AS production_minutes
FROM Manufacturing_Line_Productivity; 

SELECT * from clean_productivity; 

-- Ready for analysis

SELECT operator,
       AVG(production_minutes) AS avg_time
FROM clean_productivity
GROUP BY operator
ORDER BY avg_time ;

--start Data analysis

--understant operator performance

SELECT 
    operator,
    COUNT(batch) AS total_batches,
    SUM(production_minutes) AS total_minutes,
    AVG(production_minutes) AS avg_minutes_per_batch
FROM clean_productivity
GROUP BY operator
ORDER BY avg_minutes_per_batch; 

-- Knowing the daily production

SELECT 
    date,
    SUM(production_minutes)/60 AS total_hours
FROM clean_productivity
GROUP BY date
ORDER BY date; 

--knowing the most productive operators

SELECT 
    operator,
    SUM(production_minutes) AS total_minutes,
    AVG(production_minutes) AS avg_minutes_per_batch,
    COUNT(batch) AS total_batches
FROM clean_productivity
GROUP BY operator
ORDER BY total_batches DESC, avg_minutes_per_batch ASC; 

--identifying the operators with the most experience in specific products 

SELECT
operator,
product,
COUNT(batch) AS total_batches
FROM clean_productivity
GROUP BY operator, product;