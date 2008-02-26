Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbYBZVrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbYBZVrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762868AbYBZVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:47:28 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35844 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761817AbYBZVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:47:27 -0500
Message-ID: <1204062430.47c488def40a4@portal.student.luth.se>
Date: Tue, 26 Feb 2008 22:47:10 +0100
From: ricknu-0@student.ltu.se
To: khc@pm.waw.pl, bhalevy.lists@gmail.com, jengelh@computergmbh.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] CodeStyle: Use spaces when aligning/decorating
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.1
X-Originating-IP: 130.240.42.170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relaxing the 'tab = 8 character', which leads to 'don't tab the alignment'.
By only using tabs for indentation, we solidify it as a 'logical indentation'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
To'ed the people who showed interest in the (apparently not so new)
question/suggestion of not using tabs when aligning.
If this looks ok, then checkpatch.pl is next...


diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 6caa146..1b3f448 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -15,10 +15,8 @@ Anyway, here goes:
 
 	 	Chapter 1: Indentation
 
-Tabs are 8 characters, and thus indentations are also 8 characters.
-There are heretic movements that try to make indentations 4 (or even 2!)
-characters deep, and that is akin to trying to define the value of PI to
-be 3.
+This project is recommended to be viewed with a tab-width of 8 characters
+(and other code).
 
 Rationale: The whole idea behind indentation is to clearly define where
 a block of control starts and ends.  Especially when you've been looking
@@ -86,13 +84,15 @@ substantially to the right. The same applies to function
headers with a long
 argument list. Long strings are as well broken into shorter strings. The
 only exception to this is where exceeding 80 columns significantly increases
 readability and does not hide information.
+As this falls under alignments, only use tabs to indent it to the parents
+level and then space in the rest.
 
 void fun(int a, int b, int c)
 {
 	if (condition)
 		printk(KERN_WARNING "Warning this is a long printk with "
-						"3 parameters a: %u b: %u "
-						"c: %u \n", a, b, c);
+		                    "3 parameters a: %u b: %u "
+		                    "c: %u \n", a, b, c);
 	else
 		next_statement;
 }

