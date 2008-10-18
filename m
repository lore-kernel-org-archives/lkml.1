Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYJREmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYJREmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 00:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYJREmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 00:42:00 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:42221 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYJREl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 00:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=EbnZ31v4uyMcEtJ8iHMC6qZp/uo6TeH4NMCOjYDjjx+Tn1Zi2pZZAMtOVDEXKEApMN
         79/TPpPHLnWkhZprqB+96SqCX/veHixlBGSV3LREqFimfJEjFbsMbsmt0yXY7Lf2Yx8t
         L0H+YefL9/qqusSbH4YbBMmDOB5wfRy0JYaXY=
Date: Sat, 18 Oct 2008 12:41:55 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: go7007: remove unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081018122145.CD6C.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

