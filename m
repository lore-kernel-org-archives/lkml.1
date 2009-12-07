Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZLGANg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZLGANg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbZLGANe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:34 -0500
Received: from kroah.org ([198.145.64.141]:34524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785AbZLGANZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:52 2009
Message-Id: <20091207000652.343904207@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: [068/119] V4L/DVB (12696): gspca - sonixj / sn9c102: Two drivers for 0c45:60fc and 0c45:613e.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-12696-gspca-sonixj-sn9c102-two-drivers-for-0c45-60fc-and-0c45-613e.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean-Francois Moine <moinejf@free.fr>

commit f077b0a64856c5b3bf346ae9fba8631c1fb210cf upstream.

Let 0c45:60fc in sn9c102 and 0c45:613e in gspca-sonixj (sensor not supported).

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sonixj.c             |    2 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -2325,8 +2325,8 @@ static const __devinitdata struct usb_de
 /*	{USB_DEVICE(0x0c45, 0x60ef), BSI(SN9C105, ICM105C, 0x??)}, */
 /*	{USB_DEVICE(0x0c45, 0x60fa), BSI(SN9C105, OV7648, 0x??)}, */
 	{USB_DEVICE(0x0c45, 0x60fb), BSI(SN9C105, OV7660, 0x21)},
-	{USB_DEVICE(0x0c45, 0x60fc), BSI(SN9C105, HV7131R, 0x11)},
 #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
+	{USB_DEVICE(0x0c45, 0x60fc), BSI(SN9C105, HV7131R, 0x11)},
 	{USB_DEVICE(0x0c45, 0x60fe), BSI(SN9C105, OV7630, 0x21)},
 #endif
 	{USB_DEVICE(0x0c45, 0x6100), BSI(SN9C120, MI0360, 0x5d)}, /*sn9c128*/
--- a/drivers/media/video/sn9c102/sn9c102_devtable.h
+++ b/drivers/media/video/sn9c102/sn9c102_devtable.h
@@ -123,8 +123,8 @@ static const struct usb_device_id sn9c10
 	{ SN9C102_USB_DEVICE(0x0c45, 0x613b, BRIDGE_SN9C120), },
 #if !defined CONFIG_USB_GSPCA && !defined CONFIG_USB_GSPCA_MODULE
 	{ SN9C102_USB_DEVICE(0x0c45, 0x613c, BRIDGE_SN9C120), },
-#endif
 	{ SN9C102_USB_DEVICE(0x0c45, 0x613e, BRIDGE_SN9C120), },
+#endif
 	{ }
 };
 


