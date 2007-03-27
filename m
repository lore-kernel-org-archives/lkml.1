Return-Path: <linux-kernel-owner+w=401wt.eu-S933876AbXC0BBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbXC0BBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933877AbXC0BBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:01:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35461 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933876AbXC0BBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:01:45 -0400
Date: Tue, 27 Mar 2007 03:01:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/linux/kprobes.h: always offer show_registers()
Message-ID: <20070327010147.GS16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow gcc to perform show_registers() type checking also with 
CONFIG_KPROBES=n.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

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

