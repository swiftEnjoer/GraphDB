USE master;

DROP DATABASE IF EXISTS ScientificResearch;

CREATE DATABASE ScientificResearch;

USE ScientificResearch;

IF OBJECT_ID('workWith', 'U') IS NOT NULL DROP TABLE workWith;
IF OBJECT_ID('writtenBy', 'U') IS NOT NULL DROP TABLE writtenBy;
IF OBJECT_ID('worksIn', 'U') IS NOT NULL DROP TABLE worksIn;

IF OBJECT_ID('ResearchFields', 'U') IS NOT NULL DROP TABLE ResearchFields;
IF OBJECT_ID('Publications', 'U') IS NOT NULL DROP TABLE Publications;
IF OBJECT_ID('Authors', 'U') IS NOT NULL DROP TABLE Authors;
--1


CREATE TABLE Authors (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Publications (
    id INT NOT NULL PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    publication_date DATE,
) AS NODE;

CREATE TABLE ResearchFields (
    id INT NOT NULL PRIMARY KEY,
    field_name NVARCHAR(100) NOT NULL
) AS NODE;

--2

CREATE TABLE worksIn AS EDGE;
CREATE TABLE writtenBy AS EDGE;
CREATE TABLE workWith AS EDGE;

--3

INSERT INTO Authors (id, name) VALUES
(1, 'Alexey Ivanov'),
(2, 'Maria Smirnova'),
(3, 'Igor Kuznetsov'),
(4, 'Olga Sergeeva'),
(5, 'Dmitry Popov'),
(6, 'Elena Krylova'),
(7, 'Nikolay Sidorov'),
(8, 'Anna Vasilieva'),
(9, 'Sergey Mikhailov'),
(10, 'Natalia Fedorova');

INSERT INTO Publications (id, title, publication_date) VALUES
(1, 'Artificial Intelligence Research', '2022-01-15'),
(2, 'Introduction to Quantum Computing', '2021-05-10'),
(3, 'Deep Learning in Medicine', '2023-03-20'),
(4, 'Robotics and Automation', '2022-07-01'),
(5, 'Blockchain Technologies', '2021-11-12'),
(6, 'Bioinformatics and Genetics', '2023-01-08'),
(7, 'Big Data Analysis', '2020-12-25'),
(8, 'Neural Networks and Applications', '2023-06-18'),
(9, 'Introduction to Machine Learning', '2022-09-30'),
(10, 'Ethical Aspects of AI', '2024-02-14');


INSERT INTO ResearchFields (id, field_name) VALUES
(1, 'Artificial Intelligence'),
(2, 'Quantum Technologies'),
(3, 'Medical Technology'),
(4, 'Robotics'),
(5, 'Financial Technologies'),
(6, 'Biotechnology'),
(7, 'Data Science'),
(8, 'Computer Vision'),
(9, 'Machine Learning'),
(10, 'Technology Ethics');


--4


INSERT INTO writtenBy ($from_id, $to_id) VALUES
((SELECT $node_id FROM Authors WHERE id = 1), (SELECT $node_id FROM Publications WHERE id = 1)),
((SELECT $node_id FROM Authors WHERE id = 2), (SELECT $node_id FROM Publications WHERE id = 2)),
((SELECT $node_id FROM Authors WHERE id = 3), (SELECT $node_id FROM Publications WHERE id = 3)),
((SELECT $node_id FROM Authors WHERE id = 4), (SELECT $node_id FROM Publications WHERE id = 4)),
((SELECT $node_id FROM Authors WHERE id = 5), (SELECT $node_id FROM Publications WHERE id = 5)),
((SELECT $node_id FROM Authors WHERE id = 6), (SELECT $node_id FROM Publications WHERE id = 6)),
((SELECT $node_id FROM Authors WHERE id = 7), (SELECT $node_id FROM Publications WHERE id = 7)),
((SELECT $node_id FROM Authors WHERE id = 8), (SELECT $node_id FROM Publications WHERE id = 8)),
((SELECT $node_id FROM Authors WHERE id = 9), (SELECT $node_id FROM Publications WHERE id = 9)),
((SELECT $node_id FROM Authors WHERE id = 10), (SELECT $node_id FROM Publications WHERE id = 10))

INSERT INTO worksIn ($from_id, $to_id) VALUES
((SELECT $node_id FROM Authors WHERE id = 1), (SELECT $node_id FROM ResearchFields WHERE id = 1)),
((SELECT $node_id FROM Authors WHERE id = 2), (SELECT $node_id FROM ResearchFields WHERE id = 2)),
((SELECT $node_id FROM Authors WHERE id = 3), (SELECT $node_id FROM ResearchFields WHERE id = 3)),
((SELECT $node_id FROM Authors WHERE id = 4), (SELECT $node_id FROM ResearchFields WHERE id = 4)),
((SELECT $node_id FROM Authors WHERE id = 5), (SELECT $node_id FROM ResearchFields WHERE id = 5)),
((SELECT $node_id FROM Authors WHERE id = 6), (SELECT $node_id FROM ResearchFields WHERE id = 6)),
((SELECT $node_id FROM Authors WHERE id = 7), (SELECT $node_id FROM ResearchFields WHERE id = 7)),
((SELECT $node_id FROM Authors WHERE id = 8), (SELECT $node_id FROM ResearchFields WHERE id = 8)),
((SELECT $node_id FROM Authors WHERE id = 9), (SELECT $node_id FROM ResearchFields WHERE id = 9)),
((SELECT $node_id FROM Authors WHERE id = 10), (SELECT $node_id FROM ResearchFields WHERE id = 10));

INSERT INTO workWith ($from_id, $to_id) VALUES
((SELECT $node_id FROM Authors WHERE id = 1), (SELECT $node_id FROM Authors WHERE id = 2)),
((SELECT $node_id FROM Authors WHERE id = 3), (SELECT $node_id FROM Authors WHERE id = 4)),
((SELECT $node_id FROM Authors WHERE id = 5), (SELECT $node_id FROM Authors WHERE id = 6)),
((SELECT $node_id FROM Authors WHERE id = 7), (SELECT $node_id FROM Authors WHERE id = 8)),
((SELECT $node_id FROM Authors WHERE id = 9), (SELECT $node_id FROM Authors WHERE id = 10)),
((SELECT $node_id FROM Authors WHERE id = 2), (SELECT $node_id FROM Authors WHERE id = 3)),
((SELECT $node_id FROM Authors WHERE id = 4), (SELECT $node_id FROM Authors WHERE id = 5)),
((SELECT $node_id FROM Authors WHERE id = 6), (SELECT $node_id FROM Authors WHERE id = 7)),
((SELECT $node_id FROM Authors WHERE id = 8), (SELECT $node_id FROM Authors WHERE id = 9)),
((SELECT $node_id FROM Authors WHERE id = 10), (SELECT $node_id FROM Authors WHERE id = 1));

--5


SELECT a.name AS Author, p.title AS Publication
FROM Authors a, writtenBy wb, Publications p
WHERE MATCH(a-(wb)->p);



SELECT a1.name AS Author1, a2.name AS Author2
FROM Authors a1, workWith ww, Authors a2
WHERE MATCH(a1-(ww)->a2);



  SELECT c.name AS Collaborator, p.title AS Publication
FROM Authors js, workWith ww, Authors c, writtenBy wb, Publications p
WHERE MATCH(js-(ww)->c-(wb)->p) AND js.name = 'Alexey Ivanov';


--6 


SELECT 
    a1.name AS AuthorName,
    STRING_AGG(a2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Collaborators
FROM 
    Authors AS a1,
    workWith FOR PATH AS ww,
    Authors FOR PATH AS a2
WHERE 
    MATCH(SHORTEST_PATH(a1(-(ww)->a2)+))
    AND a1.name = N'Alexey Ivanov';



SELECT 
    a1.name AS AuthorName,
    STRING_AGG(a2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Collaborators
FROM 
    Authors AS a1,
    workWith FOR PATH AS ww,
    Authors FOR PATH AS a2
WHERE 
    MATCH(SHORTEST_PATH(a1(-(ww)->a2){1,4}))
    AND a1.name = N'Maria Smirnova';