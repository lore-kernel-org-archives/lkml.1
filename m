Return-Path: <linux-kernel-owner+w=401wt.eu-S1763160AbYGaAWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763160AbYGaAWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbYGaAUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:20:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbYGaAUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:20:33 -0400
Date: Wed, 30 Jul 2008 16:59:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Tim Gardner <tim.gardner@canonical.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 44/62] V4L: uvcvideo: Add support for Medion Akoya Mini
	E1210 integrated webcam
Message-ID: <20080730235926.GR12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-uvcvideo-add-support-for-medion-akoya-mini-e1210-integrated-webcam.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Laurent Pinchart <laurent.pinchart@skynet.be>

(cherry picked from commit bdf2fe4a0b9d23e69c77eaec76212216c9a957ef)

V4L: uvcvideo: Add support for Medion Akoya Mini E1210 integrated webcam

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1892,6 +1892,15 @@ static struct usb_device_id uvc_ids[] = 
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Medion Akoya Mini E1210 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x5986,
+	  .idProduct		= 0x0141,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
 	/* Acer OrbiCam - Unknown vendor */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,

-- 
