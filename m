Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbYJVRht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbYJVRht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbYJVRdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:19 -0400
Received: from kroah.org ([198.145.64.141]:53038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757320AbYJVRdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Huang Weiyi <weiyi.huang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/42] Staging: go7007: remove unused #include <version.h>
Date: Wed, 22 Oct 2008 10:28:54 -0700
Message-Id: <1224696563-5170-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/staging/go7007/go7007-driver.c
  drivers/staging/go7007/go7007-fw.c
  drivers/staging/go7007/go7007-i2c.c
  drivers/staging/go7007/go7007-usb.c
  drivers/staging/go7007/snd-go7007.c
  drivers/staging/go7007/wis-ov7640.c
  drivers/staging/go7007/wis-saa7113.c
  drivers/staging/go7007/wis-saa7115.c
  drivers/staging/go7007/wis-sony-tuner.c
  drivers/staging/go7007/wis-tw2804.c
  drivers/staging/go7007/wis-tw9903.c
  drivers/staging/go7007/wis-uda1342.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/go7007/go7007-driver.c  |    1 -
 drivers/staging/go7007/go7007-fw.c      |    1 -
 drivers/staging/go7007/go7007-i2c.c     |    1 -
 drivers/staging/go7007/go7007-usb.c     |    1 -
 drivers/staging/go7007/snd-go7007.c     |    1 -
 drivers/staging/go7007/wis-ov7640.c     |    1 -
 drivers/staging/go7007/wis-saa7113.c    |    1 -
 drivers/staging/go7007/wis-saa7115.c    |    1 -
 drivers/staging/go7007/wis-sony-tuner.c |    1 -
 drivers/staging/go7007/wis-tw2804.c     |    1 -
 drivers/staging/go7007/wis-tw9903.c     |    1 -
 drivers/staging/go7007/wis-uda1342.c    |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 81ae4b0..e4ead96 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/go7007/go7007-fw.c b/drivers/staging/go7007/go7007-fw.c
index c2aea10..a0e17b0 100644
--- a/drivers/staging/go7007/go7007-fw.c
+++ b/drivers/staging/go7007/go7007-fw.c
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/device.h>
diff --git a/drivers/staging/go7007/go7007-i2c.c b/drivers/staging/go7007/go7007-i2c.c
index 10baae3..cd55b76 100644
--- a/drivers/staging/go7007/go7007-i2c.c
+++ b/drivers/staging/go7007/go7007-i2c.c
@@ -15,7 +15,6 @@
  * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
index d4ed6d2..3f5ee34 100644
--- a/drivers/staging/go7007/go7007-usb.c
+++ b/drivers/staging/go7007/go7007-usb.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/wait.h>
diff --git a/drivers/staging/go7007/snd-go7007.c b/drivers/staging/go7007/snd-go7007.c
index 382740c..a7de401 100644
--- a/drivers/staging/go7007/snd-go7007.c
+++ b/drivers/staging/go7007/snd-go7007.c
@@ -17,7 +17,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
diff --git a/drivers/staging/go7007/wis-ov7640.c b/drivers/staging/go7007/wis-ov7640.c
index f5f11e9..2f9efca 100644
--- a/drivers/staging/go7007/wis-ov7640.c
+++ b/drivers/staging/go7007/wis-ov7640.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 
diff --git a/drivers/staging/go7007/wis-saa7113.c b/drivers/staging/go7007/wis-saa7113.c
index c1aff1b..1168972 100644
--- a/drivers/staging/go7007/wis-saa7113.c
+++ b/drivers/staging/go7007/wis-saa7113.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
diff --git a/drivers/staging/go7007/wis-saa7115.c b/drivers/staging/go7007/wis-saa7115.c
index 5c94c88..59417a7 100644
--- a/drivers/staging/go7007/wis-saa7115.c
+++ b/drivers/staging/go7007/wis-saa7115.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
diff --git a/drivers/staging/go7007/wis-sony-tuner.c b/drivers/staging/go7007/wis-sony-tuner.c
index 5997fb4..5a91ee4 100644
--- a/drivers/staging/go7007/wis-sony-tuner.c
+++ b/drivers/staging/go7007/wis-sony-tuner.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
diff --git a/drivers/staging/go7007/wis-tw2804.c b/drivers/staging/go7007/wis-tw2804.c
index 27fe4d0..57b8f2b 100644
--- a/drivers/staging/go7007/wis-tw2804.c
+++ b/drivers/staging/go7007/wis-tw2804.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
diff --git a/drivers/staging/go7007/wis-tw9903.c b/drivers/staging/go7007/wis-tw9903.c
index d8e4196..40627b2 100644
--- a/drivers/staging/go7007/wis-tw9903.c
+++ b/drivers/staging/go7007/wis-tw9903.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
diff --git a/drivers/staging/go7007/wis-uda1342.c b/drivers/staging/go7007/wis-uda1342.c
index a0894e3..555645c 100644
--- a/drivers/staging/go7007/wis-uda1342.c
+++ b/drivers/staging/go7007/wis-uda1342.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/tvaudio.h>
-- 
1.6.0.2

