Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbYAZQI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbYAZQI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbYAZP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:57:24 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755980AbYAZP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:57:20 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 42/52] [microblaze] system.h pvr.h processor.h
Date: Thu, 24 Jan 2008 16:03:17 +0100
Message-Id: <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
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
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/processor.h |   89 +++++++++++++++++
 include/asm-microblaze/pvr.h       |  185 ++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/system.h    |  185 ++++++++++++++++++++++++++++++++++++
 3 files changed, 459 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/processor.h
 create mode 100644 include/asm-microblaze/pvr.h
 create mode 100644 include/asm-microblaze/system.h

diff --git a/include/asm-microblaze/processor.h b/include/asm-microblaze/processor.h
new file mode 100644
index 0000000..15cda64
--- /dev/null
+++ b/include/asm-microblaze/processor.h
@@ -0,0 +1,89 @@
+/*
+ * include/asm-microblaze/processor.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_PROCESSOR_H
+#define _ASM_PROCESSOR_H
+
+#include <asm/ptrace.h>
+#include <asm/setup.h>
+
+/*
+ * User space process size: memory size
+ *
+ * TASK_SIZE on MMU cpu is usually 1GB. However, on no-MMU arch, both
+ * user processes and the kernel is on the same memory region. They
+ * both share the memory space and that is limited by the amount of
+ * physical memory. thus, we set TASK_SIZE == amount of total memory.
+ */
+
+#define TASK_SIZE	(0x81000000 - 0x80000000)
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's. We won't be using it
+ */
+#define TASK_UNMAPPED_BASE	0
+
+struct task_struct;
+
+/* thread_struct is gone. use thread_info instead. */
+struct thread_struct { };
+#define INIT_THREAD	{ }
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
+/* FIXME */
+#define cpu_relax()		do {} while (0)
+#define prepare_to_copy(tsk)	do {} while (0)
+
+/*
+ * create a kernel thread without removing it from tasklists
+ */
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+
+/* #define task_thread_info(task) (task)->thread_info */
+/* #define task_stack_page(task) ((void*)((task)->thread_info)) */
+
+#define task_pt_regs(tsk) \
+		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
+
+
+#define KSTK_EIP(tsk)	(0)
+#define KSTK_ESP(tsk)	(0)
+
+#endif /* _ASM_PROCESSOR_H */
diff --git a/include/asm-microblaze/pvr.h b/include/asm-microblaze/pvr.h
new file mode 100644
index 0000000..f76bb6e
--- /dev/null
+++ b/include/asm-microblaze/pvr.h
@@ -0,0 +1,185 @@
+/*
+ * include/asm-microblaze/pvr.h
+ *
+ * Support for the MicroBlaze PVR (Processor Version Register)
+ *
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+#ifndef _ASM_PVR_H
+#define _ASM_PVR_H
+
+#define PVR_MSR_BIT 0x400
+
+struct pvr_s {
+	unsigned pvr[16];
+};
+
+/* The following taken from Xilinx's standalone BSP pvr.h */
+
+/* Basic PVR mask */
+#define PVR0_PVR_FULL_MASK		0x80000000
+#define PVR0_USE_BARREL_MASK		0x40000000
+#define PVR0_USE_DIV_MASK		0x20000000
+#define PVR0_USE_HW_MUL_MASK		0x10000000
+#define PVR0_USE_FPU_MASK		0x08000000
+#define PVR0_USE_EXCEPTION_MASK		0x04000000
+#define PVR0_USE_ICACHE_MASK		0x02000000
+#define PVR0_USE_DCACHE_MASK		0x01000000
+#define PVR0_VERSION_MASK		0x0000FF00
+#define PVR0_USER1_MASK			0x000000FF
+
+/* User 2 PVR mask */
+#define PVR1_USER2_MASK			0xFFFFFFFF
+
+/* Configuration PVR masks */
+#define PVR2_D_OPB_MASK			0x80000000
+#define PVR2_D_LMB_MASK			0x40000000
+#define PVR2_I_OPB_MASK			0x20000000
+#define PVR2_I_LMB_MASK			0x10000000
+#define PVR2_INTERRUPT_IS_EDGE_MASK	0x08000000
+#define PVR2_EDGE_IS_POSITIVE_MASK	0x04000000
+#define PVR2_USE_MSR_INSTR		0x00020000
+#define PVR2_USE_PCMP_INSTR		0x00010000
+#define PVR2_AREA_OPTIMISED		0x00008000
+#define PVR2_USE_BARREL_MASK		0x00004000
+#define PVR2_USE_DIV_MASK		0x00002000
+#define PVR2_USE_HW_MUL_MASK		0x00001000
+#define PVR2_USE_FPU_MASK		0x00000800
+#define PVR2_USE_MUL64_MASK		0x00000400
+#define PVR2_OPCODE_0x0_ILLEGAL_MASK	0x00000040
+#define PVR2_UNALIGNED_EXCEPTION_MASK	0x00000020
+#define PVR2_ILL_OPCODE_EXCEPTION_MASK	0x00000010
+#define PVR2_IOPB_BUS_EXCEPTION_MASK	0x00000008
+#define PVR2_DOPB_BUS_EXCEPTION_MASK	0x00000004
+#define PVR2_DIV_ZERO_EXCEPTION_MASK	0x00000002
+#define PVR2_FPU_EXCEPTION_MASK		0x00000001
+
+/* Debug and exception PVR masks */
+#define PVR3_DEBUG_ENABLED_MASK		0x80000000
+#define PVR3_NUMBER_OF_PC_BRK_MASK	0x1E000000
+#define PVR3_NUMBER_OF_RD_ADDR_BRK_MASK	0x00380000
+#define PVR3_NUMBER_OF_WR_ADDR_BRK_MASK	0x0000E000
+#define PVR3_FSL_LINKS_MASK		0x00000380
+
+/* ICache config PVR masks */
+#define PVR4_USE_ICACHE_MASK		0x80000000
+#define PVR4_ICACHE_ADDR_TAG_BITS_MASK	0x7C000000
+#define PVR4_ICACHE_USE_FSL_MASK	0x02000000
+#define PVR4_ICACHE_ALLOW_WR_MASK	0x01000000
+#define PVR4_ICACHE_LINE_LEN_MASK	0x00E00000
+#define PVR4_ICACHE_BYTE_SIZE_MASK	0x001F0000
+
+/* DCache config PVR masks */
+#define PVR5_USE_DCACHE_MASK		0x80000000
+#define PVR5_DCACHE_ADDR_TAG_BITS_MASK	0x7C000000
+#define PVR5_DCACHE_USE_FSL_MASK	0x02000000
+#define PVR5_DCACHE_ALLOW_WR_MASK	0x01000000
+#define PVR5_DCACHE_LINE_LEN_MASK	0x00E00000
+#define PVR5_DCACHE_BYTE_SIZE_MASK	0x001F0000
+
+/* ICache base address PVR mask */
+#define PVR6_ICACHE_BASEADDR_MASK	0xFFFFFFFF
+
+/* ICache high address PVR mask */
+#define PVR7_ICACHE_HIGHADDR_MASK	0xFFFFFFFF
+
+/* DCache base address PVR mask */
+#define PVR8_DCACHE_BASEADDR_MASK	0xFFFFFFFF
+
+/* DCache high address PVR mask */
+#define PVR9_DCACHE_HIGHADDR_MASK	0xFFFFFFFF
+
+/* Target family PVR mask */
+#define PVR10_TARGET_FAMILY_MASK	0xFF000000
+
+/* MSR Reset value PVR mask */
+#define PVR11_MSR_RESET_VALUE_MASK	0x000007FF
+
+
+/* PVR access macros */
+#define PVR_IS_FULL(pvr)		(pvr.pvr[0] & PVR0_PVR_FULL_MASK)
+#define PVR_USE_BARREL(pvr)		(pvr.pvr[0] & PVR0_USE_BARREL_MASK)
+#define PVR_USE_DIV(pvr)		(pvr.pvr[0] & PVR0_USE_DIV_MASK)
+#define PVR_USE_HW_MUL(pvr)		(pvr.pvr[0] & PVR0_USE_HW_MUL_MASK)
+#define PVR_USE_FPU(pvr)		(pvr.pvr[0] & PVR0_USE_FPU_MASK)
+#define PVR_USE_ICACHE(pvr)		(pvr.pvr[0] & PVR0_USE_ICACHE_MASK)
+#define PVR_USE_DCACHE(pvr)		(pvr.pvr[0] & PVR0_USE_DCACHE_MASK)
+#define PVR_VERSION(pvr)	((pvr.pvr[0] & PVR0_VERSION_MASK) >> 8)
+#define PVR_USER1(pvr)			(pvr.pvr[0] & PVR0_USER1_MASK)
+#define PVR_USER2(pvr)			(pvr.pvr[1] & PVR1_USER2_MASK)
+
+#define PVR_D_OPB(pvr)			(pvr.pvr[2] & PVR2_D_OPB_MASK)
+#define PVR_D_LMB(pvr)			(pvr.pvr[2] & PVR2_D_LMB_MASK)
+#define PVR_I_OPB(pvr)			(pvr.pvr[2] & PVR2_I_OPB_MASK)
+#define PVR_I_LMB(pvr)			(pvr.pvr[2] & PVR2_I_LMB_MASK)
+#define PVR_INTERRUPT_IS_EDGE(pvr) \
+			(pvr.pvr[2] & PVR2_INTERRUPT_IS_EDGE_MASK)
+#define PVR_EDGE_IS_POSITIVE(pvr) \
+			(pvr.pvr[2] & PVR2_EDGE_IS_POSITIVE_MASK)
+#define PVR_USE_MSR_INSTR(pvr)		(pvr.pvr[2] & PVR2_USE_MSR_INSTR)
+#define PVR_USE_PCMP_INSTR(pvr)		(pvr.pvr[2] & PVR2_USE_PCMP_INSTR)
+#define PVR_AREA_OPTIMISED(pvr)		(pvr.pvr[2] & PVR2_AREA_OPTIMISED)
+#define PVR_USE_MUL64(pvr)		(pvr.pvr[2] & PVR2_USE_MUL64_MASK)
+#define PVR_OPCODE_0x0_ILLEGAL(pvr) \
+			(pvr.pvr[2] & PVR2_OPCODE_0x0_ILLEGAL_MASK)
+#define PVR_UNALIGNED_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_UNALIGNED_EXCEPTION_MASK)
+#define PVR_ILL_OPCODE_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_ILL_OPCODE_EXCEPTION_MASK)
+#define PVR_IOPB_BUS_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_IOPB_BUS_EXCEPTION_MASK)
+#define PVR_DOPB_BUS_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_DOPB_BUS_EXCEPTION_MASK)
+#define PVR_DIV_ZERO_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_DIV_ZERO_EXCEPTION_MASK)
+#define PVR_FPU_EXCEPTION(pvr)		(pvr.pvr[2] & PVR2_FPU_EXCEPTION_MASK)
+
+#define PVR_DEBUG_ENABLED(pvr)		(pvr.pvr[3] & PVR3_DEBUG_ENABLED_MASK)
+#define PVR_NUMBER_OF_PC_BRK(pvr) \
+			((pvr.pvr[3] & PVR3_NUMBER_OF_PC_BRK_MASK) >> 25)
+#define PVR_NUMBER_OF_RD_ADDR_BRK(pvr) \
+			((pvr.pvr[3] & PVR3_NUMBER_OF_RD_ADDR_BRK_MASK) >> 19)
+#define PVR_NUMBER_OF_WR_ADDR_BRK(pvr) \
+			((pvr.pvr[3] & PVR3_NUMBER_OF_WR_ADDR_BRK_MASK) >> 13)
+#define PVR_FSL_LINKS(pvr)	((pvr.pvr[3] & PVR3_FSL_LINKS_MASK) >> 7)
+
+#define PVR_ICACHE_ADDR_TAG_BITS(pvr) \
+			((pvr.pvr[4] & PVR4_ICACHE_ADDR_TAG_BITS_MASK) >> 26)
+#define PVR_ICACHE_USE_FSL(pvr)		(pvr.pvr[4] & PVR4_ICACHE_USE_FSL_MASK)
+#define PVR_ICACHE_ALLOW_WR(pvr)	(pvr.pvr[4] & PVR4_ICACHE_ALLOW_WR_MASK)
+#define PVR_ICACHE_LINE_LEN(pvr) \
+			(1 << ((pvr.pvr[4] & PVR4_ICACHE_LINE_LEN_MASK) >> 21))
+#define PVR_ICACHE_BYTE_SIZE(pvr) \
+			(1 << ((pvr.pvr[4] & PVR4_ICACHE_BYTE_SIZE_MASK) >> 16))
+
+#define PVR_DCACHE_ADDR_TAG_BITS(pvr) \
+			((pvr.pvr[5] & PVR5_DCACHE_ADDR_TAG_BITS_MASK) >> 26)
+#define PVR_DCACHE_USE_FSL(pvr)		(pvr.pvr[5] & PVR5_DCACHE_USE_FSL_MASK)
+#define PVR_DCACHE_ALLOW_WR(pvr)	(pvr.pvr[5] & PVR5_DCACHE_ALLOW_WR_MASK)
+#define PVR_DCACHE_LINE_LEN(pvr) \
+			(1 << ((pvr.pvr[5] & PVR5_DCACHE_LINE_LEN_MASK) >> 21))
+#define PVR_DCACHE_BYTE_SIZE(pvr) \
+			(1 << ((pvr.pvr[5] & PVR5_DCACHE_BYTE_SIZE_MASK) >> 16))
+
+
+#define PVR_ICACHE_BASEADDR(pvr)	(pvr.pvr[6] & PVR6_ICACHE_BASEADDR_MASK)
+#define PVR_ICACHE_HIGHADDR(pvr)	(pvr.pvr[7] & PVR7_ICACHE_HIGHADDR_MASK)
+
+#define PVR_DCACHE_BASEADDR(pvr)	(pvr.pvr[8] & PVR8_DCACHE_BASEADDR_MASK)
+#define PVR_DCACHE_HIGHADDR(pvr)	(pvr.pvr[9] & PVR9_DCACHE_HIGHADDR_MASK)
+
+#define PVR_TARGET_FAMILY(pvr)	((pvr.pvr[10] & PVR10_TARGET_FAMILY_MASK) >> 24)
+
+#define PVR_MSR_RESET_VALUE(pvr) \
+				(pvr.pvr[11] & PVR11_MSR_RESET_VALUE_MASK)
+
+int cpu_has_pvr(void);
+void get_pvr(struct pvr_s *pvr);
+
+#endif
diff --git a/include/asm-microblaze/system.h b/include/asm-microblaze/system.h
new file mode 100644
index 0000000..12fbb61
--- /dev/null
+++ b/include/asm-microblaze/system.h
@@ -0,0 +1,185 @@
+/*
+ * include/asm-microblaze/system.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SYSTEM_H
+#define _ASM_SYSTEM_H
+
+#include <linux/autoconf.h>
+#include <asm/registers.h>
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
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+
+#define local_irq_save(flags)				\
+	do {						\
+		asm volatile ("# local_irq_save	\n\t"	\
+				"msrclr %0, %1	\n\t"	\
+				: "=r"(flags)		\
+				: "i"(MSR_IE)		\
+				: "memory");		\
+	} while (0)
+
+#define local_irq_disable()					\
+	do {							\
+		asm volatile ("# local_irq_disable \n\t"	\
+				"msrclr r0, %0 \n\t"		\
+				:				\
+				: "i"(MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+#define local_irq_enable()					\
+	do {							\
+		asm volatile ("# local_irq_enable \n\t"		\
+				"msrset	r0, %0 \n\t"		\
+				:				\
+				: "i"(MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+#else /* CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR == 0 */
+
+#define local_irq_save(flags)					\
+	do {							\
+		register unsigned tmp;				\
+		asm volatile ("# local_irq_save	\n\t"		\
+				"mfs	%0, rmsr \n\t"		\
+				"andi	%1, %0, %2 \n\t"	\
+				"mts	rmsr, %1 \n\t"		\
+				"nop \n\t"			\
+				: "=r"(flags), "=r" (tmp)	\
+				: "i"(~MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+#define local_irq_disable()					\
+	do {							\
+		register unsigned tmp;				\
+		asm volatile ("# local_irq_disable \n\t"	\
+				"mfs	%0, rmsr \n\t"		\
+				"andi	%0, %0, %1 \n\t"	\
+				"mts	rmsr, %0 \n\t"		\
+				"nop \n\t"			\
+				: "=r"(tmp)			\
+				: "i"(~MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+#define local_irq_enable()					\
+	do {							\
+		register unsigned tmp;				\
+		asm volatile ("# local_irq_enable \n\t"		\
+				"mfs	%0, rmsr \n\t"		\
+				"ori	%0, %0, %1 \n\t"	\
+				"mts	rmsr, %0 \n\t"		\
+				"nop \n\t"			\
+				: "=r"(tmp)			\
+				: "i"(MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+#endif /* CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR */
+
+#define local_save_flags(flags)					\
+	do {							\
+		asm volatile ("# local_save_flags \n\t"		\
+				"mfs	%0, rmsr \n\t"		\
+				: "=r"(flags)			\
+				:				\
+				: "memory");			\
+	} while (0)
+
+#define local_irq_restore(flags)			\
+	do {						\
+		asm volatile ("# local_irq_restore \n\t"\
+				"mts	rmsr, %0 \n\t"	\
+				:			\
+				:"r"(flags)		\
+				: "memory");		\
+	} while (0)
+
+static inline int irqs_disabled(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+	return ((flags & MSR_IE) == 0);
+}
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
+#define xchg(ptr,x) \
+	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+extern void *cacheable_memcpy(void *, const void *, unsigned int);
+void free_init_pages(char *what, unsigned long begin, unsigned long end);
+void free_initmem(void);
+extern char *klimit;
+extern void ret_from_fork(void);
+
+#ifdef CONFIG_MTD_UCLINUX_EBSS
+extern char *_ebss;
+#endif
+
+#endif /* _ASM_SYSTEM_H */
-- 
1.5.4.rc4.14.g6fc74

