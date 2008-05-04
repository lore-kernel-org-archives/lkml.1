Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYEDQLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYEDQLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYEDQL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:11:28 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54366 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751673AbYEDQL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:11:27 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 22/56] microblaze_v2: asm-offsets
Date: Sun,  4 May 2008 13:41:11 +0200
Message-Id: <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
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
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/asm-offsets.c |  118 ++++++++++++++++++++++++++++++++++
 1 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/asm-offsets.c

diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
new file mode 100644
index 0000000..f01aa3b
--- /dev/null
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -0,0 +1,118 @@
+/*
+ * arch/microblaze/kernel/asm-offset.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/stddef.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/ptrace.h>
+#include <linux/hardirq.h>
+#include <linux/thread_info.h>
+
+#define DEFINE(sym, val) asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+#define BLANK() asm volatile("\n->" : :)
+
+int main(int argc, char *argv[])
+{
+	/* struct pt_regs */
+	DEFINE(PT_SIZE, sizeof(struct pt_regs));
+	DEFINE(PT_MSR, offsetof(struct pt_regs, msr));
+	DEFINE(PT_EAR, offsetof(struct pt_regs, ear));
+	DEFINE(PT_ESR, offsetof(struct pt_regs, esr));
+	DEFINE(PT_FSR, offsetof(struct pt_regs, fsr));
+	DEFINE(PT_PC, offsetof(struct pt_regs, pc));
+	DEFINE(PT_R0, offsetof(struct pt_regs, r0));
+	DEFINE(PT_R1, offsetof(struct pt_regs, r1));
+	DEFINE(PT_R2, offsetof(struct pt_regs, r2));
+	DEFINE(PT_R3, offsetof(struct pt_regs, r3));
+	DEFINE(PT_R4, offsetof(struct pt_regs, r4));
+	DEFINE(PT_R5, offsetof(struct pt_regs, r5));
+	DEFINE(PT_R6, offsetof(struct pt_regs, r6));
+	DEFINE(PT_R7, offsetof(struct pt_regs, r7));
+	DEFINE(PT_R8, offsetof(struct pt_regs, r8));
+	DEFINE(PT_R9, offsetof(struct pt_regs, r9));
+	DEFINE(PT_R10, offsetof(struct pt_regs, r10));
+	DEFINE(PT_R11, offsetof(struct pt_regs, r11));
+	DEFINE(PT_R12, offsetof(struct pt_regs, r12));
+	DEFINE(PT_R13, offsetof(struct pt_regs, r13));
+	DEFINE(PT_R14, offsetof(struct pt_regs, r14));
+	DEFINE(PT_R15, offsetof(struct pt_regs, r15));
+	DEFINE(PT_R16, offsetof(struct pt_regs, r16));
+	DEFINE(PT_R17, offsetof(struct pt_regs, r17));
+	DEFINE(PT_R18, offsetof(struct pt_regs, r18));
+	DEFINE(PT_R19, offsetof(struct pt_regs, r19));
+	DEFINE(PT_R20, offsetof(struct pt_regs, r20));
+	DEFINE(PT_R21, offsetof(struct pt_regs, r21));
+	DEFINE(PT_R22, offsetof(struct pt_regs, r22));
+	DEFINE(PT_R23, offsetof(struct pt_regs, r23));
+	DEFINE(PT_R24, offsetof(struct pt_regs, r24));
+	DEFINE(PT_R25, offsetof(struct pt_regs, r25));
+	DEFINE(PT_R26, offsetof(struct pt_regs, r26));
+	DEFINE(PT_R27, offsetof(struct pt_regs, r27));
+	DEFINE(PT_R28, offsetof(struct pt_regs, r28));
+	DEFINE(PT_R29, offsetof(struct pt_regs, r29));
+	DEFINE(PT_R30, offsetof(struct pt_regs, r30));
+	DEFINE(PT_R31, offsetof(struct pt_regs, r31));
+	DEFINE(PT_MODE, offsetof(struct pt_regs, kernel_mode));
+	BLANK();
+
+	/* Magic offsets for PTRACE PEEK/POKE etc */
+	DEFINE(PT_TEXT_ADDR, sizeof(struct pt_regs) + 1);
+	DEFINE(PT_TEXT_LEN, sizeof(struct pt_regs) + 2);
+	DEFINE(PT_DATA_ADDR, sizeof(struct pt_regs) + 3);
+	BLANK();
+
+	/* struct task_struct */
+	DEFINE(TS_THREAD_INFO, offsetof(struct task_struct, stack));
+
+	/* struct thread_info */
+	DEFINE(TI_TASK, offsetof(struct thread_info, task));
+	DEFINE(TI_EXEC_DOMAIN, offsetof(struct thread_info, exec_domain));
+	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
+	DEFINE(TI_STATUS, offsetof(struct thread_info, status));
+	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
+	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
+	DEFINE(TI_ADDR_LIMIT, offsetof(struct thread_info, addr_limit));
+	DEFINE(TI_RESTART_BLOCK, offsetof(struct thread_info, restart_block));
+	DEFINE(TI_CPU_CONTEXT, offsetof(struct thread_info, cpu_context));
+	BLANK();
+
+	/* struct cpu_context */
+	DEFINE(CC_SP, offsetof(struct cpu_context, sp)); /* r1 */
+	DEFINE(CC_R2, offsetof(struct cpu_context, r2));
+	/* dedicated registers */
+	DEFINE(CC_R13, offsetof(struct cpu_context, r13));
+	DEFINE(CC_R14, offsetof(struct cpu_context, r14));
+	DEFINE(CC_R15, offsetof(struct cpu_context, r15));
+	DEFINE(CC_R16, offsetof(struct cpu_context, r16));
+	DEFINE(CC_R17, offsetof(struct cpu_context, r17));
+	DEFINE(CC_R18, offsetof(struct cpu_context, r18));
+	/* non-volatile registers */
+	DEFINE(CC_R19, offsetof(struct cpu_context, r19));
+	DEFINE(CC_R20, offsetof(struct cpu_context, r20));
+	DEFINE(CC_R21, offsetof(struct cpu_context, r21));
+	DEFINE(CC_R22, offsetof(struct cpu_context, r22));
+	DEFINE(CC_R23, offsetof(struct cpu_context, r23));
+	DEFINE(CC_R24, offsetof(struct cpu_context, r24));
+	DEFINE(CC_R25, offsetof(struct cpu_context, r25));
+	DEFINE(CC_R26, offsetof(struct cpu_context, r26));
+	DEFINE(CC_R27, offsetof(struct cpu_context, r27));
+	DEFINE(CC_R28, offsetof(struct cpu_context, r28));
+	DEFINE(CC_R29, offsetof(struct cpu_context, r29));
+	DEFINE(CC_R30, offsetof(struct cpu_context, r30));
+	/* special purpose registers */
+	DEFINE(CC_MSR, offsetof(struct cpu_context, msr));
+	DEFINE(CC_EAR, offsetof(struct cpu_context, ear));
+	DEFINE(CC_ESR, offsetof(struct cpu_context, esr));
+	DEFINE(CC_FSR, offsetof(struct cpu_context, fsr));
+	BLANK();
+
+	return 0;
+}
-- 
1.5.4.GIT

