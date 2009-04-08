Return-Path: <linux-kernel-owner+w=401wt.eu-S1765119AbZDHL4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765119AbZDHL4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764743AbZDHLd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:33:27 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:33806 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764752AbZDHLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:33:26 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/3] x86_64: fix wrong comments
Date: Wed,  8 Apr 2009 13:32:00 +0200
Message-Id: <1239190320-23952-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239190320-23952-2-git-send-email-jirislaby@gmail.com>
References: <1239190320-23952-1-git-send-email-jirislaby@gmail.com>
 <1239190320-23952-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comments which fxrstor_checking and fxsave_uset refer to is now
in fxsave. Change the comments appropriately.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
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
-- 
1.6.2

