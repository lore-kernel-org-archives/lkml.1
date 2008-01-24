Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbYAZQEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbYAZQEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYAZP4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:07 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755440AbYAZP4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:02 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 52/52] [microblaze] setup.h string.h thread_info.h
Date: Thu, 24 Jan 2008 16:03:27 +0100
Message-Id: <e22e05ebd297de6f7d5dd0bf2eecf20d6749d571.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
 <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
 <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
 <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
 <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/setup.h       |   36 ++++++++
 include/asm-microblaze/string.h      |   22 +++++
 include/asm-microblaze/thread_info.h |  156 ++++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/setup.h
 create mode 100644 include/asm-microblaze/string.h
 create mode 100644 include/asm-microblaze/thread_info.h

diff --git a/include/asm-microblaze/setup.h b/include/asm-microblaze/setup.h
new file mode 100644
index 0000000..d8ea68e
--- /dev/null
+++ b/include/asm-microblaze/setup.h
@@ -0,0 +1,36 @@
+/*
+ * include/asm-microblaze/setup.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SETUP_H
+#define _ASM_SETUP_H
+
+#include <linux/init.h>
+
+#define COMMAND_LINE_SIZE	256
+
+int __init setup_early_printk(char *opt);
+void early_printk(const char *fmt, ...);
+void heartbeat(void);
+
+void system_timer_init(void);
+unsigned long do_gettimeoffset(void);
+void time_init(void);
+unsigned long long sched_clock(void);
+
+void __init setup_memory(void);
+void __init machine_early_init(const char *cmdline, unsigned int ram,
+			unsigned int fdt);
+
+void machine_restart(char *cmd);
+void machine_shutdown(void);
+void machine_halt(void);
+void machine_power_off(void);
+
+#endif /* _ASM_SETUP_H */
diff --git a/include/asm-microblaze/string.h b/include/asm-microblaze/string.h
new file mode 100644
index 0000000..6cd17e2
--- /dev/null
+++ b/include/asm-microblaze/string.h
@@ -0,0 +1,22 @@
+/*
+ * include/asm-microblaze/string.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_STRING_H
+#define _ASM_STRING_H
+
+#define __HAVE_ARCH_MEMSET
+#define __HAVE_ARCH_MEMCPY
+#define __HAVE_ARCH_MEMMOVE
+
+extern void *memset(void *, int, __kernel_size_t);
+extern void *memcpy(void *, const void *, __kernel_size_t);
+extern void *memmove(void *, const void *, __kernel_size_t);
+
+#endif /* _ASM_STRING_H */
diff --git a/include/asm-microblaze/thread_info.h b/include/asm-microblaze/thread_info.h
new file mode 100644
index 0000000..dbbdeef
--- /dev/null
+++ b/include/asm-microblaze/thread_info.h
@@ -0,0 +1,156 @@
+/*
+ * include/asm-microblaze/thread_info.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ * FIXME -- need review
+ */
+
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+/* we have 8k stack */
+#define THREAD_SHIFT		13
+#define THREAD_SIZE		(1 << THREAD_SHIFT)
+
+#ifndef __ASSEMBLY__
+# include <asm/processor.h>
+# include <asm/segment.h>
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants
+ *	 must also be changed
+ */
+
+struct cpu_context {
+	__u32	sp;
+	__u32	r2;
+	/* dedicated registers */
+	__u32	r13;
+	__u32	r14;
+	__u32	r15;
+	__u32	r16;
+	__u32	r17;
+	__u32	r18;
+	/* non-volatile registers */
+	__u32	r19;
+	__u32	r20;
+	__u32	r21;
+	__u32	r22;
+	__u32	r23;
+	__u32	r24;
+	__u32	r25;
+	__u32	r26;
+	__u32	r27;
+	__u32	r28;
+	__u32	r29;
+	__u32	r30;
+	/* special purpose registers */
+	__u32	msr;
+	__u32	ear;
+	__u32	esr;
+	__u32	fsr;
+};
+
+struct thread_info {
+	struct task_struct	*task; /* main task structure */
+	struct exec_domain	*exec_domain; /* execution domain */
+	unsigned long		flags; /* low level flags */
+	unsigned long		status; /* thread-synchronous flags */
+	__u32			cpu; /* current CPU */
+	__s32			preempt_count; /* 0 => preemptable,< 0 => BUG*/
+	mm_segment_t		addr_limit; /* thread address space */
+	struct restart_block	restart_block;
+
+	struct cpu_context	cpu_context;
+};
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= 1,			\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/* how to get the thread information struct from C */
+static inline struct thread_info *current_thread_info(void)
+{
+	register unsigned long sp asm("r1");
+
+	return (struct thread_info *)(sp & ~(THREAD_SIZE-1));
+}
+
+/* thread information allocation */
+#define alloc_thread_info(tsk) \
+		((struct thread_info *) __get_free_pages(GFP_KERNEL, 1))
+#define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
+
+#endif /* __ASSEMBLY__ */
+
+#define PREEMPT_ACTIVE		0x10000000
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may
+ *   need to access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0 /* syscall trace active */
+#define TIF_NOTIFY_RESUME	1 /* resumption notification requested */
+#define TIF_SIGPENDING		2 /* signal pending */
+#define TIF_NEED_RESCHED	3 /* rescheduling necessary */
+/* restore singlestep on return to user mode */
+#define TIF_SINGLESTEP		4
+#define TIF_IRET		5 /* return with iret */
+#define TIF_MEMDIE		6
+/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_POLLING_NRFLAG	16
+
+#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
+#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
+#define _TIF_IRET		(1<<TIF_IRET)
+#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FFFE
+/* work to do on any return to u-space */
+#define _TIF_ALLWORK_MASK	0x0000FFFF
+
+/*
+ * Thread-synchronous status.
+ *
+ * This is different from the flags in that nobody else
+ * ever touches our thread-synchronous status, so we don't
+ * have to worry about atomic accesses.
+ */
+/* FPU was used by this task this quantum (SMP) */
+#define TS_USEDFPU		0x0001
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_THREAD_INFO_H */
-- 
1.5.4.rc4.14.g6fc74

