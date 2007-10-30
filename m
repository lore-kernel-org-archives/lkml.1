Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXJ3Jg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXJ3Jg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbXJ3JgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:36:00 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:36684 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483AbXJ3Jf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:35:59 -0400
Date: Tue, 30 Oct 2007 10:35:48 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093548.GR11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Add __negdi2 to exported symbols.
- Remove string functions from exported symbols.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 crisksyms.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/kernel/crisksyms.c linux-2.6.23/arch/cris/kernel/crisksyms.c
--- clean_linux-2.6.23/arch/cris/kernel/crisksyms.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/crisksyms.c	2007-10-23 13:52:07.000000000 +0200
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
