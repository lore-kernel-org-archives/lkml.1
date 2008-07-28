Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbYG1VQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbYG1VQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbYG1VJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:46 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbYG1VJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:44 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 19/24] x86: kernel/traps_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:26 -0300
Message-Id: <1217279371-4410-20-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-19-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-10-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-11-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-13-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-14-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-15-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-16-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-17-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-18-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-19-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/traps_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 3f18d73..9118b7d 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -493,7 +493,7 @@ unsigned __kprobes long oops_begin(void)
 	raw_local_irq_save(flags);
 	cpu = smp_processor_id();
 	if (!__raw_spin_trylock(&die_lock)) {
-		if (cpu == die_owner) 
+		if (cpu == die_owner)
 			/* nested oops. should stop eventually */;
 		else
 			__raw_spin_lock(&die_lock);
@@ -882,7 +882,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 	else if (user_mode(eregs))
 		regs = task_pt_regs(current);
 	/* Exception from kernel and interrupts are enabled. Move to
- 	   kernel process stack. */
+	   kernel process stack. */
 	else if (eregs->flags & X86_EFLAGS_IF)
 		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
 	if (eregs != regs)
@@ -1035,7 +1035,7 @@ asmlinkage void do_coprocessor_error(struct pt_regs *regs)
 
 asmlinkage void bad_intr(void)
 {
-	printk("bad interrupt"); 
+	printk("bad interrupt");
 }
 
 asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
@@ -1142,7 +1142,7 @@ void __init trap_init(void)
 	set_intr_gate(0, &divide_error);
 	set_intr_gate_ist(1, &debug, DEBUG_STACK);
 	set_intr_gate_ist(2, &nmi, NMI_STACK);
- 	set_system_gate_ist(3, &int3, DEBUG_STACK); /* int3 can be called from all */
+	set_system_gate_ist(3, &int3, DEBUG_STACK); /* int3 can be called from all */
 	set_system_gate(4, &overflow); /* int4 can be called from all */
 	set_intr_gate(5, &bounds);
 	set_intr_gate(6, &invalid_op);
-- 
1.5.4.5

