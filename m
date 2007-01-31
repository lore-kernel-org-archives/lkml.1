Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbXAaDis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbXAaDis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXAaDir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:38:47 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65196 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932567AbXAaDiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:38:24 -0500
Message-Id: <20070131033809.610792279@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:31 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 21/23] clocksource: drivers/ update for new flags
Content-Disposition: inline; filename=clocksource-drivers-add-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update drivers/ for new flags.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 drivers/clocksource/acpi_pm.c    |    2 +-
 drivers/clocksource/cyclone.c    |    1 -
 drivers/clocksource/scx200_hrt.c |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.19/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/acpi_pm.c
+++ linux-2.6.19/drivers/clocksource/acpi_pm.c
@@ -73,7 +73,7 @@ static struct clocksource clocksource_ac
 	.mask		= (cycle_t)ACPI_PM_MASK,
 	.mult		= 0, /*to be caluclated*/
 	.shift		= 22,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.flags		= CLOCKSOURCE_UNDER_32BITS,
 
 };
 
Index: linux-2.6.19/drivers/clocksource/cyclone.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/cyclone.c
+++ linux-2.6.19/drivers/clocksource/cyclone.c
@@ -31,7 +31,6 @@ static struct clocksource clocksource_cy
 	.mask		= CYCLONE_TIMER_MASK,
 	.mult		= 10,
 	.shift		= 0,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_cyclone_clocksource(void)
Index: linux-2.6.19/drivers/clocksource/scx200_hrt.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/scx200_hrt.c
+++ linux-2.6.19/drivers/clocksource/scx200_hrt.c
@@ -57,7 +57,6 @@ static struct clocksource cs_hrt = {
 	.rating		= 250,
 	.read		= read_hrt,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	/* mult, shift are set based on mhz27 flag */
 };
 

-- 
