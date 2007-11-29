Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXK2OHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXK2OHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbXK2OGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:06:51 -0500
Received: from mailrelay.tu-graz.ac.at ([129.27.2.202]:51811 "EHLO
	mailrelay.tugraz.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbXK2OGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:06:49 -0500
X-DKIM: Sendmail DKIM Filter v2.3.2 mailrelay1.tugraz.at lATE5nHC011807
Message-ID: <20071129150550.86453nubw8i5xi68@webmail.tugraz.at>
X-Priority: 3 (Normal)
Date: Thu, 29 Nov 2007 15:05:50 +0100
From: Johann Wilhelm <johann.wilhelm@student.tugraz.at>
To: Oliver Neukum <oliver@neukum.org>
Cc: Rui Santos <rsantos@grupopie.com>, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, jsagarribay@gmail.com
Subject: Re: Add the infamous Huawei E220 to option.c
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<200711291149.46326.oliver@neukum.org> <474E9D7E.4040007@grupopie.com>
	<200711291255.08603.oliver@neukum.org>
In-Reply-To: <200711291255.08603.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2-cvs)
X-Organization: Graz University of Technology
X-Originating-IP: 77.118.231.238
X-Remote-Browser: Mozilla/5.0 (compatible; Konqueror/3.5; Linux)
	KHTML/3.5.7 (like Gecko)
X-Spam-Scanner: SpamAssassin 3.002003 
X-Spam-Score-relay: -3.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If everything's working please also add code to also support the other  
E220 device... so both PID 0x1003 and 0x1004 should be treaded the  
same way...

to test the device with the 0x1004-PID maybe Jaime Velasco  
<jsagarribay@gmail.com> could be asked.. he initialy added the lines  
for this device in option.c

73

Zitat von Oliver Neukum <oliver@neukum.org>:

> Am Donnerstag 29 November 2007 schrieb Rui Santos:
>> >> Just to remember that that specific flag was one SET and, was removed,
>> >> in part, because of what I state. Of course we aim at perfection but, if
>> >> the benefits are only for a few situations and, will cause all this
>> >> problems for all other, perhaps the reinsert of that flag would be a
>> >> positive action.
>> >>
>> >
>> > OK, can you provide "lsusb -v" for the device in the CD mode and in
>> > the modem mode?
>> >
>> Of course. Heri it is.
>
> Thanks. Please try this patch.
>
> 	Regards
> 		Oliver
>
> ----
>
> --- a/drivers/usb/serial/option.c	2007-11-29 12:35:09.000000000 +0100
> +++ b/drivers/usb/serial/option.c	2007-11-29 12:47:34.000000000 +0100
> @@ -158,7 +158,7 @@ static struct usb_device_id option_ids[]
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
> -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID,  
> HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel  
> Merlin XS620/S640 */
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel  
> Merlin S620 */
>
>


