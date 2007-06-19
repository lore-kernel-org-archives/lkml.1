Return-Path: <linux-kernel-owner+w=401wt.eu-S934221AbXFSU1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221AbXFSU1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764168AbXFSU0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:26:48 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33667 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764222AbXFSU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:26:47 -0400
Date: Tue, 19 Jun 2007 22:27:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] more MOMENCO_JAGUAR_ATX removal
Message-ID: <20070619202704.GG12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the few leftovers of the MOMENCO_JAGUAR_ATX removal.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/net/Kconfig    |    2 +-
 include/asm-mips/war.h |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc4-mm2/drivers/net/Kconfig.old	2007-06-18 15:24:49.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/net/Kconfig	2007-06-18 15:25:02.000000000 +0200
@@ -2362,7 +2362,7 @@
 
 config MV643XX_ETH
 	tristate "MV-643XX Ethernet support"
-	depends on MOMENCO_OCELOT_C || MOMENCO_JAGUAR_ATX || MV64360 || MV64X60 || MOMENCO_OCELOT_3 || (PPC_MULTIPLATFORM && PPC32)
+	depends on MOMENCO_OCELOT_C || MV64360 || MV64X60 || MOMENCO_OCELOT_3 || (PPC_MULTIPLATFORM && PPC32)
 	select MII
 	help
 	  This driver supports the gigabit Ethernet on the Marvell MV643XX
--- linux-2.6.22-rc4-mm2/include/asm-mips/war.h.old	2007-06-18 15:25:20.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/asm-mips/war.h	2007-06-18 15:26:03.000000000 +0200
@@ -171,8 +171,7 @@
  * On the RM9000 there is a problem which makes the CreateDirtyExclusive
  * cache operation unusable on SMP systems.
  */
-#if defined(CONFIG_MOMENCO_JAGUAR_ATX) || defined(CONFIG_PMC_YOSEMITE) || \
-    defined(CONFIG_BASLER_EXCITE)
+#if defined(CONFIG_PMC_YOSEMITE) || defined(CONFIG_BASLER_EXCITE)
 #define  RM9000_CDEX_SMP_WAR		1
 #endif
 
@@ -181,8 +180,8 @@
  * where invalid instructions in the same I-cache line worth of instructions
  * being fetched may case spurious exceptions.
  */
-#if defined(CONFIG_MOMENCO_JAGUAR_ATX) || defined(CONFIG_MOMENCO_OCELOT_3) || \
-    defined(CONFIG_PMC_YOSEMITE) || defined(CONFIG_BASLER_EXCITE)
+#if defined(CONFIG_MOMENCO_OCELOT_3) || defined(CONFIG_PMC_YOSEMITE) || \
+    defined(CONFIG_BASLER_EXCITE)
 #define ICACHE_REFILLS_WORKAROUND_WAR	1
 #endif
 

