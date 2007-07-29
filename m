Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbXG2O57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbXG2O57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764093AbXG2O44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:56:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47754 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764084AbXG2O4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:56:55 -0400
Date: Sun, 29 Jul 2007 16:56:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/i386/mach-es7000/es7000plat.c: cleanups
Message-ID: <20070729145632.GE16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make some needlessly global functions static
- #if 0 the unused es7000_stop_cpu()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 6 Jul 2007

 arch/i386/mach-es7000/es7000plat.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc6-mm1/arch/i386/mach-es7000/es7000plat.c.old	2007-07-05 15:49:14.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/mach-es7000/es7000plat.c	2007-07-05 15:50:33.000000000 +0200
@@ -45,11 +45,11 @@
  * ES7000 Globals
  */
 
-volatile unsigned long	*psai = NULL;
-struct mip_reg		*mip_reg;
-struct mip_reg		*host_reg;
-int 			mip_port;
-unsigned long		mip_addr, host_addr;
+static volatile unsigned long	*psai = NULL;
+static struct mip_reg		*mip_reg;
+static struct mip_reg		*host_reg;
+static int 			mip_port;
+static unsigned long		mip_addr, host_addr;
 
 /*
  * GSI override for ES7000 platforms.
@@ -240,6 +240,7 @@
 
 }
 
+#if 0
 int
 es7000_stop_cpu(int cpu)
 {
@@ -259,6 +260,7 @@
 	return 0;
 
 }
+#endif  /*  0  */
 
 void __init
 es7000_sw_apic()

