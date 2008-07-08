Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYGHMPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYGHMPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbYGHMMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:12:49 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27259 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758934AbYGHMMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:12:45 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 51/58] microblaze_v5: setup.h string.h thread_info.h
Date: Tue,  8 Jul 2008 13:59:51 +0200
Message-Id: <1054e7643bd01351ba67273043203df322b49bea.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <6c03dcf8dbfd910ebf6c2f95db61d0456aa943e1.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
 <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
 <7a16429cfc461420883dbaa80c16047e5a1a91c1.1215517976.git.monstr@monstr.eu>
 <b6a0f3bceb0867c55613463fc43be5328fcedecd.1215517976.git.monstr@monstr.eu>
 <fc26823d77c7180b62022e2d4bcca3c4fe6de574.1215517976.git.monstr@monstr.eu>
 <64089967061955b7a29eb6d4e6269ff75b5442f2.1215517976.git.monstr@monstr.eu>
 <92e3ab88c2174acf4e25c474c1f68ffd4db72ca6.1215517976.git.monstr@monstr.eu>
 <5174afd0eaa5c6cb9344ea3217199e48899be313.1215517976.git.monstr@monstr.eu>
 <bcb94400dca62fb349d0ab1e0a6209291fdcdfc5.1215517976.git.monstr@monstr.eu>
 <5b2ed516b2e51d5117386c1b6eb814acc6e5a157.1215517976.git.monstr@monstr.eu>
 <421f4b613d4dbd983df1545a9a163347e5bd1c56.1215517976.git.monstr@monstr.eu>
 <0d39e8f03c487c004efa226c5ee81a81a8856768.1215517976.git.monstr@monstr.eu>
 <c4f477d71dd4cd2ae884b9c47756c9334f8dac18.1215517976.git.monstr@monstr.eu>
 <a98df8525bf9287d7a8b6077ff20dd61a055a98e.1215517976.git.monstr@monstr.eu>
 <c6651b096ee8a0691f94f8c19574302dbfb61ee4.1215517976.git.monstr@monstr.eu>
 <2ac3915482a9a50f7a4531908305b326baa2008e.1215517976.git.monstr@monstr.eu>
 <3c5eac3dbdbf538c727a4a8fe336cdd55650bb37.1215517976.git.monstr@monstr.eu>
 <6c03dcf8dbfd910ebf6c2f95db61d0456aa943e1.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/setup.h       |   34 ++++++++
 include/asm-microblaze/string.h      |   20 +++++
 include/asm-microblaze/thread_info.h |  154 ++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/setup.h
 create mode 100644 include/asm-microblaze/string.h
 create mode 100644 include/asm-microblaze/thread_info.h

diff --git a/include/asm-microblaze/setup.h b/include/asm-microblaze/setup.h
new file mode 100644
index 0000000..5705d36
--- /dev/null
+++ b/include/asm-microblaze/setup.h
@@ -0,0 +1,34 @@
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
+extern unsigned int boot_cpuid;
+extern int have_of;
+
+#define COMMAND_LINE_SIZE	256
+extern char cmd_line[COMMAND_LINE_SIZE];
+
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

