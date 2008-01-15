Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYAOUkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYAOUkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYAOUkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:40:08 -0500
Received: from serv.smile.org.ua ([193.178.237.153]:4350 "EHLO
	serv.smile.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYAOUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:40:06 -0500
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 15:40:06 EST
Date: Tue, 15 Jan 2008 22:17:23 +0200
From: Andy Shevchenko <andy@smile.org.ua>
To: linux-kernel@vger.kernel.org
Cc: Matthias Urlichs <smurf@smurf.noris.de>
Subject: [PATCH] yet another Dell wireless CDMA/EVDO modem
Message-ID: <20080115201723.GF2097@serv.smile.org.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
X-Operating-System: Linux 2.4.21-50.EL.aspsmp i586
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Here the patch to add native support of the Dell wireless CDMA/EVDO modem.

# modprobe usbserial vendor=0x413c product=0x8129

Following seesion lines describe modem itself
at
OK
ati3
Manufacturer: NOVATEL WIRELESS INCORPORATED
Model: EXPEDITE ET620
Revision: M6500C-BBIRD_TLS_MINI_DELL-Q40306.166 [Aug 25 2006 14:00:00]
ESN: 0x5B39071D
+GCAP: +CIS707-A, CIS-856, +MS, +ES, +DS, +FCLASS

OK

Signed-off-by: Andy Shevchenko <andy@smile.org.ua>

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a18659e..9290b22 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -178,6 +178,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8117) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO ExpressCard == Novatel Merlin XV620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8118) },	/* Dell Wireless 5510 Mobile Broadband HSDPA ExpressCard == Novatel Merlin XU870 HSDPA/3G */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8128) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite E720 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, 0x8129) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite ET620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8137) },	/* Dell Wireless HSDPA 5520 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },


-- 
With best regards,
Andy Shevchenko.      mailto: andy@smile.org.ua


