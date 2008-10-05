Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbYJEQnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbYJEQnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760404AbYJEQjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:39:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54315 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760391AbYJEQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:39:08 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 18/19] modinfo: Remove duplicate modinfo from some drivers
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:39:08 +0100
Message-ID: <20081005163858.3799.47269.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 drivers/input/tablet/wacom_sys.c            |    4 ++++
 drivers/media/video/cx23885/cx23885-video.c |    4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 5fbc463..b7c372f 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -394,5 +394,9 @@ static void __exit wacom_exit(void)
 	usb_deregister(&wacom_driver);
 }
 
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE(DRIVER_LICENSE);
+
 module_init(wacom_init);
 module_exit(wacom_exit);
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 6047c78..022adc3 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -40,10 +40,6 @@
 #include <linux/videodev.h>
 #endif
 
-MODULE_DESCRIPTION("v4l2 driver module for cx23885 based TV cards");
-MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
-MODULE_LICENSE("GPL");
-
 /* ------------------------------------------------------------------ */
 
 static unsigned int video_nr[] = {[0 ... (CX23885_MAXBOARDS - 1)] = UNSET };

