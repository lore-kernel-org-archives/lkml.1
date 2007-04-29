Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbXD2LE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbXD2LE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbXD2LBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbXD2Kw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/48] x86_64: Minor white space cleanup in traps.c
Message-Id: <20070429105254.035DF15108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/traps.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
@@ -426,8 +426,7 @@ void show_registers(struct pt_regs *regs
 	const int cpu = smp_processor_id();
 	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
 
-		rsp = regs->rsp;
-
+	rsp = regs->rsp;
 	printk("CPU %d ", cpu);
 	__show_regs(regs);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
@@ -438,7 +437,6 @@ void show_registers(struct pt_regs *regs
 	 * time of the fault..
 	 */
 	if (in_kernel) {
-
 		printk("Stack: ");
 		_show_stack(NULL, regs, (unsigned long*)rsp);
 
