Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbXK2Lyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbXK2Lyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXK2Lyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:54:40 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:35836 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbXK2Lyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:54:39 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Rui Santos <rsantos@grupopie.com>
Subject: Re: Add the infamous Huawei E220 to option.c
Date: Thu, 29 Nov 2007 12:55:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
References: <20071128161305.b01167b3.zaitcev@redhat.com> <200711291149.46326.oliver@neukum.org> <474E9D7E.4040007@grupopie.com>
In-Reply-To: <474E9D7E.4040007@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711291255.08603.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 29 November 2007 schrieb Rui Santos:
> >> Just to remember that that specific flag was one SET and, was removed,
> >> in part, because of what I state. Of course we aim at perfection but, if
> >> the benefits are only for a few situations and, will cause all this
> >> problems for all other, perhaps the reinsert of that flag would be a
> >> positive action.
> >>     
> >
> > OK, can you provide "lsusb -v" for the device in the CD mode and in
> > the modem mode?
> >   
> Of course. Heri it is.

Thanks. Please try this patch.

	Regards
		Oliver

----

--- a/drivers/usb/serial/option.c	2007-11-29 12:35:09.000000000 +0100
+++ b/drivers/usb/serial/option.c	2007-11-29 12:47:34.000000000 +0100
@@ -158,7 +158,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel Merlin XS620/S640 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel Merlin S620 */

