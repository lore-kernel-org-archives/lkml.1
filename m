Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZKJMmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZKJMmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZKJMm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:42:28 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52697 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbZKJMmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:42:25 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v2 10/10] LIS3: Update documentation to match latest changes
Date: Tue, 10 Nov 2009 14:41:12 +0200
Message-Id: <1257856872-11612-11-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1257856872-11612-10-git-send-email-samu.p.onkalo@nokia.com>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-10-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 10 Nov 2009 12:41:40.0078 (UTC) FILETIME=[265180E0:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 Documentation/hwmon/lis3lv02d |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
index 21f0902..e8ced22 100644
--- a/Documentation/hwmon/lis3lv02d
+++ b/Documentation/hwmon/lis3lv02d
@@ -20,18 +20,20 @@ sporting the feature officially called "HP Mobile Data Protection System 3D" or
 models (full list can be found in drivers/hwmon/hp_accel.c) will have their
 axis automatically oriented on standard way (eg: you can directly play
 neverball). The accelerometer data is readable via
-/sys/devices/platform/lis3lv02d.
+/sys/devices/platform/lis3lv02d. Reported values are scaled
+to mg values (1/1000th of earth gravity).
 
 Sysfs attributes under /sys/devices/platform/lis3lv02d/:
 position - 3D position that the accelerometer reports. Format: "(x,y,z)"
-calibrate - read: values (x, y, z) that are used as the base for input
-		  class device operation.
-            write: forces the base to be recalibrated with the current
-		   position.
-rate - reports the sampling rate of the accelerometer device in HZ
+rate - read reports the sampling rate of the accelerometer device in HZ.
+	write changes sampling rate of the accelerometer device.
+	Only values which are supported by HW are accepted.
+selftest - performs selftest for the chip as specified by chip manufacturer.
+	Acceptance limits for the selftest must be set in platform data.
 
 This driver also provides an absolute input class device, allowing
-the laptop to act as a pinball machine-esque joystick.
+the laptop to act as a pinball machine-esque joystick. Joystick device can be
+calibrated.
 
 On HP laptops, if the led infrastructure is activated, support for a led
 indicating disk protection will be provided as /sys/class/leds/hp::hddprotect.
-- 
1.5.6.3

