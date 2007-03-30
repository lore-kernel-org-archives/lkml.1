Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXC3SvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXC3SvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXC3SvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:51:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2929 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751908AbXC3SvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:51:08 -0400
Message-Id: <20070330184615.889043435@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:48 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_drivers_list_init.patch
Subject: [PATCH 7/9] clocksource: driver initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update drivers/clocksource/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 drivers/clocksource/acpi_pm.c    |    1 +
 drivers/clocksource/cyclone.c    |    1 +
 drivers/clocksource/scx200_hrt.c |    1 +
 3 files changed, 3 insertions(+)

Index: linux-2.6.19/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/acpi_pm.c
+++ linux-2.6.19/drivers/clocksource/acpi_pm.c
@@ -74,6 +74,7 @@ static struct clocksource clocksource_ac
 	.mult		= 0, /*to be caluclated*/
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_acpi_pm.list),
 
 };
 
Index: linux-2.6.19/drivers/clocksource/cyclone.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/cyclone.c
+++ linux-2.6.19/drivers/clocksource/cyclone.c
@@ -32,6 +32,7 @@ static struct clocksource clocksource_cy
 	.mult		= 10,
 	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_cyclone.list),
 };
 
 static int __init init_cyclone_clocksource(void)
Index: linux-2.6.19/drivers/clocksource/scx200_hrt.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/scx200_hrt.c
+++ linux-2.6.19/drivers/clocksource/scx200_hrt.c
@@ -58,6 +58,7 @@ static struct clocksource cs_hrt = {
 	.read		= read_hrt,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(cs_hrt.list),
 	/* mult, shift are set based on mhz27 flag */
 };
 

-- 
