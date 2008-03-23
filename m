Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbYCWITp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbYCWITp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbYCWIIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:48 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2260 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759249AbYCWIIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:42 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 143/148] include/asm-x86/vm86.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:58 -0700
Message-Id: <1206259443-13210-144-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/vm86.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/vm86.h b/include/asm-x86/vm86.h
index c92fe4a..a2be241 100644
--- a/include/asm-x86/vm86.h
+++ b/include/asm-x86/vm86.h
@@ -42,9 +42,11 @@
 #define VM86_ARG(retval)	((retval) >> 8)
 
 #define VM86_SIGNAL	0	/* return due to signal */
-#define VM86_UNKNOWN	1	/* unhandled GP fault - IO-instruction or similar */
+#define VM86_UNKNOWN	1	/* unhandled GP fault
+				   - IO-instruction or similar */
 #define VM86_INTx	2	/* int3/int x instruction (ARG = x) */
-#define VM86_STI	3	/* sti/popf/iret instruction enabled virtual interrupts */
+#define VM86_STI	3	/* sti/popf/iret instruction enabled
+				   virtual interrupts */
 
 /*
  * Additional return values when invoking new vm86()
@@ -205,7 +207,8 @@ void release_vm86_irqs(struct task_struct *);
 #define handle_vm86_fault(a, b)
 #define release_vm86_irqs(a)
 
-static inline int handle_vm86_trap(struct kernel_vm86_regs *a, long b, int c) {
+static inline int handle_vm86_trap(struct kernel_vm86_regs *a, long b, int c)
+{
 	return 0;
 }
 
-- 
1.5.4.rc2

