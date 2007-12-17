Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbXLQTe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbXLQTe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760521AbXLQTbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:33 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2948 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759962AbXLQTb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:29 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-parisc@vger.kernel.org
Subject: [PATCH] arch/parisc/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:10 -0800
Message-Id: <1197919875-5288-11-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/parisc/kernel/cache.c    |    2 +-
 arch/parisc/kernel/hardware.c |    2 +-
 arch/parisc/kernel/signal.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 395bbce..e10d25d 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -305,7 +305,7 @@ flush_user_cache_page_non_current(struct vm_area_struct *vma,
 	/* save the current process space and pgd */
 	unsigned long space = mfsp(3), pgd = mfctl(25);
 
-	/* we don't mind taking interrups since they may not
+	/* we don't mind taking interrupts since they may not
 	 * do anything with user space, but we can't
 	 * be preempted here */
 	preempt_disable();
diff --git a/arch/parisc/kernel/hardware.c b/arch/parisc/kernel/hardware.c
index 04848b2..1909f88 100644
--- a/arch/parisc/kernel/hardware.c
+++ b/arch/parisc/kernel/hardware.c
@@ -1187,7 +1187,7 @@ static struct hp_hardware hp_hardware_list[] __devinitdata = {
 	{HPHW_FIO, 0x005, 0x000A9, 0x00, "AllegroLow Core PCI USB KB"}, 
 	{HPHW_FIO, 0x006, 0x000A9, 0x00, "AllegroHigh Core PCI SuperIO RS-232"}, 
 	{HPHW_FIO, 0x006, 0x000A9, 0x00, "AllegroHigh Core PCI USB KB"}, 
-	{HPHW_FIO, 0x007, 0x000A9, 0x0, "Miscelaneous PCI Plug-in"}, 
+	{HPHW_FIO, 0x007, 0x000A9, 0x0, "Miscellaneous PCI Plug-in"}, 
 	{HPHW_FIO, 0x00A, 0x000A9, 0x0, "Lego 360 Core PCI SuperIO RS-232"}, 
 	{HPHW_FIO, 0x00A, 0x000A9, 0x0, "Lego 360 Core PCI USB KB"}, 
 	{HPHW_FIO, 0x004, 0x00320, 0x0, "Metheus Frame Buffer"}, 
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 2ce3806..58fccc9 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -333,7 +333,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	flush_user_icache_range((unsigned long) &frame->tramp[0],
 			   (unsigned long) &frame->tramp[TRAMP_SIZE]);
 
-	/* TRAMP Words 0-4, Lenght 5 = SIGRESTARTBLOCK_TRAMP
+	/* TRAMP Words 0-4, Length 5 = SIGRESTARTBLOCK_TRAMP
 	 * TRAMP Words 5-9, Length 4 = SIGRETURN_TRAMP
 	 * So the SIGRETURN_TRAMP is at the end of SIGRESTARTBLOCK_TRAMP
 	 */
-- 
1.5.3.7.949.g2221a6

