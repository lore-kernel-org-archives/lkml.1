Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbZKFWlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbZKFWlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbZKFWls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:48 -0500
Received: from www.tglx.de ([62.245.132.106]:53984 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099AbZKFWlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:44 -0500
Message-Id: <20091106223806.519088363@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/16] net: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=net-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Use DEFINE_SPINLOCK instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: netdev@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>
---
 net/core/drop_monitor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/net/core/drop_monitor.c
===================================================================
--- linux-2.6.orig/net/core/drop_monitor.c
+++ linux-2.6/net/core/drop_monitor.c
@@ -41,7 +41,7 @@ static void send_dm_alert(struct work_st
  * netlink alerts
  */
 static int trace_state = TRACE_OFF;
-static spinlock_t trace_state_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(trace_state_lock);
 
 struct per_cpu_dm_data {
 	struct work_struct dm_alert_work;


