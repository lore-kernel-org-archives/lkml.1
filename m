Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbYANRUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbYANRUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYANRUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:20:33 -0500
Received: from mail.sierrawireless.com ([208.81.121.7]:9960 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYANRUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:20:32 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Date: Mon, 14 Jan 2008 09:21:32 -0800
Message-ID: <3415E2A2AB26944B9159CDB22001004D022577B3@nestea.sierrawireless.local>
In-Reply-To: <20080111210234.GA3070@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Thread-Index: AchUlYWNeqrMX5U6Rn+6ktJhLmbbDwCO+UHQ
References: <1199992265.9266.19.camel@linux-z60t> <20080110195403.GA29384@suse.de> <3415E2A2AB26944B9159CDB22001004D022572F5@nestea.sierrawireless.local> <20080111210234.GA3070@suse.de>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 14 Jan 2008 17:21:34.0837 (UTC) FILETIME=[E9A8DA50:01C856D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, no, the intrusion into the driver is just too much this late in
the
> release cycle to allow this.
>
> Now I will be glad to only add the new device ids for the devices that
> do not rely on the new changes right now, but that's it.
>
> So, right now I have a separate patch split out of your original one
> that is below.  Should I modify it and not include some of these
device
> ids right now?  You mention 0023, is that the only one I should remove
> from this patch?

Correct, the 0x0023 is the only newly added device that requires the new
features.
When do you expect the other changes will be propagated to the kernel?
Would it be in a 2.6.24.x point release or will they have to wait until
2.6.25?

Thanks,
 -Kevin

-------------

From: Kevin Lloyd <klloyd@sierrawireless.com>
Subject: USB: sierra driver - add devices

From: Kevin Lloyd <linux@sierrawireless.com>

The following improvements were made:
 - Added new product support: MC5725, AC 880 U, MP 3G (UMTS & CDMA)

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -104,6 +104,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595
*/
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E
*/
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle
595U */
+	{ USB_DEVICE(0x1199, 0x0023) },	/* Sierra Wireless AirCard */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -117,8 +118,12 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881
*/
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E
*/
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E
*/
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U
*/
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U
*/
 
+	{ USB_DEVICE(0x1199, 0x6468) }, /* Sierra Wireless MP3G - EVDO
*/
+	{ USB_DEVICE(0x1199, 0x6469) }, /* Sierra Wireless MP3G -
UMTS/HSPA */
+
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /*
Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /*
Airprime/Sierra PC 5220 */
 
@@ -143,6 +148,7 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595
*/
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E
*/
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle
595U*/
+	{ USB_DEVICE(0x1199, 0x0023) },	/* Sierra Wireless AirCard */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -156,7 +162,10 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881
*/
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880E
*/
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881E
*/
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U
*/
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881U
*/
+	{ USB_DEVICE(0x1199, 0x6468) }, /* Sierra Wireless MP3G - EVDO
*/
+	{ USB_DEVICE(0x1199, 0x6469) }, /* Sierra Wireless MP3G -
UMTS/HSPA */
 	{ }
 };
 

