Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXAWWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXAWWP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXAWWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:11:55 -0500
Received: from www.osadl.org ([213.239.205.134]:35840 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933147AbXAWWAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:55 -0500
Message-Id: <20070123211204.946167000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 14/46] clocksource: fixup is_continous changes on AVR32 
Content-Disposition: inline; filename=clocksource-avr32-fixups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Fixup the is_contionous replacement by a flag field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/avr32/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/avr32/kernel/time.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/avr32/kernel/time.c
+++ linux-2.6.20-rc4-mm1-bo/arch/avr32/kernel/time.c
@@ -37,7 +37,7 @@ static struct clocksource clocksource_av
 	.read		= read_cycle_count,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift		= 16,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /*

--

