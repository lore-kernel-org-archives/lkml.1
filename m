Return-Path: <linux-kernel-owner+w=401wt.eu-S1765469AbXGOQR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765469AbXGOQR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbXGOQFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:41 -0400
Received: from www.osadl.org ([213.239.205.134]:42644 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762413AbXGOQFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:21 -0400
Message-Id: <20070715155542.113820291@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 32/33] i386: Remove the useless #ifdef in i8253.h
Content-Disposition: inline; filename=i386-pit-remove-the-useless-ifdefs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 include/asm-i386/i8253.h |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.22-rc6-mm/include/asm-i386/i8253.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-i386/i8253.h	2007-07-15 17:48:11.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-i386/i8253.h	2007-07-15 17:48:22.000000000 +0200
@@ -8,12 +8,8 @@
 
 extern spinlock_t i8253_lock;
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-
 extern struct clock_event_device *global_clock_event;
 
 extern void setup_pit_timer(void);
 
-#endif
-
 #endif	/* __ASM_I8253_H__ */

-- 

