Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZCNAY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZCNAY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZCNASi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:38 -0400
Received: from kroah.org ([198.145.64.141]:46764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751683AbZCNASh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:41 2009
Message-Id: <20090314000741.290457012@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:25 -0700
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
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 17/96] rtl8187: New USB IDs for RTL8187L
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=rtl8187-new-usb-id-s-for-rtl8187l.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@gmail.com>

commit 046ee5d26ac91316a8ac0a29c0b33139dc9da20d upstream.

Add new USB ID codes. These come from two postings on forums and
mailing lists, and four are derived from the .inf that accompanies
the latest Realtek Windows driver for the RTL8187L.

Thanks to Viktor Ilijašić <viktor.ilijasic@gmail.com> and Xose Vazquez
Perez <xose.vazquez@gmail.com> for reporting these new ID's.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl8187_dev.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -40,6 +40,10 @@ static struct usb_device_id rtl8187_tabl
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8197), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
+	/* Surecom */
+	{USB_DEVICE(0x0769, 0x11F2), .driver_info = DEVICE_RTL8187},
+	/* Logitech */
+	{USB_DEVICE(0x0789, 0x010C), .driver_info = DEVICE_RTL8187},
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0846, 0x6a00), .driver_info = DEVICE_RTL8187},
@@ -49,8 +53,16 @@ static struct usb_device_id rtl8187_tabl
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
+	/* Sphairon Access Systems GmbH */
+	{USB_DEVICE(0x114B, 0x0150), .driver_info = DEVICE_RTL8187},
+	/* Dick Smith Electronics */
+	{USB_DEVICE(0x1371, 0x9401), .driver_info = DEVICE_RTL8187},
 	/* Abocom */
 	{USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
+	/* Qcom */
+	{USB_DEVICE(0x18E8, 0x6232), .driver_info = DEVICE_RTL8187},
+	/* AirLive */
+	{USB_DEVICE(0x1b75, 0x8187), .driver_info = DEVICE_RTL8187},
 	{}
 };
 


