Return-Path: <linux-kernel-owner+w=401wt.eu-S1763799AbZCTXgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763799AbZCTXgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763009AbZCTXYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:47 -0400
Received: from kroah.org ([198.145.64.141]:48727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762999AbZCTXYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:27 2009
Message-Id: <20090320222927.323747141@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Jan Dumon <j.dumon@option.com>,
       Phil Dibowitz <phil@ipom.com>
Subject: [patch 28/43] USB: unusual_devs: Add support for GI 0431 SD-Card interface
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-unusual_devs-add-support-for-gi-0431-sd-card-interface.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Dumon <j.dumon@option.com>

commit c497e715f93d148d751c055401568684eea0bf6b upstream.

Enable the SD-Card interface on the GI 0431 HSUPA stick from Option.

The unusual_devs.h entry is necessary because the device descriptor is
vendor-specific. That prevents usb-storage from binding to it as an
interface driver.

T:  Bus=07 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#= 15 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=ff Prot=ff MxPS=64 #Cfgs=  1
P:  Vendor=0af0 ProdID=7501 Rev= 0.00
S:  Manufacturer=Option N.V.
S:  Product=Globetrotter HSUPA Modem
C:* #Ifs=11 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=hso
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=hso
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=hso
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 7 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=hso
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=08(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 8 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=09(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 9 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=hso
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=8b(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#=10 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8c(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Jan Dumon <j.dumon@option.com>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1330,6 +1330,16 @@ UNUSUAL_DEV( 0x0af0, 0x7401, 0x0000, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		0 ),
 
+/* Reported by Jan Dumon <j.dumon@option.com>
+ * This device (wrongly) has a vendor-specific device descriptor.
+ * The entry is needed so usb-storage can bind to it's mass-storage
+ * interface as an interface driver */
+UNUSUAL_DEV( 0x0af0, 0x7501, 0x0000, 0x0000,
+		"Option",
+		"GI 0431 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
 #ifdef CONFIG_USB_STORAGE_ISD200
 UNUSUAL_DEV(  0x0bf6, 0xa001, 0x0100, 0x0110,
 		"ATI",


