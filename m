Return-Path: <linux-kernel-owner+w=401wt.eu-S1763162AbYFGBRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763162AbYFGBRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbYFGBJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:21 -0400
Received: from sous-sol.org ([216.99.217.87]:42413 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760030AbYFGBJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:06 -0400
Message-Id: <20080607010549.387063761@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Filip Aben <f.aben@option.com>, Phil Dibowitz <phil@ipom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 04/50] USB: unusual_devs: Add support for GI 0401 SD-Card interface
Content-Disposition: inline; filename=usb-unusual_devs-add-support-for-gi-0401-sd-card-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Filip Aben <f.aben@option.com>

commit e7c6f80fd733218aa1e79efa5d9ece9f76966160 upstream

Enables the SD-Card interface on the GI 0401 HSUPA card from Option.

The unusual_devs.h entry is necessary because the device descriptor is
vendor-specific. That prevents usb-storage from binding to it as an
interface driver.

This revised patch adds a small comment explaining why and reduces the
rev range.

T:  Bus=02 Lev=01 Prnt=01 Port=06 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=ff Prot=ff MxPS=64 #Cfgs=  1
P:  Vendor=0af0 ProdID=7401 Rev= 0.00
S:  Manufacturer=Option N.V.
S:  Product=Globetrotter HSUPA Modem
C:* #Ifs=10 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 0 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 1 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 2 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 2 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 3 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 4 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 4 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 5 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 5 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 6 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 6 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 7 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 7 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=08(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=89(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=09(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 9 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8b(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Filip Aben <f.aben@option.com>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1285,6 +1285,16 @@ UNUSUAL_DEV( 0x0ace, 0x20ff, 0x0101, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_DEVICE ),
 
+/* Reported by F. Aben <f.aben@option.com>
+ * This device (wrongly) has a vendor-specific device descriptor.
+ * The entry is needed so usb-storage can bind to it's mass-storage
+ * interface as an interface driver */
+UNUSUAL_DEV( 0x0af0, 0x7401, 0x0000, 0x0000,
+		"Option",
+		"GI 0401 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
 #ifdef CONFIG_USB_STORAGE_ISD200
 UNUSUAL_DEV(  0x0bf6, 0xa001, 0x0100, 0x0110,
 		"ATI",

-- 
