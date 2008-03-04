Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbYCDGgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbYCDGgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYCDGgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:36:10 -0500
Received: from rex.snapgear.com ([203.143.235.140]:33020 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbYCDGgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:36:09 -0500
Date: Tue, 4 Mar 2008 16:35:04 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200803040635.m246Z40b016751@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: declare do_IRQ()
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need a declaration of do_IRQ for the 68328 interrupt handling code.
It is common to all m68knommu targets, so a common declaration makes
sense.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc3/include/asm-m68knommu/machdep.h linux-2.6.25-rc3.foo/include/asm-m68knommu/machdep.h
--- linux-2.6.25-rc3/include/asm-m68knommu/machdep.h	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.25-rc3.foo/include/asm-m68knommu/machdep.h	2008-03-04 16:09:28.000000000 +1000
@@ -21,4 +21,6 @@ extern void (*mach_power_off)( void );
 
 extern void config_BSP(char *command, int len);
 
+extern void do_IRQ(int irq, struct pt_regs *fp);
+
 #endif /* _M68KNOMMU_MACHDEP_H */
