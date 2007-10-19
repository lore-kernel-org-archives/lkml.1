Return-Path: <linux-kernel-owner+w=401wt.eu-S966758AbXJSEeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966758AbXJSEeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXJSEeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:34:00 -0400
Received: from rex.snapgear.com ([203.143.235.140]:46174 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752491AbXJSEd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:33:59 -0400
Date: Fri, 19 Oct 2007 14:33:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190433.l9J4XHOS004934@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove use of undefined symbols in setup.c
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove use of undefined symbols CONFIG_TELOS, CONFIG_M68EZ328ADS
and CONFIG_ALMA_ANS.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/kernel/setup.c linux-2.6.23-uc0/arch/m68knommu/kernel/setup.c
--- linux-2.6.23/arch/m68knommu/kernel/setup.c	2007-10-19 10:30:54.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/kernel/setup.c	2007-10-19 10:35:38.000000000 +1000
@@ -151,27 +148,15 @@ void setup_arch(char **cmdline_p)
 #ifdef CONFIG_ELITE
 	printk(KERN_INFO "Modified for M5206eLITE by Rob Scott, rscott@mtrob.fdns.net\n");
 #endif
-#ifdef CONFIG_TELOS
-	printk(KERN_INFO "Modified for Omnia ToolVox by James D. Schettine, james@telos-systems.com\n");
-#endif
 #endif
 	printk(KERN_INFO "Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne\n");
 
 #if defined( CONFIG_PILOT ) && defined( CONFIG_M68328 )
 	printk(KERN_INFO "TRG SuperPilot FLASH card support <info@trgnet.com>\n");
 #endif
-
 #if defined( CONFIG_PILOT ) && defined( CONFIG_M68EZ328 )
 	printk(KERN_INFO "PalmV support by Lineo Inc. <jeff@uclinux.com>\n");
 #endif
-
-#ifdef CONFIG_M68EZ328ADS
-	printk(KERN_INFO "M68EZ328ADS board support (C) 1999 Vladimir Gurevich <vgurevic@cisco.com>\n");
-#endif
-
-#ifdef CONFIG_ALMA_ANS
-	printk(KERN_INFO "Alma Electronics board support (C) 1999 Vladimir Gurevich <vgurevic@cisco.com>\n");
-#endif
 #if defined (CONFIG_M68360)
 	printk(KERN_INFO "QUICC port done by SED Systems <hamilton@sedsystems.ca>,\n");
 	printk(KERN_INFO "based on 2.0.38 port by Lineo Inc. <mleslie@lineo.com>.\n");
