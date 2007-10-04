Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbXJDJqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbXJDJqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXJDJqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:46:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41329 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756471AbXJDJqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:46:06 -0400
Date: Thu, 4 Oct 2007 11:44:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: CodingStyle: mention bitfields/whitespace style, prefer (!foo) in
	examples
Message-ID: <20071004094422.GA652@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mention whitespace and bitfields style, prefer (!foo) to (foo == NULL)
in examples.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 7f1730f..1595a45 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -71,6 +71,15 @@ used for indentation, and the above exam
 
 Get a decent editor and don't leave whitespace at the end of lines.
 
+Bitfield variables should be indented like this:
+
+	unsigned int foo :1;
+
+Do not put whitespace between any of the unary operators and their operand.
+
+It is usually unnecessary to have whitespace around parentheses as
+part of expressions, around brackets, or around the operators . and
+->.
 
 		Chapter 2: Breaking long lines and strings
 
@@ -403,7 +412,7 @@ int fun(int a)
 	int result = 0;
 	char *buffer = kmalloc(SIZE);
 
-	if (buffer == NULL)
+	if (!buffer)
 		return -ENOMEM;
 
 	if (condition1) {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
