Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbXE0Kfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbXE0Kfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXE0Kfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:35:43 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33166 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbXE0Kfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:35:43 -0400
Date: Sun, 27 May 2007 06:35:42 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/base: kill unused function
Message-ID: <20070527103542.GA10635@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 92428e5..b0088b0 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -207,19 +207,6 @@ static int __device_attach(struct device_driver * drv, void * data)
 	return driver_probe_device(drv, dev);
 }
 
-static int device_probe_drivers(void *data)
-{
-	struct device *dev = data;
-	int ret = 0;
-
-	if (dev->bus) {
-		down(&dev->sem);
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-		up(&dev->sem);
-	}
-	return ret;
-}
-
 /**
  *	device_attach - try to attach device to a driver.
  *	@dev:	device.
