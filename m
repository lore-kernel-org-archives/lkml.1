Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYEPSUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYEPSUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbYEPSUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:20:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:52553 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYEPSU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DRkoPVPDYlNkE4zONM17dhD4KBEkTXOaKXLgSOOLG9mTKbImwRKOkYydijp+AtvLnoTw/vaFEZy9gGCDQd0K/rrz4+GqoMS4AQadsV6ghIP/WQWWSI61iDjjQVkTGe2BTm6k6tP536zNtPDIcIkRAGS3iiTMNbtq7gJ9FKS7Yck=
Subject: [PATCH] byteorder: don't directly include linux/byteorder/generic.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 May 2008 11:20:25 -0700
Message-Id: <1210962025.5915.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include asm/byteorder.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This is meant to be the no-impact change, but the include in
char/snsc_event.c could be dropped entirely.

 drivers/char/snsc_event.c                    |    2 +-
 drivers/media/video/et61x251/et61x251_core.c |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c   |    2 +-
 drivers/media/video/zc0301/zc0301_core.c     |    2 +-
 drivers/media/video/zoran_device.c           |    2 +-
 drivers/media/video/zoran_driver.c           |    2 +-
 drivers/net/wireless/atmel.c                 |    2 +-
 fs/befs/endian.h                             |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/snsc_event.c b/drivers/char/snsc_event.c
index 53b3d44..55a9589 100644
--- a/drivers/char/snsc_event.c
+++ b/drivers/char/snsc_event.c
@@ -17,7 +17,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <linux/byteorder/generic.h>
+#include <asm/byteorder.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/unaligned.h>
 #include "snsc.h"
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index 5e749c5..15d037a 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -34,7 +34,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/page-flags.h>
-#include <linux/byteorder/generic.h>
+#include <asm/byteorder.h>
 #include <asm/page.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 5748b1e..7f9c7bc 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -34,7 +34,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/page-flags.h>
-#include <linux/byteorder/generic.h>
+#include <asm/byteorder.h>
 #include <asm/page.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/media/video/zc0301/zc0301_core.c b/drivers/media/video/zc0301/zc0301_core.c
index 363dd2b..e5c4e9f 100644
--- a/drivers/media/video/zc0301/zc0301_core.c
+++ b/drivers/media/video/zc0301/zc0301_core.c
@@ -38,7 +38,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/page-flags.h>
-#include <linux/byteorder/generic.h>
+#include <asm/byteorder.h>
 #include <asm/page.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/media/video/zoran_device.c b/drivers/media/video/zoran_device.c
index 7b60533..37629ff 100644
--- a/drivers/media/video/zoran_device.c
+++ b/drivers/media/video/zoran_device.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
-#include <linux/byteorder/generic.h>
 
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
@@ -47,6 +46,7 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 
+#include <asm/byteorder.h>
 #include <asm/io.h>
 
 #include "videocodec.h"
diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index 0134bec..345c77e 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -52,7 +52,6 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
-#include <linux/byteorder/generic.h>
 
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
@@ -74,6 +73,7 @@
 #include <media/v4l2-common.h>
 #include "videocodec.h"
 
+#include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/proc_fs.h>
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index ef2da40..438e63e 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -47,6 +47,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/timer.h>
+#include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -60,7 +61,6 @@
 #include <linux/delay.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
-#include <linux/byteorder/generic.h>
 #include <linux/crc32.h>
 #include <linux/proc_fs.h>
 #include <linux/device.h>
diff --git a/fs/befs/endian.h b/fs/befs/endian.h
index e254a20..6cb84d8 100644
--- a/fs/befs/endian.h
+++ b/fs/befs/endian.h
@@ -9,7 +9,7 @@
 #ifndef LINUX_BEFS_ENDIAN
 #define LINUX_BEFS_ENDIAN
 
-#include <linux/byteorder/generic.h>
+#include <asm/byteorder.h>
 
 static inline u64
 fs64_to_cpu(const struct super_block *sb, fs64 n)
-- 
1.5.5.1.570.g26b5e



