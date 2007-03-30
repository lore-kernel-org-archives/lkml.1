Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXC3StH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXC3StH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXC3StH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:49:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1986 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbXC3StE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:49:04 -0400
Message-Id: <20070330184614.610839196@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:44 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_avr32_list_init.patch
Subject: [PATCH 3/9] clocksource: avr32 initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/avre32/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/avr32/kernel/time.c         |    1 +
 arch/avr32/mach-at32ap/time-tc.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.20/arch/avr32/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/avr32/kernel/time.c
+++ linux-2.6.20/arch/avr32/kernel/time.c
@@ -45,6 +45,7 @@ struct clocksource __weak clocksource_av
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift		= 16,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_avr32.list),
 };
 
 irqreturn_t __weak timer_interrupt(int irq, void *dev_id);
Index: linux-2.6.20/arch/avr32/mach-at32ap/time-tc.c
===================================================================
--- linux-2.6.20.orig/arch/avr32/mach-at32ap/time-tc.c
+++ linux-2.6.20/arch/avr32/mach-at32ap/time-tc.c
@@ -50,6 +50,7 @@ struct clocksource clocksource_avr32 = {
 	.mask		= CLOCKSOURCE_MASK(16),
 	.shift		= 16,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_avr32.list),
 };
 
 static void avr32_timer_ack(void)

-- 
