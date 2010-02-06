Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab0BFRso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:48:44 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:54876 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932592Ab0BFRr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:29 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 04/16] m68k: remove trailing space in messages
Date: Sat,  6 Feb 2010 18:47:11 +0100
Message-Id: <1265478443-31072-4-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:25.0986 (UTC) FILETIME=[71AEE820:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: linux-m68k@lists.linux-m68k.org
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 arch/m68k/kernel/traps.c |    2 +-
 arch/m68k/mac/config.c   |   10 +++++-----
 arch/m68k/q40/config.c   |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index aacd6d1..e533f32 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -455,7 +455,7 @@ static inline void access_error040(struct frame *fp)
 
 		if (do_page_fault(&fp->ptregs, addr, errorcode)) {
 #ifdef DEBUG
-		        printk("do_page_fault() !=0 \n");
+			printk("do_page_fault() !=0\n");
 #endif
 			if (user_mode(&fp->ptregs)){
 				/* delay writebacks after signal delivery */
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 0356da9..1c16b1b 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -148,7 +148,7 @@ static void mac_cache_card_flush(int writeback)
 void __init config_mac(void)
 {
 	if (!MACH_IS_MAC)
-		printk(KERN_ERR "ERROR: no Mac, but config_mac() called!! \n");
+		printk(KERN_ERR "ERROR: no Mac, but config_mac() called!!\n");
 
 	mach_sched_init = mac_sched_init;
 	mach_init_IRQ = mac_init_IRQ;
@@ -867,7 +867,7 @@ static void __init mac_identify(void)
 	 */
 	iop_preinit();
 
-	printk(KERN_INFO "Detected Macintosh model: %d \n", model);
+	printk(KERN_INFO "Detected Macintosh model: %d\n", model);
 
 	/*
 	 * Report booter data:
@@ -878,12 +878,12 @@ static void __init mac_identify(void)
 		mac_bi_data.videoaddr, mac_bi_data.videorow,
 		mac_bi_data.videodepth, mac_bi_data.dimensions & 0xFFFF,
 		mac_bi_data.dimensions >> 16);
-	printk(KERN_DEBUG " Videological 0x%lx phys. 0x%lx, SCC at 0x%lx \n",
+	printk(KERN_DEBUG " Videological 0x%lx phys. 0x%lx, SCC at 0x%lx\n",
 		mac_bi_data.videological, mac_orig_videoaddr,
 		mac_bi_data.sccbase);
-	printk(KERN_DEBUG " Boottime: 0x%lx GMTBias: 0x%lx \n",
+	printk(KERN_DEBUG " Boottime: 0x%lx GMTBias: 0x%lx\n",
 		mac_bi_data.boottime, mac_bi_data.gmtbias);
-	printk(KERN_DEBUG " Machine ID: %ld CPUid: 0x%lx memory size: 0x%lx \n",
+	printk(KERN_DEBUG " Machine ID: %ld CPUid: 0x%lx memory size: 0x%lx\n",
 		mac_bi_data.id, mac_bi_data.cpuid, mac_bi_data.memsize);
 
 	iop_init();
diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index 31ab3f0..ad10fec 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -126,7 +126,7 @@ static void q40_reset(void)
 {
         halted = 1;
         printk("\n\n*******************************************\n"
-		"Called q40_reset : press the RESET button!! \n"
+		"Called q40_reset : press the RESET button!!\n"
 		"*******************************************\n");
 	Q40_LED_ON();
 	while (1)
-- 
1.6.6.1

