Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbXJ3LUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbXJ3LUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbXJ3LUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:20:19 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:38307 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbXJ3LUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:20:17 -0400
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "Jesper Nilsson" <Jesper.Nilsson@axis.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>,
       "Jesper Nilsson" <Jesper.Nilsson@axis.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 15/16] CRIS architecture: Correct compile errors
Date: Tue, 30 Oct 2007 12:20:05 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66804C40150@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C6680549C7F2@exmail1.se.axis.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikael Starvik <starvik@axis.com>

-----Original Message-----
From: Jesper Nilsson [mailto:jespern@axis.com] 
Sent: Tuesday, October 30, 2007 10:36 AM
To: Andrew Morton; Mikael Starvik; Jesper Nilsson;
linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] CRIS architecture: Correct compile errors


- Add __negdi2 to exported symbols.
- Remove string functions from exported symbols.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 crisksyms.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -urBb -X /h/jespern/.exclude_files
clean_linux-2.6.23/arch/cris/kernel/crisksyms.c
linux-2.6.23/arch/cris/kernel/crisksyms.c
--- clean_linux-2.6.23/arch/cris/kernel/crisksyms.c	2007-10-09
22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/crisksyms.c	2007-10-23
13:52:07.000000000 +0200
@@ -27,6 +27,7 @@
 extern void __ashldi3(void);
 extern void __ashrdi3(void);
 extern void __lshrdi3(void);
+extern void __negdi2(void);
 extern void iounmap(volatile void * __iomem);
 
 /* Platform dependent support */
@@ -34,19 +35,6 @@
 EXPORT_SYMBOL(get_cmos_time);
 EXPORT_SYMBOL(loops_per_usec);
 
-/* String functions */
-EXPORT_SYMBOL(memcmp);
-EXPORT_SYMBOL(memmove);
-EXPORT_SYMBOL(strstr);
-EXPORT_SYMBOL(strcpy);
-EXPORT_SYMBOL(strchr);
-EXPORT_SYMBOL(strcmp);
-EXPORT_SYMBOL(strlen);
-EXPORT_SYMBOL(strcat);
-EXPORT_SYMBOL(strncat);
-EXPORT_SYMBOL(strncmp);
-EXPORT_SYMBOL(strncpy);
-
 /* Math functions */
 EXPORT_SYMBOL(__Udiv);
 EXPORT_SYMBOL(__Umod);
@@ -55,6 +45,7 @@
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__lshrdi3);
+EXPORT_SYMBOL(__negdi2);
 
 /* Memory functions */
 EXPORT_SYMBOL(__ioremap);
@@ -84,4 +75,4 @@
 EXPORT_SYMBOL(del_fast_timer);
 EXPORT_SYMBOL(schedule_usleep);
 #endif
-
+EXPORT_SYMBOL(csum_partial);

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com

