Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXK2Ogu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXK2Ogu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbXK2Ogl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:36:41 -0500
Received: from hu-out-0506.google.com ([72.14.214.224]:14070 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbXK2Ogk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=sMxjI2hULsqYlQPFH7qa0lHLDXUDtdKYJf+YazZwlNF3PhK5qQW5xg65gvTp2PEApiwTSZD05ynZmP4T3jhxuhwOpPo2ABfJGPJqierL0nDWsH78YunjUngyohf6s+Tl1LrVZDqCUB4kPf5zeK8pLkOxWjdkqZta87G+SX1Of/s=
Date: Thu, 29 Nov 2007 15:36:30 +0100
To: Johann Wilhelm <johann.wilhelm@student.tugraz.at>
Cc: Oliver Neukum <oliver@neukum.org>, Rui Santos <rsantos@grupopie.com>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       preining@logic.at, kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, jsagarribay@gmail.com
Subject: Re: Add the infamous Huawei E220 to option.c
Message-Id: <20071129153630.d85882ca.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071129150550.86453nubw8i5xi68@webmail.tugraz.at>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<200711291149.46326.oliver@neukum.org>
	<474E9D7E.4040007@grupopie.com>
	<200711291255.08603.oliver@neukum.org>
	<20071129150550.86453nubw8i5xi68@webmail.tugraz.at>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'll give it a go later today, still on 2.6.22.4.

Any logs of interest except for obvious behavior?

On Thu, 29 Nov 2007 15:05:50 +0100
Johann Wilhelm <johann.wilhelm@student.tugraz.at> wrote:

> If everything's working please also add code to also support the other  
> E220 device... so both PID 0x1003 and 0x1004 should be treaded the  
> same way...
> 
> to test the device with the 0x1004-PID maybe Jaime Velasco  
> <jsagarribay@gmail.com> could be asked.. he initialy added the lines  
> for this device in option.c
> 
> 73
> 
> Zitat von Oliver Neukum <oliver@neukum.org>:
> 
> > Am Donnerstag 29 November 2007 schrieb Rui Santos:
> >> >> Just to remember that that specific flag was one SET and, was removed,
> >> >> in part, because of what I state. Of course we aim at perfection but, if
> >> >> the benefits are only for a few situations and, will cause all this
> >> >> problems for all other, perhaps the reinsert of that flag would be a
> >> >> positive action.
> >> >>
> >> >
> >> > OK, can you provide "lsusb -v" for the device in the CD mode and in
> >> > the modem mode?
> >> >
> >> Of course. Heri it is.
> >
> > Thanks. Please try this patch.
> >
> > 	Regards
> > 		Oliver
> >
> > ----
> >
> > --- a/drivers/usb/serial/option.c	2007-11-29 12:35:09.000000000 +0100
> > +++ b/drivers/usb/serial/option.c	2007-11-29 12:47:34.000000000 +0100
> > @@ -158,7 +158,7 @@ static struct usb_device_id option_ids[]
> >  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
> >  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
> >  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
> > -	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
> > +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID,  
> > HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
> >  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS) },
> >  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1100) }, /* Novatel  
> > Merlin XS620/S640 */
> >  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1110) }, /* Novatel  
> > Merlin S620 */
> >
> >
> 
> 
