Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbXFWNXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbXFWNXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXFWNWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:01 -0400
Received: from www.osadl.org ([213.239.205.134]:59210 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756726AbXFWNV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:21:58 -0400
Message-Id: <20070623124030.395897155@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 06/28] Clockevents remove prototypes of removed functions
Content-Disposition: inline; filename=clockevents-remove-unused-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/clockchips.h |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.22-rc4-mm/include/linux/clockchips.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/linux/clockchips.h	2007-06-23 14:38:56.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/linux/clockchips.h	2007-06-23 14:38:58.000000000 +0200
@@ -119,10 +119,6 @@ extern void clockevents_register_device(
 
 extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
-extern
-struct clock_event_device *clockevents_request_device(unsigned int features,
-						      cpumask_t cpumask);
-extern void clockevents_release_device(struct clock_event_device *dev);
 extern void clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
 extern int clockevents_register_notifier(struct notifier_block *nb);

-- 

