Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbZK0SLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbZK0SLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZK0SLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:11:17 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:43587 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZK0SLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:11:17 -0500
Message-ID: <4B101639.6010402@hillier.de>
Date: Fri, 27 Nov 2009 19:11:05 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <matthias@urlichs.de>
CC: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick
 to option driver
References: <4B08F18C.3040904@hillier.de>	 <200911220920.16717.oliver@neukum.org> <4B0C1F41.2060101@hillier.de>	 <200911241919.10895.oliver@neukum.org>  <4B0FCAD3.9000801@hillier.de> <1259328254.27675.524.camel@kiste>
In-Reply-To: <1259328254.27675.524.camel@kiste>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Matthias Urlichs schrieb:
> On Fri, 2009-11-27 at 13:49 +0100, Gernot Hillier wrote:
>> +       /* 4G Systems W14 simply ignores this message on interface 0 & 1 
>> +          and would cause long timeouts when calling usb_control_msg()  */
>> +       if (serial->dev->descriptor.idVendor == FOUR_G_SYSTEMS_VENDOR_ID &&
>> +               serial->dev->descriptor.idProduct == FOUR_G_SYSTEMS_PRODUCT_W14 &&
>> +               (ifNum == 0 || ifNum == 1) )
>> +               return -EIO;
>>
> I'd appreciate if you'd implement this generically.
> 
> I.e., use the driver_info field of struct usb_device for an appropriate
> blacklist flag. (It's not going to be the only one.)

Sure. I'll have a look into that ASAP.

Could you do me a favor and apply the first two hunks (i.e. add the 
vendor/device id) in the meantime?

This makes the driver functional in general. And - ehrm, would save me 
some time, because these hunks have to be rebased frequently. ;-)

The 3rd hunk (we're talking about) is just an "optimization" to make 
impatient userspace applications happy...

--
Gernot
