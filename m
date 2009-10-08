Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZJHLCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZJHLCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZJHLCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:02:42 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:50196 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbZJHLCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 07:02:41 -0400
To: laurent.pinchart@skynet.be
Subject: [PATCH] [resend] Finally fix Logitech Quickcam for Notebooks Pro
Cc: linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 8 Oct 2009 13:01:55 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910081301.57688.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase UVC_CTRL_STREAMING_TIMEOUT to fix initialization of
Logitech Quickcam for Notebooks Pro.
This fixes following error messages:
uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
uvcvideo: Failed to query (129) UVC probe control : -110 (exp. 26).
uvcvideo: Failed to initialize the device (-5).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.31-orig/drivers/media/video/uvc/uvcvideo.h	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.31/drivers/media/video/uvc/uvcvideo.h	2009-10-07 13:47:27.000000000 +0200
@@ -304,7 +304,7 @@
 #define UVC_MAX_STATUS_SIZE	16
 
 #define UVC_CTRL_CONTROL_TIMEOUT	300
-#define UVC_CTRL_STREAMING_TIMEOUT	1000
+#define UVC_CTRL_STREAMING_TIMEOUT	3000
 
 /* Devices quirks */
 #define UVC_QUIRK_STATUS_INTERVAL	0x00000001


-- 
Ondrej Zary
