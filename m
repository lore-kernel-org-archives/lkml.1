Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZCBOcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZCBOcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZCBOcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:32:06 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:44351 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbZCBOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:32:05 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, Pavel Machek <pavel@suse.cz>,
       Eric Piel <eric.piel@tremplin-utc.net>, Vladimir Botka <vbotka@suse.cz>,
       <Quoc.Pham@hp.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: 
Date: Mon,  2 Mar 2009 15:31:47 +0100
Message-Id: <1236004310-29196-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236004310-29196-1-git-send-email-daniel@caiaq.de>
References: <49ABB22F.7040508@tremplin-utc.net>
 <1236004310-29196-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

Fix english in Documentation, add "how to test" description.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Vladimir Botka <vbotka@suse.cz>
Cc: <Quoc.Pham@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 This patch is already in the -mm tree, posted as reference only.

 Documentation/hwmon/lis3lv02d |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN Documentation/hwmon/lis3lv02d~hp_accel-small-documentation-updates Documentation/hwmon/lis3lv02d
--- a/Documentation/hwmon/lis3lv02d~hp_accel-small-documentation-updates
+++ a/Documentation/hwmon/lis3lv02d
@@ -1,11 +1,11 @@
 Kernel driver lis3lv02d
-==================
+=======================
 
 Supported chips:
 
   * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
 
-Author:
+Authors:
         Yan Burman <burman.yan@gmail.com>
 	Eric Piel <eric.piel@tremplin-utc.net>
 
@@ -15,7 +15,7 @@ Description
 
 This driver provides support for the accelerometer found in various HP
 laptops sporting the feature officially called "HP Mobile Data
-Protection System 3D" or "HP 3D DriveGuard". It detect automatically
+Protection System 3D" or "HP 3D DriveGuard". It detects automatically
 laptops with this sensor. Known models (for now the HP 2133, nc6420,
 nc2510, nc8510, nc84x0, nw9440 and nx9420) will have their axis
 automatically oriented on standard way (eg: you can directly play
@@ -27,7 +27,7 @@ position - 3D position that the accelero
 calibrate - read: values (x, y, z) that are used as the base for input
 		  class device operation.
             write: forces the base to be recalibrated with the current
-		  position.
+		   position.
 rate - reports the sampling rate of the accelerometer device in HZ
 
 This driver also provides an absolute input class device, allowing
@@ -48,7 +48,7 @@ For better compatibility between the var
 the accelerometer are converted into a "standard" organisation of the axes
 (aka "can play neverball out of the box"):
  * When the laptop is horizontal the position reported is about 0 for X and Y
-and a positive value for Z
+	and a positive value for Z
  * If the left side is elevated, X increases (becomes positive)
  * If the front side (where the touchpad is) is elevated, Y decreases
 	(becomes negative)
@@ -59,3 +59,13 @@ email to the authors to add it to the da
 laptop, please include the output of "dmidecode" plus the value of
 /sys/devices/platform/lis3lv02d/position in these four cases.
 
+Q&A
+---
+
+Q: How do I safely simulate freefall? I have an HP "portable
+workstation" which has about 3.5kg and a plastic case, so letting it
+fall to the ground is out of question...
+
+A: The sensor is pretty sensitive, so your hands can do it. Lift it
+into free space, follow the fall with your hands for like 10
+centimeters. That should be enough to trigger the detection.
_
