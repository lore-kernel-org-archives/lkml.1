Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbZEGQsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbZEGQsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZEGQs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:48:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:39844 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZEGQsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ugmu+CekeCdR2KzorUUNj13cHDYeJ85VRPC3m0ChghLiPiZboS3NLqJoBHIXFt12mE
         VoUejCpCIjSBMMVIj5qKuOldY7/RREbGkv25SEfordSv1iV7asYycbfaI8U13CIK5Rod
         i758CVdjW4zZA2Ap2pudDQU/QOxKEp1GyKBvg=
MIME-Version: 1.0
In-Reply-To: <20090506213010.GA18387@suse.de>
References: <2e609cef0905060747m281c15e8ybc8e20f9d4993178@mail.gmail.com>
	 <20090506145832.GE3478@suse.de>
	 <2e609cef0905061401n2412c448k755a152917f4b9d6@mail.gmail.com>
	 <20090506213010.GA18387@suse.de>
Date: Fri, 8 May 2009 00:48:23 +0800
Message-ID: <2e609cef0905070948x5bd5dbd0i2dbe7b4fb02c18b7@mail.gmail.com>
Subject: Re: [PATCH] Yet another Conexant Clone to add to cdc-acm.c
From: =?UTF-8?B?WzZdW01lZSBFd11bzrxdICEhISAtLSBYS0ogfHwgbWluZGxlc3MgOkQ=?= 
	<xiaokj@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Oliver Neukum <oliver@neukum.name>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch adds another quirky Conexant USB Modem Clone to usb cdc-acm.c
>>
>> This is to be applied to latest git. (Got off the website...)
>>
>> Signed-off-by: Xiao Kaijian <xiaokj@gmail.com>
>
> Ah, better, but your email client seems to have eaten all of the tabs
> and spit out spaces instead.  Care to read
> Documentation/email_clients.txt and try it again?
>
>> --- a/drivers/usb/class/cdc-acm.c       2009-05-06 22:06:27.556488116 +0800
>> +++ b/drivers/usb/class/cdc-acm.c       2009-05-06 22:12:56.648401202 +0800
>> @@ -1375,6 +1375,13 @@ static struct usb_device_id acm_ids[] = {
>>        { USB_DEVICE(0x0572, 0x1324), /* Conexant USB MODEM RD02-D400 */
>>        .driver_info = NO_UNION_NORMAL, /* has no union descriptor */
>>        },
>> +       { USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
>> +        .driver_info = NO_UNION_NORMAL, /* has no union descriptor.
>> +                                          This is basically a clone of
>> +                                          Conexant USB MODEM RD02-D400.
>> +                                          Seems like NO_UNION_ _IS_ becoming
>> +                                          NORMAL... */
>
> Is the commentary really needed here?  The majority of devices do not
> need this quirk, so i don't think it's really "normal"...
>
> thanks,
>
> greg k-h

Retry attempt 2: terse mode

I sincerely hope this is finally ok. After much testing on gmail, here it is.
I have verified that it is still applicable to git too.
Thank you for your on-going guidance, even over the huge time zone difference.

***********************
For those uninterested in the personal dialogue above, here it is:
***********************

This patch adds another quirky Conexant USB Modem Clone to usb cdc-acm.c

This is to be applied to latest git. (Got off the website...)

Signed-off-by: Xiao Kaijian <xiaokj@gmail.com>

--- a/drivers/usb/class/cdc-acm.c	2009-05-06 22:06:27.556488116 +0800
+++ b/drivers/usb/class/cdc-acm.c	2009-05-06 22:12:56.648401202 +0800
@@ -1375,6 +1375,13 @@ static struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1324), /* Conexant USB MODEM RD02-D400 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
+	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
+	},
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
 	{ USB_DEVICE(0x0572, 0x1329), /* Hummingbird huc56s (Conexant) */
