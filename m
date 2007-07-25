Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbXGYMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbXGYMIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760845AbXGYMIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:20 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33032 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758854AbXGYMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:19 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7KgJ032178@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix definition of MCFDMA_DIR_INV
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a small typo in the definition of MCFDMA_DIR_INV (MCF5272 specific).

>From Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/include/asm-m68knommu/mcfdma.h linux-2.6.22-uc0/include/asm-m68knommu/mcfdma.h
--- linux-2.6.22/include/asm-m68knommu/mcfdma.h	2007-07-12 15:21:55.000000000 +1000
+++ linux-2.6.22-uc0/include/asm-m68knommu/mcfdma.h	2007-07-12 15:23:58.000000000 +1000
@@ -133,7 +133,7 @@
 #define MCFDMA_DIR_ASCEN     0x0800 /* Address Sequence Complete (Completion) interrupt enable */
 #define MCFDMA_DIR_TEEN      0x0200 /* Transfer Error interrupt enable */
 #define MCFDMA_DIR_TCEN      0x0100 /* Transfer Complete (a bus transfer, that is) interrupt enable */
-#define MCFDMA_DIR_INV       0x1000 /* Invalid Combination */
+#define MCFDMA_DIR_INV       0x0010 /* Invalid Combination */
 #define MCFDMA_DIR_ASC       0x0008 /* Address Sequence Complete (DMA Completion) */
 #define MCFDMA_DIR_TE        0x0002 /* Transfer Error */
 #define MCFDMA_DIR_TC        0x0001 /* Transfer Complete */
