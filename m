Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZHNL0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZHNL0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZHNL0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:26:21 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49883 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbZHNL0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:17 -0400
Message-Id: <20090814112616.769552700@de.ibm.com>
References: <20090814112517.982007860@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 13:25:35 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 18/34] hibernation: remove dead file
Content-Disposition: inline; filename=117-pm-dead-file.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

There is no caller of do_after_copyback() anywhere. Remove it.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/power/Makefile    |    1 -
 arch/s390/power/swsusp_64.c |   17 -----------------
 2 files changed, 18 deletions(-)

Index: quilt-2.6/arch/s390/power/Makefile
===================================================================
--- quilt-2.6.orig/arch/s390/power/Makefile
+++ quilt-2.6/arch/s390/power/Makefile
@@ -4,5 +4,4 @@
 
 obj-$(CONFIG_HIBERNATION) += suspend.o
 obj-$(CONFIG_HIBERNATION) += swsusp.o
-obj-$(CONFIG_HIBERNATION) += swsusp_64.o
 obj-$(CONFIG_HIBERNATION) += swsusp_asm64.o
Index: quilt-2.6/arch/s390/power/swsusp_64.c
===================================================================
--- quilt-2.6.orig/arch/s390/power/swsusp_64.c
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * Support for suspend and resume on s390
- *
- * Copyright IBM Corp. 2009
- *
- * Author(s): Hans-Joachim Picht <hans@linux.vnet.ibm.com>
- *
- */
-
-#include <asm/system.h>
-#include <linux/interrupt.h>
-
-void do_after_copyback(void)
-{
-	mb();
-}
-

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

