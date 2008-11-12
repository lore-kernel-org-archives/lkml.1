Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYKLAjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYKLAjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYKLA0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:49 -0500
Received: from kroah.org ([198.145.64.141]:42536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753837AbYKLA0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:48 -0500
Date: Tue, 11 Nov 2008 16:24:06 -0800
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
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 35/49] zd1211rw: Add 2 device IDs
Message-ID: <20081112002406.GJ10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="zd1211rw-add-2-device-ids.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Drake <dsd@gentoo.org>

commit 0feec9dfe7b8880ab3b4c38d7cc4107dd706ea7f upstream.

07fa/1196
Bewan BWIFI-USB54AR: Tested by night1308, this device is a ZD1211B with
an AL2230S radio.

0ace/b215
HP 802.11abg: Tested by Robert Philippe

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -61,6 +61,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0ace, 0xb215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
@@ -82,6 +83,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },

-- 
