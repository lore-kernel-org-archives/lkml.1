Return-Path: <linux-kernel-owner+w=401wt.eu-S1765664AbXGSKTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765664AbXGSKTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762479AbXGSJz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:59 -0400
Received: from mail.suse.de ([195.135.220.2]:35421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650AbXGSJzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:35 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: bunk@stusta.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [42/58] i386: timer_irq_works() static again
Message-Id: <20070719095528.9618914E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

timer_irq_works() needlessly became global.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -1902,7 +1902,7 @@ __setup("no_timer_check", notimercheck);
  *	- if this function detects that timer IRQs are defunct, then we fall
  *	  back to ISA timer IRQs
  */
-int __init timer_irq_works(void)
+static int __init timer_irq_works(void)
 {
 	unsigned long t1 = jiffies;
 
