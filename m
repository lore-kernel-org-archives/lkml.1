Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbYLPSKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbYLPSKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYLPSJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:09:10 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:49309 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYLPSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:09:08 -0500
X-BigFish: VPS5(z34a4jzzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBZEES-01-CDQ-01
Date: Tue, 16 Dec 2008 19:08:53 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 2/10] x86: microcode_amd: fix typos and trailing
	whitespaces in log messages
Message-ID: <20081216180853.GI7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:08:56.0999 (UTC) FILETIME=[5CEE1B70:01C95FA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index b5bc814..83a9fa3 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -10,7 +10,7 @@
  *  This driver allows to upgrade microcode on AMD
  *  family 0x10 and 0x11 processors.
  *
- *  Licensed unter the terms of the GNU General Public
+ *  Licensed under the terms of the GNU General Public
  *  License version 2. See file COPYING for details.
 */
 
@@ -133,7 +133,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 
 	if (!equiv_cpu_id) {
 		printk(KERN_ERR "microcode: CPU%d cpu_id "
-		       "not found in equivalent cpu table \n", cpu);
+		       "not found in equivalent cpu table\n", cpu);
 		return 0;
 	}
 
@@ -151,7 +151,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 					    NULL);
 		if ((!nb_pci_dev) ||
 		    (mc_header->nb_rev_id != nb_pci_dev->revision)) {
-			printk(KERN_ERR "microcode: CPU%d NB mismatch \n", cpu);
+			printk(KERN_ERR "microcode: CPU%d NB mismatch\n", cpu);
 			pci_dev_put(nb_pci_dev);
 			return 0;
 		}
@@ -165,7 +165,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 					    NULL);
 		if ((!sb_pci_dev) ||
 		    (mc_header->sb_rev_id != sb_pci_dev->revision)) {
-			printk(KERN_ERR "microcode: CPU%d SB mismatch \n", cpu);
+			printk(KERN_ERR "microcode: CPU%d SB mismatch\n", cpu);
 			pci_dev_put(sb_pci_dev);
 			return 0;
 		}
@@ -219,7 +219,7 @@ static void apply_microcode_amd(int cpu)
 	}
 
 	printk(KERN_INFO "microcode: CPU%d updated from revision "
-	       "0x%x to 0x%x \n",
+	       "0x%x to 0x%x\n",
 	       cpu_num, uci->cpu_sig.rev, mc_amd->hdr.patch_id);
 
 	uci->cpu_sig.rev = rev;
@@ -282,7 +282,7 @@ static int install_equiv_cpu_table(u8 *buf,
 
 	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
 		printk(KERN_ERR "microcode: error! "
-		       "Wrong microcode equivalnet cpu table\n");
+		       "Wrong microcode equivalent cpu table\n");
 		return 0;
 	}
 
-- 
1.6.0.4



