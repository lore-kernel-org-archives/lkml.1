Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYEEJBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYEEJBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYEEJBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:01:34 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:33203 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752679AbYEEJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:01:32 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 54/56] microblaze_v2: entry.S
Date: Sun,  4 May 2008 13:41:43 +0200
Message-Id: <90266c91f066bbc32d487bc7ee55b2f7e6ce0428.1209897267.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <a484cc541ae55e099035cccf903f208f39fdeb39.1209897267.git.monstr@monstr.eu>
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
 <53e5b22838d017b7cf7f44c4bafe5f7e253732ce.1209897267.git.monstr@monstr.eu>
 <affa82887bee64b05420fdd5f723cca920acad90.1209897267.git.monstr@monstr.eu>
 <c709de3e3767d1be8b23ce73255389c525737c36.1209897267.git.monstr@monstr.eu>
 <a484cc541ae55e099035cccf903f208f39fdeb39.1209897267.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/entry.S |  597 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 597 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/entry.S

diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
new file mode 100644
index 0000000..d0b487b
--- /dev/null
+++ b/arch/microblaze/kernel/entry.S
@@ -0,0 +1,597 @@
+/*
+ * arch/microblaze/kernel/entry.S
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/asm-offsets.h>
+#include <asm/registers.h>
+#include <asm/unistd.h>
+#include <asm/percpu.h>
+#include <asm/signal.h>
+
+#define PER_CPU(var) per_cpu__##var
+
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+	.macro	disable_irq
+	msrclr r0, MSR_IE
+	.endm
+
+	.macro	enable_irq
+	msrset r0, MSR_IE
+	.endm
+
+	.macro	clear_bip
+	msrclr r0, MSR_BIP
+	.endm
+#else
+	.macro	disable_irq
+	mfs r11, rmsr
+	andi r11, r11, ~MSR_IE
+	mts rmsr, r11
+	.endm
+
+	.macro	enable_irq
+	mfs r11, rmsr
+	ori r11, r11, MSR_IE
+	mts rmsr, r11
+	.endm
+
+	.macro	clear_bip
+	mfs r11, rmsr
+	andi r11, r11, ~MSR_BIP
+	mts rmsr, r11
+	.endm
+#endif
+
+ENTRY(_interrupt)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+	beqid	r11, 1f
+	nop
+	brid	2f				/* jump over */
+	addik	r1, r1, (-PT_SIZE)	/* room for pt_regs (delay slot) */
+1:						/* switch to kernel stack */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	/* calculate kernel stack pointer */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE
+2:
+	swi	r11, r1, PT_MODE		/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3
+	swi	r4, r1, PT_R4
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	swi	r14, r1, PT_R14
+	swi	r14, r1, PT_PC
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* prepare the link register, the argument and jump */
+	la	r15, r0, ret_from_intr - 8
+	addk	r6, r0, r15
+	braid	do_IRQ
+	add	r5, r0, r1
+
+ret_from_intr:
+	lwi	r11, r1, PT_MODE
+	bneid	r11, 3f
+
+	lwi	r6, r31, TS_THREAD_INFO	/* get thread info */
+	lwi	r19, r6, TI_FLAGS	/* get flags in thread info */
+				/* do an extra work if any bits are set */
+
+	andi	r11, r19, _TIF_NEED_RESCHED
+	beqi	r11, 1f
+	bralid	r15, schedule
+	nop
+1:	andi	r11, r19, _TIF_SIGPENDING
+	beqid	r11, no_intr_reshed
+	addk	r5, r1, r0
+	addk	r7, r0, r0
+	bralid	r15, do_signal
+	addk	r6, r0, r0
+
+no_intr_reshed:
+	/* save mode indicator */
+	lwi	r11, r1, PT_MODE
+3:
+	swi	r11, r0, PER_CPU(KM)
+
+	/* save r31 */
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+restore_context:
+	/* special purpose registers */
+	lwi	r11, r1, PT_FSR
+	mts	rfsr, r11
+	lwi	r11, r1, PT_ESR
+	mts	resr, r11
+	lwi	r11, r1, PT_EAR
+	mts	rear, r11
+	lwi	r11, r1, PT_MSR
+	mts	rmsr, r11
+
+	lwi	r31, r1, PT_R31
+	lwi	r30, r1, PT_R30
+	lwi	r29, r1, PT_R29
+	lwi	r28, r1, PT_R28
+	lwi	r27, r1, PT_R27
+	lwi	r26, r1, PT_R26
+	lwi	r25, r1, PT_R25
+	lwi	r24, r1, PT_R24
+	lwi	r23, r1, PT_R23
+	lwi	r22, r1, PT_R22
+	lwi	r21, r1, PT_R21
+	lwi	r20, r1, PT_R20
+	lwi	r19, r1, PT_R19
+	lwi	r18, r1, PT_R18
+	lwi	r17, r1, PT_R17
+	lwi	r16, r1, PT_R16
+	lwi	r15, r1, PT_R15
+	lwi	r14, r1, PT_PC
+	lwi	r13, r1, PT_R13
+	lwi	r12, r1, PT_R12
+	lwi	r11, r1, PT_R11
+	lwi	r10, r1, PT_R10
+	lwi	r9, r1, PT_R9
+	lwi	r8, r1, PT_R8
+	lwi	r7, r1, PT_R7
+	lwi	r6, r1, PT_R6
+	lwi	r5, r1, PT_R5
+	lwi	r4, r1, PT_R4
+	lwi	r3, r1, PT_R3
+	lwi	r2, r1, PT_R2
+	lwi	r1, r1, PT_R1
+	rtid	r14, 0
+	nop
+
+ENTRY(_reset)
+	brai	0;
+
+ENTRY(_user_exception)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+	beqid	r11, 1f				/* Already in kernel mode? */
+	nop
+	brid	2f				/* jump over */
+	addik	r1, r1, (-PT_SIZE)	/* Room for pt_regs (delay slot) */
+1:						/* Switch to kernel stack */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	/* calculate kernel stack pointer */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+2:
+	swi	r11, r1, PT_MODE		/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	/* save them on stack */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3 /* r3: _always_ in clobber list; see unistd.h */
+	swi	r4, r1, PT_R4 /* r4: _always_ in clobber list; see unistd.h */
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	/* r12: _always_ in clobber list; see unistd.h */
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	/* r14: _always_ in clobber list; see unistd.h */
+	swi	r14, r1, PT_R14
+	/* but we want to return to the next inst. */
+	addik	r14, r14, 0x4
+	swi	r14, r1, PT_PC		/* increment by 4 and store in pc */
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+
+	disable_irq
+	nop		/* make sure IE bit is in effect */
+	clear_bip	/* once IE is in effect it is safe to clear BIP */
+	nop
+
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* re-enable interrupts now we are in kernel mode */
+	enable_irq
+
+	/* See if the system call number is valid. */
+	addi	r11, r12, -NR_syscalls
+	bgei	r11, 1f			/* return to user if not valid */
+	/* Figure out which function to use for this system call. */
+	/* Note Microblaze barrel shift is optional, so don't rely on it */
+	add	r12, r12, r12			/* convert num -> ptr */
+	add	r12, r12, r12
+	lwi	r12, r12, sys_call_table	/* Get function pointer */
+	la	r15, r0, ret_to_user-8		/* set return address */
+	bra	r12				/* Make the system call. */
+	bri	0				/* won't reach here */
+1:
+	brid	ret_to_user			/* jump to syscall epilogue */
+	addi	r3, r0, -ENOSYS			/* set errno in delay slot */
+
+/*
+ * Debug traps are like a system call, but entered via brki r14, 0x60
+ * All we need to do is send the SIGTRAP signal to current, ptrace and do_signal
+ * will handle the rest
+ */
+ENTRY(_debug_exception)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE	/* get the kernel stack */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+//save_context:
+	swi	r11, r1, PT_MODE	/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	/* save them on stack */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3 /* r3: _always_ in clobber list; see unistd.h */
+	swi	r4, r1, PT_R4 /* r4: _always_ in clobber list; see unistd.h */
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	/* r12: _always_ in clobber list; see unistd.h */
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	/* r14: _always_ in clobber list; see unistd.h */
+	swi	r14, r1, PT_R14
+	swi	r14, r1, PT_PC /* Will return to interrupted instruction */
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+
+	disable_irq
+	nop		/* make sure IE bit is in effect */
+	clear_bip	/* once IE is in effect it is safe to clear BIP */
+	nop
+
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* re-enable interrupts now we are in kernel mode */
+	enable_irq
+
+	addi	r5, r0, SIGTRAP			/* sending the trap signal */
+	add	r6, r0, r31			/* to current */
+	bralid	r15, send_sig
+	add	r7, r0, r0			/* 3rd param zero */
+
+	/* Restore r3/r4 to work around how ret_to_user works */
+	lwi	r3, r1, PT_R3
+	lwi	r4, r1, PT_R4
+	bri	ret_to_user
+
+ENTRY(_break)
+	bri	0
+
+/* struct task_struct *_switch_to(struct thread_info *prev,
+					struct thread_info *next); */
+ENTRY(_switch_to)
+	/* prepare return value */
+	addk	r3, r0, r31
+
+	/* save registers in cpu_context */
+	/* use r11 and r12, volatile registers, as temp register */
+	addik	r11, r5, TI_CPU_CONTEXT
+	swi	r1, r11, CC_SP
+	swi	r2, r11, CC_R2
+	/* skip volatile registers.
+	 * they are saved on stack when we jumped to _switch_to() */
+	/* dedicated registers */
+	swi	r13, r11, CC_R13
+	swi	r14, r11, CC_R14
+	swi	r15, r11, CC_R15
+	swi	r16, r11, CC_R16
+	swi	r17, r11, CC_R17
+	swi	r18, r11, CC_R18
+	/* save non-volatile registers */
+	swi	r19, r11, CC_R19
+	swi	r20, r11, CC_R20
+	swi	r21, r11, CC_R21
+	swi	r22, r11, CC_R22
+	swi	r23, r11, CC_R23
+	swi	r24, r11, CC_R24
+	swi	r25, r11, CC_R25
+	swi	r26, r11, CC_R26
+	swi	r27, r11, CC_R27
+	swi	r28, r11, CC_R28
+	swi	r29, r11, CC_R29
+	swi	r30, r11, CC_R30
+	/* special purpose registers */
+	mfs	r12, rmsr
+	swi	r12, r11, CC_MSR
+	mfs	r12, rear
+	swi	r12, r11, CC_EAR
+	mfs	r12, resr
+	swi	r12, r11, CC_ESR
+	mfs	r12, rfsr
+	swi	r12, r11, CC_FSR
+
+	/* update r31, the current */
+	lwi	r31, r6, TI_TASK
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+
+	/* get new process' cpu context and restore */
+	addik	r11, r6, TI_CPU_CONTEXT
+
+	/* special purpose registers */
+	lwi	r12, r11, CC_FSR
+	mts	rfsr, r12
+	lwi	r12, r11, CC_ESR
+	mts	resr, r12
+	lwi	r12, r11, CC_EAR
+	mts	rear, r12
+	lwi	r12, r11, CC_MSR
+	mts	rmsr, r12
+	/* non-volatile registers */
+	lwi	r30, r11, CC_R30
+	lwi	r29, r11, CC_R29
+	lwi	r28, r11, CC_R28
+	lwi	r27, r11, CC_R27
+	lwi	r26, r11, CC_R26
+	lwi	r25, r11, CC_R25
+	lwi	r24, r11, CC_R24
+	lwi	r23, r11, CC_R23
+	lwi	r22, r11, CC_R22
+	lwi	r21, r11, CC_R21
+	lwi	r20, r11, CC_R20
+	lwi	r19, r11, CC_R19
+	/* dedicated registers */
+	lwi	r18, r11, CC_R18
+	lwi	r17, r11, CC_R17
+	lwi	r16, r11, CC_R16
+	lwi	r15, r11, CC_R15
+	lwi	r14, r11, CC_R14
+	lwi	r13, r11, CC_R13
+	/* skip volatile registers */
+	lwi	r2, r11, CC_R2
+	lwi	r1, r11, CC_SP
+
+	rtsd	r15, 8
+	nop
+
+ENTRY(ret_from_fork)
+	addk	r5, r0, r3
+	addk	r6, r0, r1
+	brlid	r15, schedule_tail
+	nop
+	swi	r31, r1, PT_R31		/* save r31 in user context. */
+			/* will soon be restored to r31 in ret_to_user */
+	addk	r3, r0, r0
+	brid	ret_to_user
+	nop
+
+work_pending:
+	andi	r11, r19, _TIF_NEED_RESCHED
+	beqi	r11, 1f
+	bralid	r15, schedule
+	nop
+1:	andi	r11, r19, _TIF_SIGPENDING
+	beqi	r11, no_work_pending
+	addk	r5, r1, r0
+	addik	r7, r0, 1
+	bralid	r15, do_signal
+	addk	r6, r0, r0
+	bri	no_work_pending
+
+ENTRY(ret_to_user)
+	disable_irq
+
+	swi	r4, r1, PT_R4		/* return val */
+	swi	r3, r1, PT_R3		/* return val */
+
+	lwi	r6, r31, TS_THREAD_INFO /* get thread info */
+	lwi	r19, r6, TI_FLAGS /* get flags in thread info */
+	bnei	r19, work_pending /* do an extra work if any bits are set */
+no_work_pending:
+	disable_irq
+
+	/* save r31 */
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* save mode indicator */
+	lwi	r18, r1, PT_MODE
+	swi	r18, r0, PER_CPU(KM)
+//restore_context:
+	/* special purpose registers */
+	lwi	r18, r1, PT_FSR
+	mts	rfsr, r18
+	lwi	r18, r1, PT_ESR
+	mts	resr, r18
+	lwi	r18, r1, PT_EAR
+	mts	rear, r18
+	lwi	r18, r1, PT_MSR
+	mts	rmsr, r18
+
+	lwi	r31, r1, PT_R31
+	lwi	r30, r1, PT_R30
+	lwi	r29, r1, PT_R29
+	lwi	r28, r1, PT_R28
+	lwi	r27, r1, PT_R27
+	lwi	r26, r1, PT_R26
+	lwi	r25, r1, PT_R25
+	lwi	r24, r1, PT_R24
+	lwi	r23, r1, PT_R23
+	lwi	r22, r1, PT_R22
+	lwi	r21, r1, PT_R21
+	lwi	r20, r1, PT_R20
+	lwi	r19, r1, PT_R19
+	lwi	r18, r1, PT_R18
+	lwi	r17, r1, PT_R17
+	lwi	r16, r1, PT_R16
+	lwi	r15, r1, PT_R15
+	lwi	r14, r1, PT_PC
+	lwi	r13, r1, PT_R13
+	lwi	r12, r1, PT_R12
+	lwi	r11, r1, PT_R11
+	lwi	r10, r1, PT_R10
+	lwi	r9, r1, PT_R9
+	lwi	r8, r1, PT_R8
+	lwi	r7, r1, PT_R7
+	lwi	r6, r1, PT_R6
+	lwi	r5, r1, PT_R5
+	lwi	r4, r1, PT_R4		/* return val */
+	lwi	r3, r1, PT_R3		/* return val */
+	lwi	r2, r1, PT_R2
+	lwi	r1, r1, PT_R1
+
+	rtid	r14, 0
+	nop
+
+sys_vfork_wrapper:
+	brid	sys_vfork
+	addk	r5, r1, r0
+
+sys_clone_wrapper:
+	brid	sys_clone
+	addk	r7, r1, r0
+
+sys_execve_wrapper:
+	brid	sys_execve
+	addk	r8, r1, r0
+
+sys_sigreturn_wrapper:
+	brid	sys_sigreturn
+	addk	r5, r1, r0
+
+sys_rt_sigreturn_wrapper:
+	brid	sys_rt_sigreturn
+	addk	r5, r1, r0
+
+sys_sigsuspend_wrapper:
+	brid	sys_rt_sigsuspend
+	addk	r6, r1, r0
+
+sys_rt_sigsuspend_wrapper:
+	brid	sys_rt_sigsuspend
+	addk	r7, r1, r0
+
+	/* Interrupt vector table */
+	.section	.init.ivt, "ax"
+	.org 0x0
+	brai	_reset
+	brai	_user_exception
+	brai	_interrupt
+	brai	_break
+	brai	_hw_exception_handler
+	.org 0x60
+	brai	_debug_exception
+
+.section .rodata,"a"
+#include "syscall_table.S"
+
+syscall_table_size=(.-sys_call_table)
-- 
1.5.4.GIT

