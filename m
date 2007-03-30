Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXC3SyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXC3SyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXC3SyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:54:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4503 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbXC3SyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:54:19 -0400
Message-Id: <20070330184614.308029296@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:43 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_parisc_list_init.patch
Subject: [PATCH 2/9] clocksource: parisc initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/parisc/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/parisc/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.20/arch/parisc/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/parisc/kernel/time.c
+++ linux-2.6.20/arch/parisc/kernel/time.c
@@ -184,6 +184,7 @@ static struct clocksource clocksource_cr
 	.mult			= 0, /* to be set */
 	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list			= LIST_HEAD_INIT(clocksource_cr16.list),
 };
 
 #ifdef CONFIG_SMP

-- 
