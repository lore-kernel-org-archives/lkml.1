Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYLCULL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYLCULL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYLCTy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:26 -0500
Received: from kroah.org ([198.145.64.141]:60228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754847AbYLCTyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:24 -0500
Date: Wed, 3 Dec 2008 11:52:41 -0800
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
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>,
       Zoomer <zoomer.gm@gmail.com>
Subject: [patch 053/104] rtl8187: add device ID 0bda:8198
Message-ID: <20081203195241.GB8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtl8187-add-device-id-0bda-8198.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: John W. Linville <linville@tuxdriver.com>

commit 746db510395e32ff57b9f8582e520df6b3fac618 upstream.

Reported by zOOmER.gm@gmail.com to work here:

	http://bugzilla.kernel.org/show_bug.cgi?id=11728

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Zoomer <zoomer.gm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl8187_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -37,6 +37,7 @@ static struct usb_device_id rtl8187_tabl
 	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8197), .driver_info = DEVICE_RTL8187B},
+	{USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0846, 0x6a00), .driver_info = DEVICE_RTL8187},

