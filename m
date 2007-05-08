Return-Path: <linux-kernel-owner+w=401wt.eu-S934960AbXEHQTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960AbXEHQTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968336AbXEHQTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:19:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43485 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934929AbXEHQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:19:44 -0400
Message-Id: <20070508161811.894622930@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 May 2007 09:18:11 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] clocksource: spelling error in watchdog code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theres more that need fixing , and fix my own subject spelling
error too.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/time/clocksource.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.21/kernel/time/clocksource.c
===================================================================
--- linux-2.6.21.orig/kernel/time/clocksource.c
+++ linux-2.6.21/kernel/time/clocksource.c
@@ -77,14 +77,14 @@ static cycle_t watchdog_last;
 static int watchdog_resumed;
 
 /*
- * Interval: 0.5sec Treshold: 0.0625s
+ * Interval: 0.5sec Threshold: 0.0625s
  */
 #define WATCHDOG_INTERVAL (HZ >> 1)
-#define WATCHDOG_TRESHOLD (NSEC_PER_SEC >> 4)
+#define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
 static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 {
-	if (delta > -WATCHDOG_TRESHOLD && delta < WATCHDOG_TRESHOLD)
+	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
 		return;
 
 	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-- 

-- 
