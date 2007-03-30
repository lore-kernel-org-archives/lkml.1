Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXC3Sv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXC3Sv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXC3Sv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:51:57 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:3295 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751068AbXC3Sv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:51:56 -0400
Message-Id: <20070330184615.200655288@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:46 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_i386_list_init.patch
Subject: [PATCH 5/9] clocksource: i386 initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/i386/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/hpet.c    |    1 +
 arch/i386/kernel/i8253.c   |    1 +
 arch/i386/kernel/tsc.c     |    1 +
 arch/i386/kernel/vmitime.c |    1 +
 4 files changed, 4 insertions(+)

Index: linux-2.6.20/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.20/arch/i386/kernel/hpet.c
@@ -215,6 +215,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_hpet.list),
 };
 
 /*
Index: linux-2.6.20/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/i8253.c
+++ linux-2.6.20/arch/i386/kernel/i8253.c
@@ -193,6 +193,7 @@ static struct clocksource clocksource_pi
 	.mask	= CLOCKSOURCE_MASK(32),
 	.mult	= 0,
 	.shift	= 20,
+	.list	= LIST_HEAD_INIT(clocksource_pit.list),
 };
 
 static int __init init_pit_clocksource(void)
Index: linux-2.6.20/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.20/arch/i386/kernel/tsc.c
@@ -279,6 +279,7 @@ static struct clocksource clocksource_ts
 	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
+	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
 };
 
 void mark_tsc_unstable(char *reason)
Index: linux-2.6.20/arch/i386/kernel/vmitime.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/vmitime.c
+++ linux-2.6.20/arch/i386/kernel/vmitime.c
@@ -116,6 +116,7 @@ static struct clocksource clocksource_vm
 	.mult			= 0, /* to be set */
 	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list			= LIST_HEAD_INIT(clocksource_vmi.list),
 };
 
 

-- 
