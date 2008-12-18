Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYLRWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYLRWnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLRWni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:43:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:47057 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYLRWni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:43:38 -0500
Message-ID: <494AD216.1050002@ct.jp.nec.com>
Date: Thu, 18 Dec 2008 14:43:34 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: sigframe.h: include headers for dependency
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Include following headers for dependency.
asm/sigcontext.h
asm/siginfo.h
asm/ucontext.h

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/sigframe.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/sigframe.h b/arch/x86/include/asm/sigframe.h
index 3bd0f42..4e0fe26 100644
--- a/arch/x86/include/asm/sigframe.h
+++ b/arch/x86/include/asm/sigframe.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_X86_SIGFRAME_H
 #define _ASM_X86_SIGFRAME_H
 
+#include <asm/sigcontext.h>
+#include <asm/siginfo.h>
+#include <asm/ucontext.h>
+
 #ifdef CONFIG_X86_32
 #define sigframe_ia32		sigframe
 #define rt_sigframe_ia32	rt_sigframe
-- 
1.6.0.4

