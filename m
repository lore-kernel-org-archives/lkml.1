Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbXAWFzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbXAWFzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933017AbXAWFxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:55 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2714 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933020AbXAWFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:47 -0500
Message-Id: <20070123055346.695349060@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:53:02 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] clocksource: x86_64 initialize list value
Content-Disposition: inline; filename=clocksource_x86_64_list_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/x86_64/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/x86_64/kernel/hpet.c |    1 +
 arch/x86_64/kernel/tsc.c  |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.19/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.19/arch/x86_64/kernel/hpet.c
@@ -472,6 +472,7 @@ struct clocksource clocksource_hpet = {
 	.shift		= HPET_SHIFT,
 	.is_continuous	= 1,
 	.vread		= vread_hpet,
+	.list		= LIST_HEAD_INIT(clocksource_hpet.list),
 };
 
 static int __init init_hpet_clocksource(void)
Index: linux-2.6.19/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.19/arch/x86_64/kernel/tsc.c
@@ -209,6 +209,7 @@ static struct clocksource clocksource_ts
 	.update_callback	= tsc_update_callback,
 	.is_continuous		= 1,
 	.vread			= vread_tsc,
+	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
 };
 
 static int tsc_update_callback(void)

-- 
