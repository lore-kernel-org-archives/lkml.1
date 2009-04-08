Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbZDHMFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbZDHMFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933059AbZDHLzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:55:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:37386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517AbZDHLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:55:43 -0400
Date: Wed, 8 Apr 2009 11:54:55 GMT
From: Jiri Slaby <jirislaby@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239190320-23952-3-git-send-email-jirislaby@gmail.com>
References: <1239190320-23952-3-git-send-email-jirislaby@gmail.com>
Subject: [tip:x86/fpu] x86_64: fix incorrect comments
Message-ID: <tip-4ecf458492c2d97b3f9d850a5f92d79792e0a7e7@git.kernel.org>
Git-Commit-ID: 4ecf458492c2d97b3f9d850a5f92d79792e0a7e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 11:54:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ecf458492c2d97b3f9d850a5f92d79792e0a7e7
Gitweb:     http://git.kernel.org/tip/4ecf458492c2d97b3f9d850a5f92d79792e0a7e7
Author:     Jiri Slaby <jirislaby@gmail.com>
AuthorDate: Wed, 8 Apr 2009 13:32:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 13:46:01 +0200

x86_64: fix incorrect comments

Impact: cleanup

The comments which fxrstor_checking and fxsave_uset refer to is
now in fxsave. Change the comments appropriately.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
LKML-Reference: <1239190320-23952-3-git-send-email-jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/i387.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 7a6f21d..63d1850 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -67,7 +67,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err)
-#if 0 /* See comment in __save_init_fpu() below. */
+#if 0 /* See comment in fxsave() below. */
 		     : [fx] "r" (fx), "m" (*fx), "0" (0));
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
@@ -112,7 +112,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err), "=m" (*fx)
-#if 0 /* See comment in __fxsave_clear() below. */
+#if 0 /* See comment in fxsave() below. */
 		     : [fx] "r" (fx), "0" (0));
 #else
 		     : [fx] "cdaSDb" (fx), "0" (0));
