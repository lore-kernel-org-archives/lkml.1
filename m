Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbXFCUyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbXFCUyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbXFCUyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:54:15 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52699 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752695AbXFCUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:54:14 -0400
Date: Sun, 3 Jun 2007 22:54:17 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, khali@linux-fr.org,
       Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: [-mm patch] drivers/i2c/chips/ds1682.c: make code static
Message-ID: <20070603205417.GP5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/i2c/chips/ds1682.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.22-rc3-mm1/drivers/i2c/chips/ds1682.c.old	2007-06-03 22:18:53.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/i2c/chips/ds1682.c	2007-06-03 22:21:07.000000000 +0200
@@ -121,12 +121,12 @@
 /*
  * Simple register attributes
  */
-SENSOR_DEVICE_ATTR_2(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
-		     4, DS1682_REG_ELAPSED);
-SENSOR_DEVICE_ATTR_2(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
-		     4, DS1682_REG_ALARM);
-SENSOR_DEVICE_ATTR_2(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
-		     2, DS1682_REG_EVT_CNTR);
+static SENSOR_DEVICE_ATTR_2(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show,
+			    ds1682_store, 4, DS1682_REG_ELAPSED);
+static SENSOR_DEVICE_ATTR_2(alarm_time, S_IRUGO | S_IWUSR, ds1682_show,
+			    ds1682_store, 4, DS1682_REG_ALARM);
+static SENSOR_DEVICE_ATTR_2(event_count, S_IRUGO | S_IWUSR, ds1682_show,
+			    ds1682_store, 2, DS1682_REG_EVT_CNTR);
 
 static const struct attribute_group ds1682_group = {
 	.attrs = (struct attribute *[]) {

