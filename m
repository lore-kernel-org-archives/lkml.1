Return-Path: <linux-kernel-owner+w=401wt.eu-S1764736AbXGWIzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764736AbXGWIzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762979AbXGWIyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:54:14 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40242 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770AbXGWIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:54:11 -0400
Message-Id: <20070723085656.011043552@de.ibm.com>
References: <20070723084548.394178614@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 10:45:53 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 5/9] sclp: kill unused SCLP config option.
Content-Disposition: inline; filename=005-sclp-kconfig.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

sclp is always compiled in.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/Kconfig |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: quilt-2.6/drivers/s390/char/Kconfig
===================================================================
--- quilt-2.6.orig/drivers/s390/char/Kconfig
+++ quilt-2.6/drivers/s390/char/Kconfig
@@ -44,15 +44,9 @@ config CCW_CONSOLE
 	depends on TN3215_CONSOLE || TN3270_CONSOLE
 	default y
 
-config SCLP
-	bool "Support for SCLP"
-	depends on S390
-	help
-	  Include support for the SCLP interface to the service element.
-
 config SCLP_TTY
 	bool "Support for SCLP line mode terminal"
-	depends on SCLP
+	depends on S390
 	help
 	  Include support for IBM SCLP line-mode terminals.
 
@@ -65,7 +59,7 @@ config SCLP_CONSOLE
 
 config SCLP_VT220_TTY
 	bool "Support for SCLP VT220-compatible terminal"
-	depends on SCLP
+	depends on S390
 	help
 	  Include support for an IBM SCLP VT220-compatible terminal.
 
@@ -78,7 +72,7 @@ config SCLP_VT220_CONSOLE
 
 config SCLP_CPI
 	tristate "Control-Program Identification"
-	depends on SCLP
+	depends on S390
 	help
 	  This option enables the hardware console interface for system
 	  identification. This is commonly used for workload management and

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

