Return-Path: <linux-kernel-owner+w=401wt.eu-S1764511AbYCWIf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764511AbYCWIf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbYCWIKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:11 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2294 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759660AbYCWIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 003/148] include/asm-x86/a.out-core.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:38 -0700
Message-Id: <1206259443-13210-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/a.out-core.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/a.out-core.h b/include/asm-x86/a.out-core.h
index d2b6e11..714207a 100644
--- a/include/asm-x86/a.out-core.h
+++ b/include/asm-x86/a.out-core.h
@@ -29,8 +29,9 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->magic = CMAGIC;
 	dump->start_code = 0;
 	dump->start_stack = regs->sp & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
+	dump->u_tsize = ((unsigned long)current->mm->end_code) >> PAGE_SHIFT;
+	dump->u_dsize = ((unsigned long)(current->mm->brk + (PAGE_SIZE - 1)))
+			>> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
 	dump->u_debugreg[0] = current->thread.debugreg0;
@@ -43,7 +44,8 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->u_debugreg[7] = current->thread.debugreg7;
 
 	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
+		dump->u_ssize = ((unsigned long)(TASK_SIZE - dump->start_stack))
+				>> PAGE_SHIFT;
 
 	dump->regs.bx = regs->bx;
 	dump->regs.cx = regs->cx;
@@ -55,7 +57,7 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->regs.ds = (u16)regs->ds;
 	dump->regs.es = (u16)regs->es;
 	dump->regs.fs = (u16)regs->fs;
-	savesegment(gs,gs);
+	savesegment(gs, gs);
 	dump->regs.orig_ax = regs->orig_ax;
 	dump->regs.ip = regs->ip;
 	dump->regs.cs = (u16)regs->cs;
@@ -63,7 +65,7 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->regs.sp = regs->sp;
 	dump->regs.ss = (u16)regs->ss;
 
-	dump->u_fpvalid = dump_fpu (regs, &dump->i387);
+	dump->u_fpvalid = dump_fpu(regs, &dump->i387);
 }
 
 #endif /* CONFIG_X86_32 */
-- 
1.5.4.rc2

