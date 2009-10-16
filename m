Return-Path: <linux-kernel-owner+w=401wt.eu-S932910AbZJPR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbZJPR0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZJPR0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:26:47 -0400
Received: from kroah.org ([198.145.64.141]:48494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbZJPRSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:23 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:55 2009
Message-Id: <20091016171154.742172179@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?=C3=89ric=20Piel?= <eric.piel@tremplin-utc.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [16/46] USB: cp210x: Add support for the DW700 UART
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-cp210x-add-support-for-the-dw700-uart.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Éric Piel <eric.piel@tremplin-utc.net>

commit 6f88139eb9eae8003683689f93402264a73fb754 upstream.

In the Dell inspiron mini 10, the GPS is connected via a cp2102. This patch
adds detection of this USB device. (I haven't managed to use the GPS under
Linux yet, though)

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -114,6 +114,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x166A, 0x0303) }, /* Clipsal 5500PCU C-Bus USB interface */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };
 


