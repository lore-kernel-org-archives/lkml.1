Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYKQH0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYKQH0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYKQHVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:13 -0500
Received: from kroah.org ([198.145.64.141]:38329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbYKQHVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:02 -0500
Date: Sun, 16 Nov 2008 23:15:10 -0800
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
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/46] rtl8187 : support for Sitecom WL-168 0001 v4
Message-ID: <20081117071510.GP29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtl8187-support-for-sitecom-wl-168-0001-v4.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Jolliffe <bobjolliffe@gmail.com>

commit f3c769185a28b7947d97b3552a977102c1fac3f2 upstream.

the Sitecom 0001 v4 with product id 0x0df6:0028, uses Realtek's
RTL8187B and work fine with new 2.6.27 driver.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl8187_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -45,6 +45,7 @@ static struct usb_device_id rtl8187_tabl
 	{USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+	{USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
 	/* Abocom */
 	{USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
 	{}

-- 
