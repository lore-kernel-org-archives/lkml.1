Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYCWIQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYCWIQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758845AbYCWII2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:28 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2252 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbYCWII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:27 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 139/148] include/asm-x86/user32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:54 -0700
Message-Id: <1206259443-13210-140-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/user32.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/user32.h b/include/asm-x86/user32.h
index f769872..a3d9100 100644
--- a/include/asm-x86/user32.h
+++ b/include/asm-x86/user32.h
@@ -1,7 +1,8 @@
 #ifndef USER32_H
 #define USER32_H 1
 
-/* IA32 compatible user structures for ptrace. These should be used for 32bit coredumps too. */
+/* IA32 compatible user structures for ptrace.
+ * These should be used for 32bit coredumps too. */
 
 struct user_i387_ia32_struct {
 	u32	cwd;
@@ -42,9 +43,9 @@ struct user_regs_struct32 {
 };
 
 struct user32 {
-  struct user_regs_struct32 regs;		/* Where the registers are actually stored */
+  struct user_regs_struct32 regs; /* Where the registers are actually stored */
   int u_fpvalid;		/* True if math co-processor being used. */
-                                /* for this mess. Not yet used. */
+				/* for this mess. Not yet used. */
   struct user_i387_ia32_struct i387;	/* Math Co-processor registers. */
 /* The rest of this junk is to help gdb figure out what goes where */
   __u32 u_tsize;	/* Text segment size (pages). */
-- 
1.5.4.rc2

