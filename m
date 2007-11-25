Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbXKYWFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbXKYWFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXKYWFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:05:01 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36072 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757369AbXKYWFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:05:00 -0500
Date: Sun, 25 Nov 2007 23:04:47 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] finish the VID_HARDWARE_* removal
Message-ID: <20071125220447.GE18284@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a few remainders of the VID_HARDWARE_* removal.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/DocBook/videobook.tmpl      |    9 ---------
 drivers/media/video/usbvision/usbvision.h |    4 ----
 2 files changed, 13 deletions(-)

643d01fb38b6f376cced035549f4e193018776e7 
diff --git a/Documentation/DocBook/videobook.tmpl b/Documentation/DocBook/videobook.tmpl
index b629da3..b3d93ee 100644
--- a/Documentation/DocBook/videobook.tmpl
+++ b/Documentation/DocBook/videobook.tmpl
@@ -96,7 +96,6 @@ static struct video_device my_radio
 {
         "My radio",
         VID_TYPE_TUNER,
-        VID_HARDWARE_MYRADIO,
         radio_open.
         radio_close,
         NULL,                /* no read */
@@ -119,13 +118,6 @@ static struct video_device my_radio
         way to change channel so it is tuneable.
   </para>
   <para>
-        The VID_HARDWARE_ types are unique to each device. Numbers are assigned by
-        <email>alan@redhat.com</email> when device drivers are going to be released. Until then you
-        can pull a suitably large number out of your hat and use it. 10000 should be
-        safe for a very long time even allowing for the huge number of vendors
-        making new and different radio cards at the moment.
-  </para>
-  <para>
         We declare an open and close routine, but we do not need read or write,
         which are used to read and write video data to or from the card itself. As
         we have no read or write there is no poll function.
@@ -844,7 +836,6 @@ static struct video_device my_camera
         "My Camera",
         VID_TYPE_OVERLAY|VID_TYPE_SCALES|\
         VID_TYPE_CAPTURE|VID_TYPE_CHROMAKEY,
-        VID_HARDWARE_MYCAMERA,
         camera_open.
         camera_close,
         camera_read,      /* no read */
diff --git a/drivers/media/video/usbvision/usbvision.h b/drivers/media/video/usbvision/usbvision.h
index c5b6c50..2b7c1bf 100644
--- a/drivers/media/video/usbvision/usbvision.h
+++ b/drivers/media/video/usbvision/usbvision.h
@@ -40,10 +40,6 @@
 
 #define USBVISION_DEBUG		/* Turn on debug messages */
 
-#ifndef VID_HARDWARE_USBVISION
-	#define VID_HARDWARE_USBVISION 34   /* USBVision Video Grabber */
-#endif
-
 #define USBVISION_PWR_REG		0x00
 	#define USBVISION_SSPND_EN		(1 << 1)
 	#define USBVISION_RES2			(1 << 2)

