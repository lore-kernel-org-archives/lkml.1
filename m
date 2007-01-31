Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbXAaDk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbXAaDk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbXAaDku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:40:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65401 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932597AbXAaDkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:40:22 -0500
Message-Id: <20070131033807.734969355@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:25 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 15/23] clocksource: add new flags
Content-Disposition: inline; filename=clocksource_add_flag_values.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compile patch .. This just adds some code so the next few patches will compile.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -235,6 +235,12 @@ static inline void clocksource_calculate
 	c->xtime_interval = (u64)c->cycle_interval * c->mult;
 }
 
+#define CLOCKSOURCE_NOT_CONTINUOUS	1
+#define CLOCKSOURCE_UNSTABLE		2
+#define CLOCKSOURCE_NOT_ATOMIC		4
+#define CLOCKSOURCE_UNDER_32BITS	8
+#define CLOCKSOURCE_64BITS		16
+#define CLOCKSOURCE_PM_AFFECTED		32
 
 /* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);

-- 
