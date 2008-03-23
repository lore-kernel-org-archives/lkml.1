Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbYCWIQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbYCWIQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYCWIIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:18 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2251 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758958AbYCWIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:17 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 138/148] include/asm-x86/user_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:53 -0700
Message-Id: <1206259443-13210-139-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/user_32.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/user_32.h b/include/asm-x86/user_32.h
index 6157da6..d6e51ed 100644
--- a/include/asm-x86/user_32.h
+++ b/include/asm-x86/user_32.h
@@ -100,10 +100,10 @@ struct user_regs_struct {
 struct user{
 /* We start with the registers, to mimic the way that "memory" is returned
    from the ptrace(3,...) function.  */
-  struct user_regs_struct regs;		/* Where the registers are actually stored */
+  struct user_regs_struct regs;	/* Where the registers are actually stored */
 /* ptrace does not yet supply these.  Someday.... */
   int u_fpvalid;		/* True if math co-processor being used. */
-                                /* for this mess. Not yet used. */
+				/* for this mess. Not yet used. */
   struct user_i387_struct i387;	/* Math Co-processor registers. */
 /* The rest of this junk is to help gdb figure out what goes where */
   unsigned long int u_tsize;	/* Text segment size (pages). */
@@ -118,7 +118,7 @@ struct user{
   int reserved;			/* No longer used */
   unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
-  struct user_i387_struct* u_fpstate;	/* Math Co-processor pointer. */
+  struct user_i387_struct *u_fpstate;	/* Math Co-processor pointer. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
   int u_debugreg[8];
-- 
1.5.4.rc2

