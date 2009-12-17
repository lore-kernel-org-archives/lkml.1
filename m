Return-Path: <linux-kernel-owner+w=401wt.eu-S1765323AbZLQSNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765323AbZLQSNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765298AbZLQSNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:13:12 -0500
Received: from smtp.nokia.com ([192.100.122.233]:36308 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbZLQSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:13:08 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 6/6] gpio: Example of how easy it is to mark attributes const
Date: Thu, 17 Dec 2009 20:12:16 +0200
Message-Id: <1261073536-27396-7-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261073536-27396-6-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-4-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-5-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-6-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 17 Dec 2009 18:12:00.0312 (UTC) FILETIME=[6D61F380:01CA7F44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These attributes may now be placed in ro sections.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 drivers/gpio/gpiolib.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 50de0f5..be99438 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -255,7 +255,7 @@ static ssize_t gpio_direction_store(struct device *dev,
 	return status ? : size;
 }
 
-static const DEVICE_ATTR(direction, 0644,
+static DEVICE_CATTR(direction, 0644,
 		gpio_direction_show, gpio_direction_store);
 
 static ssize_t gpio_value_show(struct device *dev,
@@ -303,7 +303,7 @@ static ssize_t gpio_value_store(struct device *dev,
 	return status;
 }
 
-static /*const*/ DEVICE_ATTR(value, 0644,
+static DEVICE_CATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
@@ -473,7 +473,7 @@ found:
 	return status;
 }
 
-static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
+static DEVICE_CATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
 
 static const struct attribute *gpio_attrs[] = {
 	&dev_attr_direction.attr,
@@ -499,7 +499,7 @@ static ssize_t chip_base_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", chip->base);
 }
-static DEVICE_ATTR(base, 0444, chip_base_show, NULL);
+static DEVICE_CATTR(base, 0444, chip_base_show, NULL);
 
 static ssize_t chip_label_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -508,7 +508,7 @@ static ssize_t chip_label_show(struct device *dev,
 
 	return sprintf(buf, "%s\n", chip->label ? : "");
 }
-static DEVICE_ATTR(label, 0444, chip_label_show, NULL);
+static DEVICE_CATTR(label, 0444, chip_label_show, NULL);
 
 static ssize_t chip_ngpio_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -517,7 +517,7 @@ static ssize_t chip_ngpio_show(struct device *dev,
 
 	return sprintf(buf, "%u\n", chip->ngpio);
 }
-static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
+static DEVICE_CATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
 static const struct attribute *gpiochip_attrs[] = {
 	&dev_attr_base.attr,
-- 
1.6.0.4

