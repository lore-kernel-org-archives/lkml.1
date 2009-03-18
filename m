Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbZCRVwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbZCRVwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbZCRVn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:28 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757917AbZCRVn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:26 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 41/57] microblaze_v7: system.h processor.h
Date: Wed, 18 Mar 2009 21:31:08 +0100
Message-Id: <6d67a197ab9f953b93ef151d9a4a198ba0730ef5.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <4a7e63a56ea0490013724ffddb9f824caafdcbc6.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
 <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
 <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
 <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
 <35b0490d6a70779bdf2e2f55265c7c70a0dcbf1a.1237407249.git.monstr@monstr.eu>
 <1ca9913fc2b9ec220fdb9909f7929abfc38e41b1.1237407249.git.monstr@monstr.eu>
 <4a7e63a56ea0490013724ffddb9f824caafdcbc6.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/processor.h |   93 +++++++++++++++++++++++++++++++
 arch/microblaze/include/asm/system.h    |   91 ++++++++++++++++++++++++++++++
 2 files changed, 184 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/processor.h
 create mode 100644 arch/microblaze/include/asm/system.h

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
new file mode 100644
index 0000000..d8e1543
--- /dev/null
+++ b/arch/microblaze/include/asm/processor.h
@@ -0,0 +1,93 @@
+/*
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_PROCESSOR_H
+#define _ASM_MICROBLAZE_PROCESSOR_H
+
+#include <asm/ptrace.h>
+#include <asm/setup.h>
+#include <asm/registers.h>
+#include <asm/segment.h>
+
+# ifndef __ASSEMBLY__
+/* from kernel/cpu/mb.c */
+extern const struct seq_operations cpuinfo_op;
+
+# define cpu_relax()		barrier()
+# define cpu_sleep()		do {} while (0)
+# define prepare_to_copy(tsk)	do {} while (0)
+
+# endif /* __ASSEMBLY__ */
+
+/*
+ * User space process size: memory size
+ *
+ * TASK_SIZE on MMU cpu is usually 1GB. However, on no-MMU arch, both
+ * user processes and the kernel is on the same memory region. They
+ * both share the memory space and that is limited by the amount of
+ * physical memory. thus, we set TASK_SIZE == amount of total memory.
+ */
+# define TASK_SIZE	(0x81000000 - 0x80000000)
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+# define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's. We won't be using it
+ */
+# define TASK_UNMAPPED_BASE	0
+
+/* definition in include/linux/sched.h */
+struct task_struct;
+
+/* thread_struct is gone. use thread_info instead. */
+struct thread_struct { };
+# define INIT_THREAD	{ }
+
+/* Do necessary setup to start up a newly executed thread. */
+static inline void start_thread(struct pt_regs *regs,
+				unsigned long pc,
+				unsigned long usp)
+{
+	regs->pc = pc;
+	regs->r1 = usp;
+	regs->kernel_mode = 0;
+}
+
+/* Free all resources held by a thread. */
+static inline void release_thread(struct task_struct *dead_task)
+{
+}
+
+/* Free all resources held by a thread. */
+static inline void exit_thread(void)
+{
+}
+
+extern unsigned long thread_saved_pc(struct task_struct *t);
+
+extern unsigned long get_wchan(struct task_struct *p);
+
+/*
+ * create a kernel thread without removing it from tasklists
+ */
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+
+# define task_pt_regs(tsk) \
+		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
+
+# define KSTK_EIP(tsk)	(0)
+# define KSTK_ESP(tsk)	(0)
+
+#endif /* _ASM_MICROBLAZE_PROCESSOR_H */
diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
new file mode 100644
index 0000000..c4e3088
--- /dev/null
+++ b/arch/microblaze/include/asm/system.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SYSTEM_H
+#define _ASM_MICROBLAZE_SYSTEM_H
+
+#include <asm/registers.h>
+#include <asm/setup.h>
+#include <asm/irqflags.h>
+
+struct task_struct;
+struct thread_info;
+
+extern struct task_struct *_switch_to(struct thread_info *prev,
+					struct thread_info *next);
+
+#define switch_to(prev, next, last)					\
+	do {								\
+		(last) = _switch_to(task_thread_info(prev),		\
+					task_thread_info(next));	\
+	} while (0)
+
+#define smp_read_barrier_depends()	do {} while (0)
+#define read_barrier_depends()		do {} while (0)
+
+#define nop()			asm volatile ("nop")
+#define mb()			barrier()
+#define rmb()			mb()
+#define wmb()			mb()
+#define set_mb(var, value)	do { var = value; mb(); } while (0)
+#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
+
+#define smp_mb()		mb()
+#define smp_rmb()		rmb()
+#define smp_wmb()		wmb()
+
+void show_trace(struct task_struct *task, unsigned long *stack);
+void __bad_xchg(volatile void *ptr, int size);
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+								int size)
+{
+	unsigned long ret;
+	unsigned long flags;
+
+	switch (size) {
+	case 1:
+		local_irq_save(flags);
+		ret = *(volatile unsigned char *)ptr;
+		*(volatile unsigned char *)ptr = x;
+		local_irq_restore(flags);
+		break;
+
+	case 4:
+		local_irq_save(flags);
+		ret = *(volatile unsigned long *)ptr;
+		*(volatile unsigned long *)ptr = x;
+		local_irq_restore(flags);
+		break;
+	default:
+		__bad_xchg(ptr, size), ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+void disable_hlt(void);
+void enable_hlt(void);
+void default_idle(void);
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+void free_init_pages(char *what, unsigned long begin, unsigned long end);
+void free_initmem(void);
+extern char *klimit;
+extern void ret_from_fork(void);
+
+#ifdef CONFIG_DEBUG_FS
+extern struct dentry *of_debugfs_root;
+#endif
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_MICROBLAZE_SYSTEM_H */
-- 
1.5.5.1

