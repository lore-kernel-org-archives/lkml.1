Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYLRWru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYLRWru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYLRWrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:47:39 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:49676 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYLRWri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:47:38 -0500
Message-ID: <494AD309.2020506@ct.jp.nec.com>
Date: Thu, 18 Dec 2008 14:47:37 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: ia32.h: remove unused struct sigfram32 and rt_sigframe32
References: <494AD216.1050002@ct.jp.nec.com>
In-Reply-To: <494AD216.1050002@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Remove struct sigfram32 and rt_sigframe32 because there is no user.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/ia32.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
index 97989c0..50ca486 100644
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -129,24 +129,6 @@ typedef struct compat_siginfo {
 	} _sifields;
 } compat_siginfo_t;
 
-struct sigframe32 {
-	u32 pretcode;
-	int sig;
-	struct sigcontext_ia32 sc;
-	struct _fpstate_ia32 fpstate;
-	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
-};
-
-struct rt_sigframe32 {
-	u32 pretcode;
-	int sig;
-	u32 pinfo;
-	u32 puc;
-	compat_siginfo_t info;
-	struct ucontext_ia32 uc;
-	struct _fpstate_ia32 fpstate;
-};
-
 struct ustat32 {
 	__u32			f_tfree;
 	compat_ino_t		f_tinode;
-- 
1.6.0.4

