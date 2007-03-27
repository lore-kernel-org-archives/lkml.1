Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXC0Us2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXC0Us2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXC0Urx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:47:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:56342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbXC0Url (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:47:41 -0400
Message-Id: <20070327204728.886538000@strauss.suse.de>
References: <20070327202234.639415000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 27 Mar 2007 22:22:38 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 4/7] Add IRQF_IRQPOLL flag on IA64
Content-Disposition: inline; filename=add-irqf_irqpoll-flag-on-ia64.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL for the timer interrupt on IA64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/ia64/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc5-mm2/arch/ia64/kernel/time.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/ia64/kernel/time.c
+++ linux-2.6.21-rc5-mm2/arch/ia64/kernel/time.c
@@ -235,7 +235,7 @@ ia64_init_itm (void)
 
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
 	.name =		"timer"
 };
 

-- 
