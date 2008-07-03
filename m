Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYGCUM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYGCUM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbYGCUMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:12:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14280 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbYGCUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:12:15 -0400
Message-ID: <486D329D.4040407@ct.jp.nec.com>
Date: Thu, 03 Jul 2008 13:12:13 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_32: remove redundant KERN_INFO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

This printk has a KERN_ facility level in the format string.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..d633d80 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -212,7 +212,7 @@ asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
 
 badframe:
 	if (show_unhandled_signals && printk_ratelimit()) {
-		printk(KERN_INFO "%s%s[%d] bad frame in sigreturn frame:"
+		printk("%s%s[%d] bad frame in sigreturn frame:"
 			"%p ip:%lx sp:%lx oeax:%lx",
 		    task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
 		    current->comm, task_pid_nr(current), frame, regs->ip,
-- 
1.5.4.1

