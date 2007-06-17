Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbXFQJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbXFQJCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbXFQJCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:02:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36945 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbXFQJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:02:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Jun 2007 11:02:12 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] driver core: fix kernel doc of device_release_driver
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.d01dbfd3bbd7140c@s5r6.in-berlin.de>
Message-ID: <tkrat.e274cee5e34275a8@s5r6.in-berlin.de>
References: <tkrat.d01dbfd3bbd7140c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/base/dd.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc3/drivers/base/dd.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/base/dd.c
+++ linux-2.6.22-rc3/drivers/base/dd.c
@@ -294,17 +294,10 @@ int driver_attach(struct device_driver *
 	return bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);
 }
 
-/**
- *	device_release_driver - manually detach device from driver.
- *	@dev:	device.
- *
- *	Manually detach device from driver.
- *
+/*
  *	__device_release_driver() must be called with @dev->sem held.
- *	When called for a USB interface, @dev->parent->sem must be held
- *	as well.
+ *	When called for a USB interface, @dev->parent->sem must be held as well.
  */
-
 static void __device_release_driver(struct device * dev)
 {
 	struct device_driver * drv;
@@ -330,6 +323,13 @@ static void __device_release_driver(stru
 	}
 }
 
+/**
+ *	device_release_driver - manually detach device from driver.
+ *	@dev:	device.
+ *
+ *	Manually detach device from driver.
+ *	When called for a USB interface, @dev->parent->sem must be held.
+ */
 void device_release_driver(struct device * dev)
 {
 	/*

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/

