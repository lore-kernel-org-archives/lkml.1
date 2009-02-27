Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZB0KvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZB0KvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758961AbZB0Kuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:50:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46554 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789AbZB0Kue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:50:34 -0500
Date: Fri, 27 Feb 2009 11:53:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Vladimir Botka <vbotka@suse.cz>, Quoc.Pham@hp.com
Subject: hp_accel: small documentation updates
Message-ID: <20090227105308.GA26101@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix english in Documentation, add "how to test" description.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
index 287f8c9..effe949 100644
--- a/Documentation/hwmon/lis3lv02d
+++ b/Documentation/hwmon/lis3lv02d
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
@@ -27,7 +27,7 @@ position - 3D position that the accelerometer reports. Format: "(x,y,z)"
 calibrate - read: values (x, y, z) that are used as the base for input
 		  class device operation.
             write: forces the base to be recalibrated with the current
-		  position.
+		   position.
 rate - reports the sampling rate of the accelerometer device in HZ
 
 This driver also provides an absolute input class device, allowing
@@ -48,7 +48,7 @@ For better compatibility between the various laptops. The values reported by
 the accelerometer are converted into a "standard" organisation of the axes
 (aka "can play neverball out of the box"):
  * When the laptop is horizontal the position reported is about 0 for X and Y
-and a positive value for Z
+	and a positive value for Z
  * If the left side is elevated, X increases (becomes positive)
  * If the front side (where the touchpad is) is elevated, Y decreases
 	(becomes negative)
@@ -59,3 +59,13 @@ email to the authors to add it to the database.  When reporting a new
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

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
