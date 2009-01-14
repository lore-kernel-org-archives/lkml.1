Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbZANRUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbZANRUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763910AbZANRUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:20:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48299 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763649AbZANRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:20:23 -0500
Date: Wed, 14 Jan 2009 18:20:13 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, eric.piel@tremplin-utc.net
Subject: lis3: fix documentation to fit into 80 columns
Message-ID: <20090114172013.GA25948@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix lis3 documentation to fit into 80 columns.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit eeafe775925cc1d439daab3dfba3bb388ba5e038
tree 0ac90b1670ba7f7351bcdc246f86c66d15febb1f
parent f5f9696042990e4b2e280c6565dce5436e3bbf48
author Pavel <pavel@amd.ucw.cz> Wed, 14 Jan 2009 18:18:30 +0100
committer Pavel <pavel@amd.ucw.cz> Wed, 14 Jan 2009 18:18:30 +0100

 Documentation/hwmon/lis3lv02d |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
index 65dfb0c..0fcfc4a 100644
--- a/Documentation/hwmon/lis3lv02d
+++ b/Documentation/hwmon/lis3lv02d
@@ -13,18 +13,21 @@ Author:
 Description
 -----------
 
-This driver provides support for the accelerometer found in various HP laptops
-sporting the feature officially called "HP Mobile Data Protection System 3D" or
-"HP 3D DriveGuard". It detect automatically laptops with this sensor. Known models
-(for now the HP 2133, nc6420, nc2510, nc8510, nc84x0, nw9440 and nx9420) will
-have their axis automatically oriented on standard way (eg: you can directly
-play neverball).  The accelerometer data is readable via
+This driver provides support for the accelerometer found in various HP
+laptops sporting the feature officially called "HP Mobile Data
+Protection System 3D" or "HP 3D DriveGuard". It detect automatically
+laptops with this sensor. Known models (for now the HP 2133, nc6420,
+nc2510, nc8510, nc84x0, nw9440 and nx9420) will have their axis
+automatically oriented on standard way (eg: you can directly play
+neverball).  The accelerometer data is readable via
 /sys/devices/platform/lis3lv02d.
 
 Sysfs attributes under /sys/devices/platform/lis3lv02d/:
 position - 3D position that the accelerometer reports. Format: "(x,y,z)"
-calibrate - read: values (x, y, z) that are used as the base for input class device operation.
-            write: forces the base to be recalibrated with the current position.
+calibrate - read: values (x, y, z) that are used as the base for input
+		  class device operation.
+            write: forces the base to be recalibrated with the current
+		  position.
 rate - reports the sampling rate of the accelerometer device in HZ
 
 This driver also provides an absolute input class device, allowing
@@ -39,11 +42,12 @@ (aka "can play neverball out of the box"
  * When the laptop is horizontal the position reported is about 0 for X and Y
 and a positive value for Z
  * If the left side is elevated, X increases (becomes positive)
- * If the front side (where the touchpad is) is elevated, Y decreases (becomes negative)
+ * If the front side (where the touchpad is) is elevated, Y decreases
+	(becomes negative)
  * If the laptop is put upside-down, Z becomes negative
 
-If your laptop model is not recognized (cf "dmesg"), you can send an email to the
-authors to add it to the database.  When reporting a new laptop, please include
-the output of "dmidecode" plus the value of /sys/devices/platform/lis3lv02d/position
-in these four cases.
+If your laptop model is not recognized (cf "dmesg"), you can send an
+email to the authors to add it to the database.  When reporting a new
+laptop, please include the output of "dmidecode" plus the value of
+/sys/devices/platform/lis3lv02d/position in these four cases.
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
