Return-Path: <linux-kernel-owner+w=401wt.eu-S1763051AbXGOQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763051AbXGOQGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762249AbXGOQEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:04:51 -0400
Received: from www.osadl.org ([213.239.205.134]:42528 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762085AbXGOQEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:50 -0400
Message-Id: <20070715155540.679507835@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>
Subject: [patch-mm 01/33] clockevents: Remove unused inline function
Content-Disposition: inline;
	filename=clockevents-remove-unused-inline-function.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 include/linux/clockchips.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.22-rc6-mm/include/linux/clockchips.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/linux/clockchips.h	2007-07-15 09:44:00.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/linux/clockchips.h	2007-07-15 17:49:11.000000000 +0200
@@ -131,7 +131,6 @@ extern void clockevents_notify(unsigned 
 
 #else
 
-static inline void clockevents_resume_events(void) { }
 #define clockevents_notify(reason, arg) do { } while (0)
 
 #endif

-- 

