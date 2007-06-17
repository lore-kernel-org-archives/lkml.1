Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbXFQXoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbXFQXoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbXFQXmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:42:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37896 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761794AbXFQXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:42:48 -0400
Date: Mon, 18 Jun 2007 01:43:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/linux/kprobes.h: always offer show_registers()
	prototype
Message-ID: <20070617234304.GG3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow gcc to perform show_registers() type checking also with 
CONFIG_KPROBES=n.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 27 Apr 2007
- 27 Mar 2007

 include/linux/kprobes.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc4-mm1/include/linux/kprobes.h.old	2007-03-26 15:28:27.000000000 +0200
+++ linux-2.6.21-rc4-mm1/include/linux/kprobes.h	2007-03-26 15:32:23.000000000 +0200
@@ -163,7 +163,6 @@
 extern void arch_arm_kprobe(struct kprobe *p);
 extern void arch_disarm_kprobe(struct kprobe *p);
 extern int arch_init_kprobes(void);
-extern void show_registers(struct pt_regs *regs);
 extern kprobe_opcode_t *get_insn_slot(void);
 extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
@@ -241,4 +240,7 @@
 {
 }
 #endif				/* CONFIG_KPROBES */
+
+void show_registers(struct pt_regs *regs);
+
 #endif				/* _LINUX_KPROBES_H */

