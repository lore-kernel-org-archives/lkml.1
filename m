Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYCWIRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYCWIRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbYCWIIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:36 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2254 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759183AbYCWIIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:35 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 140/148] include/asm-x86/user_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:55 -0700
Message-Id: <1206259443-13210-141-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/user_64.h |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/user_64.h b/include/asm-x86/user_64.h
index 9636164..6037b63 100644
--- a/include/asm-x86/user_64.h
+++ b/include/asm-x86/user_64.h
@@ -45,12 +45,13 @@
  */
 
 /* This matches the 64bit FXSAVE format as defined by AMD. It is the same
-   as the 32bit format defined by Intel, except that the selector:offset pairs for
-   data and eip are replaced with flat 64bit pointers. */
+   as the 32bit format defined by Intel, except that the selector:offset pairs
+   for data and eip are replaced with flat 64bit pointers. */
 struct user_i387_struct {
 	unsigned short	cwd;
 	unsigned short	swd;
-	unsigned short	twd; /* Note this is not the same as the 32bit/x87/FSAVE twd */
+	unsigned short	twd;	/* Note this is not the same as
+				   the 32bit/x87/FSAVE twd */
 	unsigned short	fop;
 	__u64	rip;
 	__u64	rdp;
@@ -97,13 +98,14 @@ struct user_regs_struct {
 /* When the kernel dumps core, it starts by dumping the user struct -
    this will be used by gdb to figure out where the data and stack segments
    are within the file, and what virtual addresses to use. */
-struct user{
+
+struct user {
 /* We start with the registers, to mimic the way that "memory" is returned
    from the ptrace(3,...) function.  */
-  struct user_regs_struct regs;		/* Where the registers are actually stored */
+  struct user_regs_struct regs;	/* Where the registers are actually stored */
 /* ptrace does not yet supply these.  Someday.... */
   int u_fpvalid;		/* True if math co-processor being used. */
-                                /* for this mess. Not yet used. */
+				/* for this mess. Not yet used. */
   int pad0;
   struct user_i387_struct i387;	/* Math Co-processor registers. */
 /* The rest of this junk is to help gdb figure out what goes where */
@@ -120,7 +122,7 @@ struct user{
   int pad1;
   unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
-  struct user_i387_struct* u_fpstate;	/* Math Co-processor pointer. */
+  struct user_i387_struct *u_fpstate;	/* Math Co-processor pointer. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
   unsigned long u_debugreg[8];
-- 
1.5.4.rc2

