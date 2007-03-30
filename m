Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXC3Sr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXC3Sr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXC3SrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:47:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:65399 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbXC3SrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:47:06 -0400
Message-Id: <20070330184616.107636073@mvista.com>
References: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:49 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_s390_init_list.patch
Subject: [PATCH 8/9] clocksource: s390 initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/s390 with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/s390/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.20/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/s390/kernel/time.c
+++ linux-2.6.20/arch/s390/kernel/time.c
@@ -314,6 +314,7 @@ static struct clocksource clocksource_to
 	.mult		= 1000,
 	.shift		= 12,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_tod.list),
 };
 
 

-- 
