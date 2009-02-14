Return-Path: <linux-kernel-owner+w=401wt.eu-S1765052AbZBNB3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765052AbZBNB3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764085AbZBNBQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:06 -0500
Received: from kroah.org ([198.145.64.141]:50184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763317AbZBNBQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:03 -0500
Date: Fri, 13 Feb 2009 17:12:29 -0800
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
       alan@lxorguk.ukuu.org.uk, Hin-Tak Leung <htl10@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 05/48] zd1211rw: adding 0ace:0xa211 as a ZD1211 device
Message-ID: <20090214011229.GF17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="zd1211rw-adding-0ace-0xa211-as-a-zd1211-device.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hin-Tak Leung <hintak.leung@gmail.com>

commit 14990c69b5f51dd57b4e0e2373de50239ac861e2 upstream.

Christoph Biedl <sourceforge.bnwi@manchmal.in-ulm.de> reported success
in the sourceforge zd1211 mailing list on this addition. This product ID
was supported by the vendor driver ZD1211LnxDrv 2.22.0.0 (and possibly
earlier) and it probably should have been added earlier.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Christoph Biedl <sourceforge.bnwi@manchmal.in-ulm.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -37,6 +37,7 @@
 static struct usb_device_id usb_ids[] = {
 	/* ZD1211 */
 	{ USB_DEVICE(0x0ace, 0x1211), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0ace, 0xa211), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },

