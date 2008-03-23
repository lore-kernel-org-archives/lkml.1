Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbYCWITS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbYCWITS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbYCWIIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:47 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2259 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759183AbYCWIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:41 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 056/148] include/asm-x86/kdebug.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:31 -0700
Message-Id: <1206259443-13210-57-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/kdebug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index 3523124..96651bb 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -24,12 +24,12 @@ enum die_val {
 };
 
 extern void printk_address(unsigned long address, int reliable);
-extern void die(const char *,struct pt_regs *,long);
+extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
 extern void __show_registers(struct pt_regs *, int all);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
-			unsigned long *sp, unsigned long bp);
+		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
-- 
1.5.4.rc2

