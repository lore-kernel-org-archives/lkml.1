Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYKTOMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYKTOMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYKTOMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:12:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:34819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYKTOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:12:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] fuse: move FUSE_MINOR to miscdevice.h
Date: Thu, 20 Nov 2008 23:11:34 +0900
Message-Id: <1227190298-4585-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227190298-4585-1-git-send-email-tj@kernel.org>
References: <1227190298-4585-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:11:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move FUSE_MINOR to miscdevice.h.  While at it, de-uglify the file.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/fuse.h       |    3 ---
 include/linux/miscdevice.h |   42 +++++++++++++++++++++---------------------
 2 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 350fe97..7caa473 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -40,9 +40,6 @@
 /** The major number of the fuse character device */
 #define FUSE_MAJOR MISC_MAJOR
 
-/** The minor number of the fuse character device */
-#define FUSE_MINOR 229
-
 /* Make sure all structures are padded to 64bit boundary, so 32bit
    userspace works under 64bit kernels */
 
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 26433ec..0be9245 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -3,33 +3,33 @@
 #include <linux/module.h>
 #include <linux/major.h>
 
-#define PSMOUSE_MINOR  1
-#define MS_BUSMOUSE_MINOR 2
-#define ATIXL_BUSMOUSE_MINOR 3
-/*#define AMIGAMOUSE_MINOR 4	FIXME OBSOLETE */
-#define ATARIMOUSE_MINOR 5
-#define SUN_MOUSE_MINOR 6
-#define APOLLO_MOUSE_MINOR 7
-#define PC110PAD_MINOR 9
-/*#define ADB_MOUSE_MINOR 10	FIXME OBSOLETE */
+#define PSMOUSE_MINOR		1
+#define MS_BUSMOUSE_MINOR	2
+#define ATIXL_BUSMOUSE_MINOR	3
+/*#define AMIGAMOUSE_MINOR	4	FIXME OBSOLETE */
+#define ATARIMOUSE_MINOR	5
+#define SUN_MOUSE_MINOR		6
+#define APOLLO_MOUSE_MINOR	7
+#define PC110PAD_MINOR		9
+/*#define ADB_MOUSE_MINOR	10	FIXME OBSOLETE */
 #define WATCHDOG_MINOR		130	/* Watchdog timer     */
 #define TEMP_MINOR		131	/* Temperature Sensor */
-#define RTC_MINOR 135
+#define RTC_MINOR		135
 #define EFI_RTC_MINOR		136	/* EFI Time services */
-#define SUN_OPENPROM_MINOR 139
+#define SUN_OPENPROM_MINOR	139
 #define DMAPI_MINOR		140	/* DMAPI */
-#define NVRAM_MINOR 144
-#define SGI_MMTIMER        153
+#define NVRAM_MINOR		144
+#define SGI_MMTIMER		153
 #define STORE_QUEUE_MINOR	155
-#define I2O_MINOR 166
+#define I2O_MINOR		166
 #define MICROCODE_MINOR		184
-#define MWAVE_MINOR	219		/* ACP/Mwave Modem */
-#define MPT_MINOR	220
-#define MISC_DYNAMIC_MINOR 255
-
-#define TUN_MINOR	     200
-#define	HPET_MINOR	     228
-#define KVM_MINOR            232
+#define TUN_MINOR		200
+#define MWAVE_MINOR		219	/* ACP/Mwave Modem */
+#define MPT_MINOR		220
+#define	HPET_MINOR		228
+#define FUSE_MINOR		229
+#define KVM_MINOR		232
+#define MISC_DYNAMIC_MINOR	255
 
 struct device;
 
-- 
1.5.6

