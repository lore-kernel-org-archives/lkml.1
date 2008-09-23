Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYIWXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYIWXbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYIWXbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:31:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:49315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYIWXbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:31:13 -0400
Subject: patch uio-change-driver-name-of-uio_pdrv.patch added to gregkh-2.6 tree
To: hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       ukleinek@strlen.de
From: <gregkh@suse.de>
Date: Tue, 23 Sep 2008 16:25:55 -0700
In-Reply-To: <20080918210306.GC2991@local>
Message-ID: <122221235522@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: UIO: Change driver name of uio_pdrv

to my gregkh-2.6 tree.  Its filename is

    uio-change-driver-name-of-uio_pdrv.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From hjk@linutronix.de  Tue Sep 23 15:59:56 2008
From: "Hans J. Koch" <hjk@linutronix.de>
Date: Thu, 18 Sep 2008 23:03:07 +0200
Subject: UIO: Change driver name of uio_pdrv
To: Greg KH <gregkh@suse.de>
Cc: Uwe Kleine-König <ukleinek@strlen.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20080918210306.GC2991@local>
Content-Disposition: inline


The generic UIO platform device driver should be given a unique driver ID and
not just "uio". This is especially important since we now have a similar driver
named uio_pdrv_genirq. Currently, there's no user of this driver in the
mainline kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/uio/uio_pdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -12,7 +12,7 @@
 #include <linux/uio_driver.h>
 #include <linux/stringify.h>
 
-#define DRIVER_NAME "uio"
+#define DRIVER_NAME "uio_pdrv"
 
 struct uio_platdata {
 	struct uio_info *uioinfo;


Patches currently in gregkh-2.6 which might be from hjk@linutronix.de are

bad/uio-irq.patch
driver-core/uio-add-alignment-warnings-for-uio-mem.patch
driver-core/uio-add-automata-sercos3-pci-card-support.patch
driver-core/uio-change-driver-name-of-uio_pdrv.patch
