Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab0BFRtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:49:21 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:63443 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932398Ab0BFRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:28 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 11/16] blackfin: remove trailing space in messages
Date: Sat,  6 Feb 2010 18:47:18 +0100
Message-Id: <1265478443-31072-11-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:26.0024 (UTC) FILETIME=[71B4B480:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |   10 +++++-----
 arch/blackfin/kernel/traps.c        |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 924c002..26403d1 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -91,7 +91,7 @@ late_initcall(proc_dma_init);
  */
 int request_dma(unsigned int channel, const char *device_id)
 {
-	pr_debug("request_dma() : BEGIN \n");
+	pr_debug("request_dma() : BEGIN\n");
 
 	if (device_id == NULL)
 		printk(KERN_WARNING "request_dma(%u): no device_id given\n", channel);
@@ -107,7 +107,7 @@ int request_dma(unsigned int channel, const char *device_id)
 #endif
 
 	if (atomic_cmpxchg(&dma_ch[channel].chan_status, 0, 1)) {
-		pr_debug("DMA CHANNEL IN USE  \n");
+		pr_debug("DMA CHANNEL IN USE\n");
 		return -EBUSY;
 	}
 
@@ -131,7 +131,7 @@ int request_dma(unsigned int channel, const char *device_id)
 	 * you have to request DMA, before doing any operations on
 	 * descriptor/channel
 	 */
-	pr_debug("request_dma() : END  \n");
+	pr_debug("request_dma() : END\n");
 	return 0;
 }
 EXPORT_SYMBOL(request_dma);
@@ -171,7 +171,7 @@ static void clear_dma_buffer(unsigned int channel)
 
 void free_dma(unsigned int channel)
 {
-	pr_debug("freedma() : BEGIN \n");
+	pr_debug("freedma() : BEGIN\n");
 	BUG_ON(channel >= MAX_DMA_CHANNELS ||
 			!atomic_read(&dma_ch[channel].chan_status));
 
@@ -185,7 +185,7 @@ void free_dma(unsigned int channel)
 	/* Clear the DMA Variable in the Channel */
 	atomic_set(&dma_ch[channel].chan_status, 0);
 
-	pr_debug("freedma() : END \n");
+	pr_debug("freedma() : END\n");
 }
 EXPORT_SYMBOL(free_dma);
 
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index d3cbcd6..8e42501 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -1096,7 +1096,7 @@ void dump_bfin_mem(struct pt_regs *fp)
 			/* And the last RETI points to the current userspace context */
 			if ((fp + 1)->pc >= current->mm->start_code &&
 			    (fp + 1)->pc <= current->mm->end_code) {
-				verbose_printk(KERN_NOTICE "It might be better to look around here : \n");
+				verbose_printk(KERN_NOTICE "It might be better to look around here :\n");
 				verbose_printk(KERN_NOTICE "-------------------------------------------\n");
 				show_regs(fp + 1);
 				verbose_printk(KERN_NOTICE "-------------------------------------------\n");
-- 
1.6.6.1

