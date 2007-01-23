Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbXAWWQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbXAWWQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbXAWWLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:11:51 -0500
Received: from www.osadl.org ([213.239.205.134]:35845 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933151AbXAWWA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:57 -0500
Message-Id: <20070123211205.215971000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 16/46] clocksource: fixup is_continous changes on MIPS
Content-Disposition: inline; filename=clocksource-mips-fixups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Fixup the is_contionous replacement by a flag field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/mips/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/mips/kernel/time.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/mips/kernel/time.c
+++ linux-2.6.20-rc4-mm1-bo/arch/mips/kernel/time.c
@@ -307,7 +307,7 @@ static unsigned int __init calibrate_hpt
 struct clocksource clocksource_mips = {
 	.name		= "MIPS",
 	.mask		= 0xffffffff,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init init_mips_clocksource(void)

--

