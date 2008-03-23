Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbYCWJI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbYCWJI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759071AbYCWIMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:33 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2378 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760255AbYCWIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 102/148] include/asm-x86/ptrace.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:17 -0700
Message-Id: <1206259443-13210-103-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/ptrace.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index bc44246..e779f2b 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -140,7 +140,8 @@ extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
 #ifdef CONFIG_X86_32
-extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code);
+extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+			 int error_code);
 #else
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 #endif
@@ -169,8 +170,8 @@ static inline int user_mode(struct pt_regs *regs)
 static inline int user_mode_vm(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	return ((regs->cs & SEGMENT_RPL_MASK) |
-		(regs->flags & VM_MASK)) >= USER_RPL;
+	return ((regs->cs & SEGMENT_RPL_MASK) | (regs->flags & VM_MASK)) >=
+		USER_RPL;
 #else
 	return user_mode(regs);
 #endif
-- 
1.5.4.rc2

