Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXC3SsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXC3SsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXC3SsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:48:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1566 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbXC3SsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:48:17 -0400
Message-Id: <20070330184615.510610601@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:47 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_x86_64_list_init.patch
Subject: [PATCH 6/9] clocksource: x86_64 initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/x86_64/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/x86_64/kernel/hpet.c |    1 +
 arch/x86_64/kernel/tsc.c  |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.20/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.20.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.20/arch/x86_64/kernel/hpet.c
@@ -131,6 +131,7 @@ struct clocksource clocksource_hpet = {
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.vread		= vread_hpet,
+	.list		= LIST_HEAD_INIT(clocksource_hpet.list),
 };
 
 int hpet_arch_init(void)
Index: linux-2.6.20/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.20.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.20/arch/x86_64/kernel/tsc.c
@@ -195,6 +195,7 @@ static struct clocksource clocksource_ts
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 	.vread			= vread_tsc,
+	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
 };
 
 void mark_tsc_unstable(char *reason)

-- 
