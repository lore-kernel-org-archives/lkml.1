Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXAaDiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXAaDiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXAaDiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:38:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65193 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932560AbXAaDiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:38:22 -0500
Message-Id: <20070131033808.982733747@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:29 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 19/23] clocksource: mips update for new flags
Content-Disposition: inline; filename=clocksource-mips-add-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update mips for new flags.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/mips/kernel/time.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.19/arch/mips/kernel/time.c
===================================================================
--- linux-2.6.19.orig/arch/mips/kernel/time.c
+++ linux-2.6.19/arch/mips/kernel/time.c
@@ -307,7 +307,6 @@ static unsigned int __init calibrate_hpt
 struct clocksource clocksource_mips = {
 	.name		= "MIPS",
 	.mask		= 0xffffffff,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init init_mips_clocksource(void)

-- 
