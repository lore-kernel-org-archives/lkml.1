Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYEDQvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYEDQvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYEDQv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:51:28 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:34427 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751030AbYEDQv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:51:26 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 50/56] microblaze_v2: setup.h string.h thread_info.h
Date: Sun,  4 May 2008 13:41:39 +0200
Message-Id: <53e5b22838d017b7cf7f44c4bafe5f7e253732ce.1209897267.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
 <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
 <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
 <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu>
 <643084ee3819dd169cad3c4e3565c5ff20dd3429.1209897267.git.monstr@monstr.eu>
 <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/setup.h       |   42 +++++++++
 include/asm-microblaze/string.h      |   22 +++++
 include/asm-microblaze/thread_info.h |  155 ++++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/setup.h
 create mode 100644 include/asm-microblaze/string.h
 create mode 100644 include/asm-microblaze/thread_info.h

diff --git a/include/asm-microblaze/setup.h b/include/asm-microblaze/setup.h
new file mode 100644
index 0000000..ba4bf7d
--- /dev/null
+++ b/include/asm-microblaze/setup.h
@@ -0,0 +1,42 @@
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
+#ifndef _ASM_MICROBLAZE_SETUP_H
+#define _ASM_MICROBLAZE_SETUP_H
+
+#include <linux/init.h>
+
+extern unsigned int boot_cpuid;
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
+#endif /* _ASM_MICROBLAZE_SETUP_H */
diff --git a/include/asm-microblaze/string.h b/include/asm-microblaze/string.h
new file mode 100644
index 0000000..bf2051c
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
index 0000000..8a46c14
--- /dev/null
+++ b/include/asm-microblaze/thread_info.h
@@ -0,0 +1,155 @@
+/*
+ * include/asm-microblaze/thread_info.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
+#endif /* _ASM_MICROBLAZE_THREAD_INFO_H */
-- 
1.5.4.GIT

