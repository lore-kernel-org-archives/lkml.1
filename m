Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXAaDmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXAaDmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932667AbXAaDlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:41:39 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65501 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932614AbXAaDla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:41:30 -0500
Message-Id: <20070131033808.362583083@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:27 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 17/23] clocksource: avr32 update for new flags
Content-Disposition: inline; filename=clocksource-avr32-add-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update avr32 for new flags.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/avr32/kernel/time.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.19/arch/avr32/kernel/time.c
===================================================================
--- linux-2.6.19.orig/arch/avr32/kernel/time.c
+++ linux-2.6.19/arch/avr32/kernel/time.c
@@ -37,7 +37,6 @@ static struct clocksource clocksource_av
 	.read		= read_cycle_count,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift		= 16,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /*

-- 
