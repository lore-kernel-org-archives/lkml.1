Return-Path: <linux-kernel-owner+w=401wt.eu-S935339AbXGKXia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339AbXGKXia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935077AbXGKXds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:48 -0400
Received: from mx1.suse.de ([195.135.220.2]:33720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935073AbXGKXdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/61] driver core: fix kernel doc of device_release_driver
Date: Wed, 11 Jul 2007 16:31:31 -0700
Message-Id: <11841968032469-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841967992975-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 3c503e1..7ac474d 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -281,17 +281,10 @@ int driver_attach(struct device_driver * drv)
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
@@ -317,6 +310,13 @@ static void __device_release_driver(struct device * dev)
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
1.5.2.2

