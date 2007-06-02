Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbXFBRHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbXFBRHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbXFBRG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:06:56 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51822 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759206AbXFBRGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:06:55 -0400
Date: Sat, 2 Jun 2007 19:06:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [-mm patch] fix XEN_BLKDEV_FRONTEND Makefile entry
Message-ID: <20070602170657.GF5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_XEN_BLKDEV_FRONTEND shouldn't silently prevent the compilation of 
most other block drivers.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc3-mm1/drivers/block/Makefile.old	2007-06-02 18:21:12.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/block/Makefile	2007-06-02 18:21:53.000000000 +0200
@@ -28,7 +28,7 @@
 obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
-obj-$(CONFIG_XEN_BLKDEV_FRONTEND) := xen-blkfront.o
+obj-$(CONFIG_XEN_BLKDEV_FRONTEND) += xen-blkfront.o
 obj-$(CONFIG_XILINX_SYSACE)	+= xsysace.o
 obj-$(CONFIG_LGUEST_GUEST)	+= lguest_blk.o
 

