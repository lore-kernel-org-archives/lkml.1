Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbXJMOta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbXJMOta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760925AbXJMOmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:38 -0400
Received: from 1wt.eu ([62.212.114.60]:2997 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761942AbXJMOmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:37 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143502.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:44 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: <dac@conglom-o.org>, Alessandro Polverini <alex@nibbles.it>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 22/35] Fix "Fix DAC960 driver on machines which dont support 64-bit DMA"
Content-Disposition: inline; filename=0076-Fix-Fix-DAC960-driver-on-machines-which-don-t-suppo.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3558c9b3232b5f0fd9f32043a191eca20fca64c6 in mainline.

sparc32:

drivers/block/DAC960.c: In function 'DAC960_V1_EnableMemoryMailboxInterface':
drivers/block/DAC960.c:1168: error: 'DMA_32BIT_MASK' undeclared (first use in this function)
drivers/block/DAC960.c:1168: error: (Each undeclared identifier is reported only

Cc: <dac@conglom-o.org>
Cc: Alessandro Polverini <alex@nibbles.it>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/DAC960.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: 2.6/drivers/block/DAC960.c
===================================================================
--- 2.6.orig/drivers/block/DAC960.c
+++ 2.6/drivers/block/DAC960.c
@@ -31,6 +31,7 @@
 #include <linux/genhd.h>
 #include <linux/hdreg.h>
 #include <linux/blkpg.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>

-- 
