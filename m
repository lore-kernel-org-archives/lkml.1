Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXFJJb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXFJJb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXFJJa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:30:57 -0400
Received: from www.osadl.org ([213.239.205.134]:43029 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752701AbXFJJay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:30:54 -0400
Message-Id: <20070610092446.474630903@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 03/23] Clockevents remove prototypes of removed functions
Content-Disposition: inline; filename=clockevents-remove-unused-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/clockchips.h |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.22-rc4-mm/include/linux/clockchips.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/linux/clockchips.h	2007-06-10 10:44:37.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/linux/clockchips.h	2007-06-10 10:44:38.000000000 +0200
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

