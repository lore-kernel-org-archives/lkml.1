Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbYG1VPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbYG1VPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbYG1VJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:44 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbYG1VJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:43 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 17/24] x86: kernel/process_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:24 -0300
Message-Id: <1217279371-4410-18-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-17-git-send-email-gustavo@las.ic.unicamp.br>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces and tabs.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/process_64.c |   78 +++++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3fb62a7..ea31c20 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -177,28 +177,28 @@ void __show_regs(struct pt_regs * regs)
 	printk("RBP: %016lx R08: %016lx R09: %016lx\n",
 	       regs->bp, regs->r8, regs->r9);
 	printk("R10: %016lx R11: %016lx R12: %016lx\n",
-	       regs->r10, regs->r11, regs->r12); 
+	       regs->r10, regs->r11, regs->r12);
 	printk("R13: %016lx R14: %016lx R15: %016lx\n",
-	       regs->r13, regs->r14, regs->r15); 
+	       regs->r13, regs->r14, regs->r15);
 
-	asm("movl %%ds,%0" : "=r" (ds)); 
-	asm("movl %%cs,%0" : "=r" (cs)); 
-	asm("movl %%es,%0" : "=r" (es)); 
+	asm("movl %%ds,%0" : "=r" (ds));
+	asm("movl %%cs,%0" : "=r" (cs));
+	asm("movl %%es,%0" : "=r" (es));
 	asm("movl %%fs,%0" : "=r" (fsindex));
 	asm("movl %%gs,%0" : "=r" (gsindex));
 
 	rdmsrl(MSR_FS_BASE, fs);
-	rdmsrl(MSR_GS_BASE, gs); 
-	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs); 
+	rdmsrl(MSR_GS_BASE, gs);
+	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs);
 
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n", 
-	       fs,fsindex,gs,gsindex,shadowgs); 
-	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
+	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	       fs,fsindex,gs,gsindex,shadowgs);
+	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0);
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
 
 	get_debugreg(d0, 0);
@@ -362,10 +362,10 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 		if (test_thread_flag(TIF_IA32))
 			err = do_set_thread_area(p, -1,
 				(struct user_desc __user *)childregs->si, 0);
-		else 			
-#endif	 
-			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8); 
-		if (err) 
+		else
+#endif
+			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8);
+		if (err)
 			goto out;
 	}
 	err = 0;
@@ -552,13 +552,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	load_sp0(tss, next);
 
-	/* 
+	/*
 	 * Switch DS and ES.
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	savesegment(es, prev->es);
 	if (unlikely(next->es | prev->es))
-		loadsegment(es, next->es); 
+		loadsegment(es, next->es);
 
 	savesegment(ds, prev->ds);
 	if (unlikely(next->ds | prev->ds))
@@ -584,7 +584,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	arch_leave_lazy_cpu_mode();
 
-	/* 
+	/*
 	 * Switch FS and GS.
 	 *
 	 * Segment register != 0 always requires a reload.  Also
@@ -593,13 +593,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	if (unlikely(fsindex | next->fsindex | prev->fs)) {
 		loadsegment(fs, next->fsindex);
-		/* 
+		/*
 		 * Check if the user used a selector != 0; if yes
 		 *  clear 64bit base, since overloaded base is always
 		 *  mapped to the Null selector
 		 */
 		if (fsindex)
-			prev->fs = 0;				
+			prev->fs = 0;
 	}
 	/* when next process has a 64bit base use it */
 	if (next->fs)
@@ -609,7 +609,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (unlikely(gsindex | next->gsindex | prev->gs)) {
 		load_gs_index(next->gsindex);
 		if (gsindex)
-			prev->gs = 0;				
+			prev->gs = 0;
 	}
 	if (next->gs)
 		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
@@ -618,12 +618,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/* Must be after DS reload */
 	unlazy_fpu(prev_p);
 
-	/* 
+	/*
 	 * Switch the PDA and FPU contexts.
 	 */
 	prev->usersp = read_pda(oldrsp);
 	write_pda(oldrsp, next->usersp);
-	write_pda(pcurrent, next_p); 
+	write_pda(pcurrent, next_p);
 
 	write_pda(kernelstack,
 		  (unsigned long)task_stack_page(next_p) +
@@ -726,51 +726,51 @@ unsigned long get_wchan(struct task_struct *p)
 	int count = 0;
 
 	if (!p || p == current || p->state==TASK_RUNNING)
-		return 0; 
+		return 0;
 	stack = (unsigned long)task_stack_page(p);
 	if (p->thread.sp < stack || p->thread.sp > stack+THREAD_SIZE)
 		return 0;
 	fp = *(u64 *)(p->thread.sp);
-	do { 
+	do {
 		if (fp < (unsigned long)stack ||
 		    fp > (unsigned long)stack+THREAD_SIZE)
-			return 0; 
+			return 0;
 		ip = *(u64 *)(fp+8);
 		if (!in_sched_functions(ip))
 			return ip;
-		fp = *(u64 *)fp; 
-	} while (count++ < 16); 
+		fp = *(u64 *)fp;
+	} while (count++ < 16);
 	return 0;
 }
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
-{ 
-	int ret = 0; 
+{
+	int ret = 0;
 	int doit = task == current;
 	int cpu;
 
-	switch (code) { 
+	switch (code) {
 	case ARCH_SET_GS:
 		if (addr >= TASK_SIZE_OF(task))
-			return -EPERM; 
+			return -EPERM;
 		cpu = get_cpu();
-		/* handle small bases via the GDT because that's faster to 
+		/* handle small bases via the GDT because that's faster to
 		   switch. */
-		if (addr <= 0xffffffff) {  
-			set_32bit_tls(task, GS_TLS, addr); 
-			if (doit) { 
+		if (addr <= 0xffffffff) {
+			set_32bit_tls(task, GS_TLS, addr);
+			if (doit) {
 				load_TLS(&task->thread, cpu);
-				load_gs_index(GS_TLS_SEL); 
+				load_gs_index(GS_TLS_SEL);
 			}
-			task->thread.gsindex = GS_TLS_SEL; 
+			task->thread.gsindex = GS_TLS_SEL;
 			task->thread.gs = 0;
-		} else { 
+		} else {
 			task->thread.gsindex = 0;
 			task->thread.gs = addr;
 			if (doit) {
 				load_gs_index(0);
 				ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
-			} 
+			}
 		}
 		put_cpu();
 		break;
-- 
1.5.4.5

