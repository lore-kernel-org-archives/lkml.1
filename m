Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbZJBBgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbZJBBgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZJBBgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:36:51 -0400
Received: from kroah.org ([198.145.64.141]:33600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbZJBBeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:27 2009
Message-Id: <20091002012427.414400124@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Scholz <Scholz@fias.uni-frankfurt.de>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [129/136] HID: completely remove apple mightymouse from blacklist
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=hid-completely-remove-apple-mightymouse-from-blacklist.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Scholz <Scholz@fias.uni-frankfurt.de>

commit 42960a13001aa6df52ca9952ce996f94a744ea65 upstream.

Commit fa047e4f6fa63a6e9d0ae4d7749538830d14a343 "HID: fix inverted
wheel for bluetooth version of apple mighty mouse" is incomplete. If
we remove Apple MightyMouse (bluetooth version) from the list of
apple_devices in drivers/hid/hid-apple.c we have to remove it from
hid_blacklist in drivers/hid/hid-core.c as well.

Signed-off-by: Jan Scholz <Scholz@fias.uni-frankfurt.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1319,7 +1319,6 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
 	{ }
 };


