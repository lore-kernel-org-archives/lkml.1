Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZLGAXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZLGAXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbZLGAXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:23:14 -0500
Received: from kroah.org ([198.145.64.141]:34619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560AbZLGANh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:55 2009
Message-Id: <20091207000655.004715013@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Krufky <mkrufky@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [081/119] V4L/DVB (13202): smsusb: add autodetection support for three additional Hauppauge USB IDs
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13202-smsusb-add-autodetection-support-for-three-additional-hauppauge-usb-ids.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Krufky <mkrufky@kernellabs.com>

commit 78c948ab0cc44f9c8ae397d7d9d217bb498bfa2f upstream.

Add support for three new Hauppauge Device USB IDs:

2040:b900
2040:b910
2040:c000

Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---
 drivers/media/dvb/siano/smsusb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -529,6 +529,12 @@ struct usb_device_id smsusb_id_table[] =
 		.driver_info = SMS1XXX_BOARD_SIANO_NICE },
 	{ USB_DEVICE(0x187f, 0x0301),
 		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
+	{ USB_DEVICE(0x2040, 0xb900),
+		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+	{ USB_DEVICE(0x2040, 0xb910),
+		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+	{ USB_DEVICE(0x2040, 0xc000),
+		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ } /* Terminating entry */
 	};
 


