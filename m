Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbXC3SsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbXC3SsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXC3SsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:48:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1559 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbXC3SsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:48:11 -0400
Message-Id: <20070330184614.902896619@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:45 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_mips_list_init.patch
Subject: [PATCH 4/9] clocksource: mips initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/mips/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/mips/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.19/arch/mips/kernel/time.c
===================================================================
--- linux-2.6.19.orig/arch/mips/kernel/time.c
+++ linux-2.6.19/arch/mips/kernel/time.c
@@ -308,6 +308,7 @@ struct clocksource clocksource_mips = {
 	.name		= "MIPS",
 	.mask		= 0xffffffff,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_mips.list),
 };
 
 static void __init init_mips_clocksource(void)

-- 
