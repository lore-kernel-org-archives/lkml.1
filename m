Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYEEI51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYEEI51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYEEI5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:57:16 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:43332 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754498AbYEEI5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:57:14 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 40/56] microblaze_v2: system.h pvr.h processor.h
Date: Sun,  4 May 2008 13:41:29 +0200
Message-Id: <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
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
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/processor.h |   89 +++++++++++++++++
 include/asm-microblaze/pvr.h       |  185 +++++++++++++++++++++++++++++++++++
 include/asm-microblaze/system.h    |  190 ++++++++++++++++++++++++++++++++++++
 3 files changed, 464 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/processor.h
 create mode 100644 include/asm-microblaze/pvr.h
 create mode 100644 include/asm-microblaze/system.h

diff --git a/include/asm-microblaze/processor.h b/include/asm-microblaze/processor.h
new file mode 100644
index 0000000..6fd391c
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
+#ifndef _ASM_MICROBLAZE_PROCESSOR_H
+#define _ASM_MICROBLAZE_PROCESSOR_H
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
+#endif /* _ASM_MICROBLAZE_PROCESSOR_H */
diff --git a/include/asm-microblaze/pvr.h b/include/asm-microblaze/pvr.h
new file mode 100644
index 0000000..2805dbe
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
+#ifndef _ASM_MICROBLAZE_PVR_H
+#define _ASM_MICROBLAZE_PVR_H
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
+#endif /* _ASM_MICROBLAZE_PVR_H */
diff --git a/include/asm-microblaze/system.h b/include/asm-microblaze/system.h
new file mode 100644
index 0000000..76fb22f
--- /dev/null
+++ b/include/asm-microblaze/system.h
@@ -0,0 +1,190 @@
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
+#ifndef _ASM_MICROBLAZE_SYSTEM_H
+#define _ASM_MICROBLAZE_SYSTEM_H
+
+#include <linux/autoconf.h>
+#include <asm/registers.h>
+#include <asm/setup.h>
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
+#ifdef CONFIG_DEBUG_FS
+extern struct dentry *of_debugfs_root;
+#endif
+
+#ifdef CONFIG_MTD_UCLINUX
+extern char *_ebss;
+#endif
+
+#endif /* _ASM_MICROBLAZE_SYSTEM_H */
-- 
1.5.4.GIT

