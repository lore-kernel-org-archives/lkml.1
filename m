Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbXFWNWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbXFWNWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbXFWNV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:21:57 -0400
Received: from www.osadl.org ([213.239.205.134]:59175 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755436AbXFWNV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:21:56 -0400
Message-Id: <20070623124030.263126433@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [patch -mm 03/28] clockevents: fix typo in acpi_pm.c
Content-Disposition: inline; filename=fix-typo-in-acpi-pm-c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Alessio Igor Bogani <abogani@texware.it>

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Cc: john stultz <johnstul@us.ibm.com>

---
 drivers/clocksource/acpi_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/drivers/clocksource/acpi_pm.c	2007-06-23 14:38:57.000000000 +0200
+++ linux-2.6.22-rc4-mm/drivers/clocksource/acpi_pm.c	2007-06-23 14:38:57.000000000 +0200
@@ -71,7 +71,7 @@ static struct clocksource clocksource_ac
 	.rating		= 200,
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
-	.mult		= 0, /*to be caluclated*/
+	.mult		= 0, /*to be calculated*/
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 

-- 

