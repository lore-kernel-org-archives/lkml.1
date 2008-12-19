Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYLSW0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYLSW0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYLSWZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:25:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:50100 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYLSWZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:25:51 -0500
Message-ID: <494C1F6E.5040707@ct.jp.nec.com>
Date: Fri, 19 Dec 2008 14:25:50 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: ia32_signal: remove unnecessary declaration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

No need to declare do_signal().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 32c549f..b195f85 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -43,7 +43,6 @@
 			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
 			 X86_EFLAGS_CF)
 
-asmlinkage int do_signal(struct pt_regs *regs, sigset_t *oldset);
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
-- 
1.6.0.4

