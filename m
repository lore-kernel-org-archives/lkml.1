Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935837Ab0CMAt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:49:57 -0500
Received: from kroah.org ([198.145.64.141]:47051 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935485Ab0CMAb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:58 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:13 2010
Message-Id: <20100313002712.990989964@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tanaka Akira <akr@fsij.org>
Subject: [089/145] USB: SIS USB2VGA DRIVER: support KAIRENs USB VGA adaptor USB20SVGA-MB-PLUS
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Tanaka Akira <akr@fsij.org>

commit bbcb8bbad52b8795912e8f02c2b319092b96078e upstream.

This patch adds the USB product ID of KAIREN's USB VGA Adaptor,
USB20SVGA-MB-PLUS, to sisusbvga work with it.

Signed-off-by: Tanaka Akira <akr@fsij.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3245,6 +3245,7 @@ static struct usb_device_id sisusb_table
 	{ USB_DEVICE(0x0711, 0x0902) },
 	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
+	{ USB_DEVICE(0x0711, 0x0920) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }


