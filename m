Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbXAWFzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbXAWFzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933018AbXAWFxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2712 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933019AbXAWFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:46 -0500
Message-Id: <20070123055346.048611770@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:53:00 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] clocksource: mips initialize list value
Content-Disposition: inline; filename=clocksource_mips_list_init.patch
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
@@ -307,6 +307,7 @@ static unsigned int __init calibrate_hpt
 struct clocksource clocksource_mips = {
 	.name		= "MIPS",
 	.mask		= 0xffffffff,
+	.list		= LIST_HEAD_INIT(clocksource_mips.list),
 	.is_continuous	= 1,
 };
 

-- 
