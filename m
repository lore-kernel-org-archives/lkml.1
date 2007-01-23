Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXAWWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXAWWP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXAWWLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:11:54 -0500
Received: from www.osadl.org ([213.239.205.134]:35842 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933148AbXAWWA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:56 -0500
Message-Id: <20070123211205.059727000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 15/46] clocksource: fixup is_continous changes on S390
Content-Disposition: inline; filename=clocksource-s390-fixups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Fixup the is_contionous replacement by a flag field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/s390/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/s390/kernel/time.c
+++ linux-2.6.20-rc4-mm1-bo/arch/s390/kernel/time.c
@@ -283,7 +283,7 @@ static struct clocksource clocksource_to
 	.mask		= -1ULL,
 	.mult		= 1000,
 	.shift		= 12,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 

--

