Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZKINKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZKINKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZKINKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:10:39 -0500
Received: from smtp.nokia.com ([192.100.122.230]:53015 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZKINKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:10:38 -0500
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] staging: iio: Fix typos in documentation
Date: Mon,  9 Nov 2009 15:10:15 +0200
Message-Id: <1257772215-1396-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 09 Nov 2009 13:10:19.0648 (UTC) FILETIME=[FCD95000:01CA613D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spell-check wouln't catch these :)

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/iio/Documentation/device.txt   |    4 ++--
 drivers/staging/iio/Documentation/overview.txt |    9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/Documentation/device.txt b/drivers/staging/iio/Documentation/device.txt
index 6916cd3..69d9570 100644
--- a/drivers/staging/iio/Documentation/device.txt
+++ b/drivers/staging/iio/Documentation/device.txt
@@ -10,7 +10,7 @@ First allocate one using:
 
 struct iio_dev *indio_dev = iio_allocate_device();
 
-The fill in the following.
+Then fill in the following:
 
 indio_dev->dev.parent
   the struct device associated with the underlying hardware.
@@ -45,5 +45,5 @@ allocated prior to registering the device with the iio-core, but must
 be registered afterwards (otherwise the whole parentage of devices
 gets confused)
 
-On remove iio_device_unregister(indio_dev) will remove the device from
+On remove, iio_device_unregister(indio_dev) will remove the device from
 the core, and iio_free_device will clean up.
diff --git a/drivers/staging/iio/Documentation/overview.txt b/drivers/staging/iio/Documentation/overview.txt
index 64584ad..e39dfc1 100644
--- a/drivers/staging/iio/Documentation/overview.txt
+++ b/drivers/staging/iio/Documentation/overview.txt
@@ -24,11 +24,12 @@ hwmon with simple polled access to device channels via sysfs.
 * Event chrdevs.  These are similar to input in that they provide a
 route to user space for hardware triggered events. Such events include
 threshold detectors, free-fall detectors and more complex action
-detection.  They events themselves are currently very simple with
+detection.  The events themselves are currently very simple with
 merely an event code and a timestamp.  Any data associated with the
-event must be accessed via polling. Note a given device may have one
-or more event channel.  These events are turned on or off (if possible)
-via sysfs interfaces.
+event must be accessed via polling.
+
+Note: A given device may have one or more event channel.  These events are
+turned on or off (if possible) via sysfs interfaces.
 
 * Hardware ring buffer support.  Some recent sensors have included
 fifo / ring buffers on the sensor chip.  These greatly reduce the load
-- 
1.6.3.3

