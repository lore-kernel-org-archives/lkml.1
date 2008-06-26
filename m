Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbYFZNDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbYFZNDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbYFZMpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:45:20 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23814 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760432AbYFZMpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:45:14 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 53/60] microblaze_v4: setup.h string.h thread_info.h
Date: Thu, 26 Jun 2008 14:30:22 +0200
Message-Id: <1214483429-32360-54-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-53-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
 <1214483429-32360-39-git-send-email-monstr@seznam.cz>
 <1214483429-32360-40-git-send-email-monstr@seznam.cz>
 <1214483429-32360-41-git-send-email-monstr@seznam.cz>
 <1214483429-32360-42-git-send-email-monstr@seznam.cz>
 <1214483429-32360-43-git-send-email-monstr@seznam.cz>
 <1214483429-32360-44-git-send-email-monstr@seznam.cz>
 <1214483429-32360-45-git-send-email-monstr@seznam.cz>
 <1214483429-32360-46-git-send-email-monstr@seznam.cz>
 <1214483429-32360-47-git-send-email-monstr@seznam.cz>
 <1214483429-32360-48-git-send-email-monstr@seznam.cz>
 <1214483429-32360-49-git-send-email-monstr@seznam.cz>
 <1214483429-32360-50-git-send-email-monstr@seznam.cz>
 <1214483429-32360-51-git-send-email-monstr@seznam.cz>
 <1214483429-32360-52-git-send-email-monstr@seznam.cz>
 <1214483429-32360-53-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/setup.h       |   41 +++++++++
 include/asm-microblaze/string.h      |   20 +++++
 include/asm-microblaze/thread_info.h |  154 ++++++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/setup.h
 create mode 100644 include/asm-microblaze/string.h
 create mode 100644 include/asm-microblaze/thread_info.h

diff --git a/include/asm-microblaze/setup.h b/include/asm-microblaze/setup.h
new file mode 100644
index 0000000..9de20af
--- /dev/null
+++ b/include/asm-microblaze/setup.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SETUP_H
+#define _ASM_MICROBLAZE_SETUP_H
+
+#include <linux/init.h>
+
+extern unsigned int boot_cpuid;
+extern int have_of;
+
+#define COMMAND_LINE_SIZE	256
+extern char cmd_line[COMMAND_LINE_SIZE];
+
+int __init setup_early_printk(char *opt);
+void early_printk(const char *fmt, ...);
+
+#ifdef CONFIG_HEART_BEAT
+void heartbeat(void);
+#endif
+
+void system_timer_init(void);
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
+#endif /* _ASM_MICROBLAZE_SETUP_H */
diff --git a/include/asm-microblaze/string.h b/include/asm-microblaze/string.h
new file mode 100644
index 0000000..52a14a3
--- /dev/null
+++ b/include/asm-microblaze/string.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_STRING_H
+#define _ASM_MICROBLAZE_STRING_H
+
+#define __HAVE_ARCH_MEMSET
+#define __HAVE_ARCH_MEMCPY
+#define __HAVE_ARCH_MEMMOVE
+
+extern void *memset(void *, int, __kernel_size_t);
+extern void *memcpy(void *, const void *, __kernel_size_t);
+extern void *memmove(void *, const void *, __kernel_size_t);
+
+#endif /* _ASM_MICROBLAZE_STRING_H */
diff --git a/include/asm-microblaze/thread_info.h b/include/asm-microblaze/thread_info.h
new file mode 100644
index 0000000..d04d195
--- /dev/null
+++ b/include/asm-microblaze/thread_info.h
@@ -0,0 +1,154 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_THREAD_INFO_H
+#define _ASM_MICROBLAZE_THREAD_INFO_H
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
+	__u32	r1; /* stack pointer */
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
+	/* r31 is used as current task pointer */
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
+#endif /* _ASM_MICROBLAZE_THREAD_INFO_H */
-- 
1.5.4.GIT

