Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbXAWFyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbXAWFyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXAWFx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:56 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2715 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933021AbXAWFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:47 -0500
Message-Id: <20070123055347.022018534@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:53:03 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] clocksource: driver initialize list value
Content-Disposition: inline; filename=clocksource_drivers_list_init.patch
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
 	.is_continuous	= 1,
+	.list		= LIST_HEAD_INIT(clocksource_acpi_pm.list),
 };
 
 
Index: linux-2.6.19/drivers/clocksource/cyclone.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/cyclone.c
+++ linux-2.6.19/drivers/clocksource/cyclone.c
@@ -32,6 +32,7 @@ static struct clocksource clocksource_cy
 	.mult		= 10,
 	.shift		= 0,
 	.is_continuous	= 1,
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
 	.is_continuous	= 1,
+	.list		= LIST_HEAD_INIT(cs_hrt.list),
 	/* mult, shift are set based on mhz27 flag */
 };
 

-- 
