Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYGHMta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYGHMta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbYGHMrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:47:20 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27570 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756956AbYGHMrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:47:16 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 41/58] microblaze_v5: system.h pvr.h processor.h
Date: Tue,  8 Jul 2008 13:59:41 +0200
Message-Id: <bcb94400dca62fb349d0ab1e0a6209291fdcdfc5.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <5174afd0eaa5c6cb9344ea3217199e48899be313.1215517976.git.monstr@monstr.eu>
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
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/processor.h |   88 +++++++++++++++++
 include/asm-microblaze/pvr.h       |  183 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/system.h    |  189 ++++++++++++++++++++++++++++++++++++
 3 files changed, 460 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/processor.h
 create mode 100644 include/asm-microblaze/pvr.h
 create mode 100644 include/asm-microblaze/system.h

diff --git a/include/asm-microblaze/processor.h b/include/asm-microblaze/processor.h
new file mode 100644
index 0000000..2213d6f
--- /dev/null
+++ b/include/asm-microblaze/processor.h
@@ -0,0 +1,88 @@
+/*
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
+#define cpu_sleep()		do {} while (0)
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
index 0000000..1c67731
--- /dev/null
+++ b/include/asm-microblaze/pvr.h
@@ -0,0 +1,183 @@
+/*
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
index 0000000..6ca1946
--- /dev/null
+++ b/include/asm-microblaze/system.h
@@ -0,0 +1,189 @@
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
+				"nop	\n\t"		\
+				: "=r"(flags)		\
+				: "i"(MSR_IE)		\
+				: "memory");		\
+	} while (0)
+
+#define local_irq_disable()					\
+	do {							\
+		asm volatile ("# local_irq_disable \n\t"	\
+				"msrclr r0, %0 \n\t"		\
+				"nop	\n\t"			\
+				:				\
+				: "i"(MSR_IE)			\
+				: "memory");			\
+	} while (0)
+
+#define local_irq_enable()					\
+	do {							\
+		asm volatile ("# local_irq_enable \n\t"		\
+				"msrset	r0, %0 \n\t"		\
+				"nop	\n\t"			\
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
+				"nop	\n\t"			\
+				: "=r"(flags)			\
+				:				\
+				: "memory");			\
+	} while (0)
+
+#define local_irq_restore(flags)			\
+	do {						\
+		asm volatile ("# local_irq_restore \n\t"\
+				"mts	rmsr, %0 \n\t"	\
+				"nop	\n\t"		\
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
+extern unsigned int memory_end;
+extern void ret_from_fork(void);
+
+#ifdef CONFIG_DEBUG_FS
+extern struct dentry *of_debugfs_root;
+#endif
+
+#endif /* _ASM_MICROBLAZE_SYSTEM_H */
-- 
1.5.4.GIT

