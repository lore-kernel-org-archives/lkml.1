Return-Path: <linux-kernel-owner+w=401wt.eu-S1764405AbXGZPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764405AbXGZPKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXGZPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:09:52 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47905 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755844AbXGZPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:09:52 -0400
Date: Fri, 27 Jul 2007 01:09:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707261509.l6QF90Tf004069@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: add prototype for ack_bad_irq
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create prototype for ack_bad_irq() for m68knommu.
Compilation of kernel/irq/handle.c fails without it.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/include/asm-m68knommu/hardirq.h linux/include/asm-m68knommu/hardirq.h
--- linux-2.6.23-rc1-git2/include/asm-m68knommu/hardirq.h	2007-07-26 10:39:14.000000000 +1000
+++ linux/include/asm-m68knommu/hardirq.h	2007-07-26 22:39:53.000000000 +1000
@@ -22,4 +22,6 @@
 # error HARDIRQ_BITS is too low!
 #endif
 
+void ack_bad_irq(unsigned int irq);
+
 #endif /* __M68K_HARDIRQ_H */
