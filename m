Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZBRTIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZBRTIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBRTHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:07:55 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:37190 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZBRTHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:07:54 -0500
Message-ID: <499C5C88.7080808@ct.jp.nec.com>
Date: Wed, 18 Feb 2009 11:07:52 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: syscalls.h: remove asmlinkage from declaration of sys_rt_sigreturn()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

asmlinkage for sys_rt_sigreturn() no longer exists in arch/x86/kernel/signal.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/syscalls.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 258ef73..7043408 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -82,7 +82,7 @@ asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
 /* kernel/signal_64.c */
 asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
 				struct pt_regs *);
-asmlinkage long sys_rt_sigreturn(struct pt_regs *);
+long sys_rt_sigreturn(struct pt_regs *);
 
 /* kernel/sys_x86_64.c */
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
-- 
1.6.1.2

