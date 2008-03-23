Return-Path: <linux-kernel-owner+w=401wt.eu-S1765579AbYCWJBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765579AbYCWJBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbYCWIMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:09 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2356 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760176AbYCWILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:48 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 045/148] include/asm-x86/ia32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:20 -0700
Message-Id: <1206259443-13210-46-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/ia32.h |   62 +++++++++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/include/asm-x86/ia32.h b/include/asm-x86/ia32.h
index aa97332..55d3abe 100644
--- a/include/asm-x86/ia32.h
+++ b/include/asm-x86/ia32.h
@@ -14,19 +14,19 @@
 
 /* signal.h */
 struct sigaction32 {
-       unsigned int  sa_handler;	/* Really a pointer, but need to deal 
-					     with 32 bits */
-       unsigned int sa_flags;
-       unsigned int sa_restorer;	/* Another 32 bit pointer */
-       compat_sigset_t sa_mask;		/* A 32 bit mask */
+	unsigned int  sa_handler;	/* Really a pointer, but need to deal
+					   with 32 bits */
+	unsigned int sa_flags;
+	unsigned int sa_restorer;	/* Another 32 bit pointer */
+	compat_sigset_t sa_mask;	/* A 32 bit mask */
 };
 
 struct old_sigaction32 {
-       unsigned int  sa_handler;	/* Really a pointer, but need to deal 
-					     with 32 bits */
-       compat_old_sigset_t sa_mask;		/* A 32 bit mask */
-       unsigned int sa_flags;
-       unsigned int sa_restorer;	/* Another 32 bit pointer */
+	unsigned int  sa_handler;	/* Really a pointer, but need to deal
+					   with 32 bits */
+	compat_old_sigset_t sa_mask;	/* A 32 bit mask */
+	unsigned int sa_flags;
+	unsigned int sa_restorer;	/* Another 32 bit pointer */
 };
 
 typedef struct sigaltstack_ia32 {
@@ -65,7 +65,7 @@ struct stat64 {
 	long long		st_size;
 	unsigned int		st_blksize;
 
-	long long		st_blocks;/* Number 512-byte blocks allocated. */
+	long long		st_blocks;/* Number 512-byte blocks allocated */
 
 	unsigned 		st_atime;
 	unsigned 		st_atime_nsec;
@@ -77,13 +77,13 @@ struct stat64 {
 	unsigned long long	st_ino;
 } __attribute__((packed));
 
-typedef struct compat_siginfo{
+typedef struct compat_siginfo {
 	int si_signo;
 	int si_errno;
 	int si_code;
 
 	union {
-		int _pad[((128/sizeof(int)) - 3)];
+		int _pad[((128 / sizeof(int)) - 3)];
 
 		/* kill() */
 		struct {
@@ -129,28 +129,26 @@ typedef struct compat_siginfo{
 	} _sifields;
 } compat_siginfo_t;
 
-struct sigframe32
-{
-        u32 pretcode;
-        int sig;
-        struct sigcontext_ia32 sc;
-        struct _fpstate_ia32 fpstate;
-        unsigned int extramask[_COMPAT_NSIG_WORDS-1];
+struct sigframe32 {
+	u32 pretcode;
+	int sig;
+	struct sigcontext_ia32 sc;
+	struct _fpstate_ia32 fpstate;
+	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
 };
 
-struct rt_sigframe32
-{
-        u32 pretcode;
-        int sig;
-        u32 pinfo;
-        u32 puc;
-        compat_siginfo_t info;
-        struct ucontext_ia32 uc;
-        struct _fpstate_ia32 fpstate;
+struct rt_sigframe32 {
+	u32 pretcode;
+	int sig;
+	u32 pinfo;
+	u32 puc;
+	compat_siginfo_t info;
+	struct ucontext_ia32 uc;
+	struct _fpstate_ia32 fpstate;
 };
 
 struct ustat32 {
-	__u32	f_tfree;
+	__u32			f_tfree;
 	compat_ino_t		f_tinode;
 	char			f_fname[6];
 	char			f_fpack[6];
@@ -168,5 +166,5 @@ extern void ia32_pick_mmap_layout(struct mm_struct *mm);
 #endif
 
 #endif /* !CONFIG_IA32_SUPPORT */
- 
-#endif 
+
+#endif
-- 
1.5.4.rc2

