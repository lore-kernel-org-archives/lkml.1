Return-Path: <linux-kernel-owner+w=401wt.eu-S934810AbYCWJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbYCWJIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbYCWIMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:30 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2375 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760251AbYCWIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 112/148] include/asm-x86/sigcontext.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:27 -0700
Message-Id: <1206259443-13210-113-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/sigcontext.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/sigcontext.h b/include/asm-x86/sigcontext.h
index d743947..2f9c884 100644
--- a/include/asm-x86/sigcontext.h
+++ b/include/asm-x86/sigcontext.h
@@ -79,7 +79,7 @@ struct sigcontext {
 	unsigned long flags;
 	unsigned long sp_at_signal;
 	unsigned short ss, __ssh;
-	struct _fpstate __user * fpstate;
+	struct _fpstate __user *fpstate;
 	unsigned long oldmask;
 	unsigned long cr2;
 };
@@ -107,7 +107,7 @@ struct sigcontext {
 	unsigned long eflags;
 	unsigned long esp_at_signal;
 	unsigned short ss, __ssh;
-	struct _fpstate __user * fpstate;
+	struct _fpstate __user *fpstate;
 	unsigned long oldmask;
 	unsigned long cr2;
 };
@@ -121,7 +121,8 @@ struct sigcontext {
 struct _fpstate {
 	__u16	cwd;
 	__u16	swd;
-	__u16	twd;	/* Note this is not the same as the 32bit/x87/FSAVE twd */
+	__u16	twd;		/* Note this is not the same as the
+				   32bit/x87/FSAVE twd */
 	__u16	fop;
 	__u64	rip;
 	__u64	rdp;
-- 
1.5.4.rc2

