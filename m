Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXEHSvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXEHSvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXEHSvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:51:42 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:32829 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754446AbXEHSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:51:40 -0400
X-YMail-OSG: Vy.jO1sVM1kylxXs5FY2kVH0NhparSyjK6UaRte4Q7yh_ex2YuZ.9MsvqqxVvGQGjkh8jWjGhA--
From: Chris Wedgwood <cw@f00f.org>
Date: Tue, 8 May 2007 11:15:43 -0700
Subject: [PATCH] Remove unused device_probe_drivers function.
To: linux-kernel@vger.kernel.org
Message-Id: <20070508185136.611FE1827261@tuatara.stupidest.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Wedgwood <cw@f00f.org>
---
 drivers/base/dd.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

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
-- 
1.5.1.3

