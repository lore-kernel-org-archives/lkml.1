Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbXGYMJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbXGYMJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763223AbXGYMIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:39 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33036 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762935AbXGYMIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:35 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7KIK032172@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: need to include linux/device.h in dma.c
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Need to explicitly include linux/device.h.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/kernel/dma.c linux-2.6.22-uc0/arch/m68knommu/kernel/dma.c
--- linux-2.6.22/arch/m68knommu/kernel/dma.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/kernel/dma.c	2007-07-12 15:27:00.000000000 +1000
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/string.h>
+#include <linux/device.h>
 #include <asm/io.h>
 
 void *dma_alloc_coherent(struct device *dev, size_t size,
