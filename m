Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYEFFFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYEFFFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYEFFFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:05:25 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57461 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbYEFFFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:05:25 -0400
Date: Tue, 6 May 2008 15:04:36 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805060504.m4654as1004242@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: ColdFire add support for kernel preemption (missing chunk)
Cc: akpm@linux-foundation.org, bigeasy@linutronix.de, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

As the subject says this patch adds the support for kernel preemption
on m68knommu Coldfire. I thing the same changes could be applied to
68360 & 68328 but since I don't have the HW, I don't touch it. Kconfig
enables the preemption item only on coldfire.

[This is a missing chunk from Sebastian's original patch that I lost from
the first submission. It rebased so it applies to 2.6.26-rc1 -- gerg]

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>


--- linux-2.6.25/arch/m68knommu/Kconfig	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/Kconfig	2008-05-02 18:32:22.000000000 +1000
@@ -671,6 +671,9 @@ config ROMKERNEL
 
 endchoice
 
+if COLDFIRE
+source "kernel/Kconfig.preempt"
+endif
 source "mm/Kconfig"
 
 endmenu
