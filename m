Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYHBPut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYHBPut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYHBPul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:50:41 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:59997 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYHBPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:50:41 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/1] x86: coding style fixes to arch/x86/kernel/traps_64.c
Date: Sat,  2 Aug 2008 12:50:37 -0300
Message-Id: <1217692237-17603-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217692237-17603-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217692237-17603-1-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style of traps_64.c with improvements suggested by Ingo.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/traps_64.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index fe36d96..5df5d2e 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -84,8 +84,8 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%016lx>] %s%pS\n", address, reliable ?
-			"" : "? ", (void *) address);
+	printk(" [<%016lx>] %s%pS\n",
+			address, reliable ?	"" : "? ", (void *) address);
 }
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
@@ -98,8 +98,8 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 		[STACKFAULT_STACK - 1] = "#SS",
 		[MCE_STACK - 1] = "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
-		[N_EXCEPTION_STACKS ... N_EXCEPTION_STACKS + DEBUG_STKSZ /
-			EXCEPTION_STKSZ - 2] = "#DB[?]"
+		[N_EXCEPTION_STACKS ...
+			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
 #endif
 	};
 	unsigned k;
@@ -363,8 +363,10 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	unsigned long *irqstack =
 		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
 
-	/* debugging aid: "show_stack(NULL, NULL);" prints the
-	  back trace for this cpu. */
+	/*
+	 * debugging aid: "show_stack(NULL, NULL);" prints the
+	 * back trace for this cpu.
+	 */
 
 	if (sp == NULL) {
 		if (task)
-- 
1.5.4.5

