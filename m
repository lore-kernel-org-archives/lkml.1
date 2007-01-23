Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXAWFzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXAWFzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933016AbXAWFxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2711 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933018AbXAWFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:46 -0500
Message-Id: <20070123055345.727247649@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:52:59 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] clocksource: avr32 initialize list value
Content-Disposition: inline; filename=clocksource_avr32_list_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/avre32/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/avr32/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.19/arch/avr32/kernel/time.c
===================================================================
--- linux-2.6.19.orig/arch/avr32/kernel/time.c
+++ linux-2.6.19/arch/avr32/kernel/time.c
@@ -37,6 +37,7 @@ static struct clocksource clocksource_av
 	.read		= read_cycle_count,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift		= 16,
+	.list		= LIST_HEAD_INIT(clocksource_avr32.list),
 	.is_continuous	= 1,
 };
 

-- 
