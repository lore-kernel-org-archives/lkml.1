Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZK0Sxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZK0Sxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZK0Sxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:53:41 -0500
Received: from kroah.org ([198.145.64.141]:34644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZK0Sxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:53:40 -0500
Date: Fri, 27 Nov 2009 10:53:29 -0800
From: Greg KH <greg@kroah.com>
To: Gernot Hillier <gernot@hillier.de>
Cc: Matthias Urlichs <matthias@urlichs.de>, Oliver Neukum <oliver@neukum.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick
	to option driver
Message-ID: <20091127185329.GA14476@kroah.com>
References: <4B08F18C.3040904@hillier.de> <200911220920.16717.oliver@neukum.org> <4B0C1F41.2060101@hillier.de> <200911241919.10895.oliver@neukum.org> <4B0FCAD3.9000801@hillier.de> <1259328254.27675.524.camel@kiste> <4B101639.6010402@hillier.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B101639.6010402@hillier.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 07:11:05PM +0100, Gernot Hillier wrote:
> Hi!
>
> Matthias Urlichs schrieb:
>> On Fri, 2009-11-27 at 13:49 +0100, Gernot Hillier wrote:
>>> +       /* 4G Systems W14 simply ignores this message on interface 0 & 1 
>>> +          and would cause long timeouts when calling usb_control_msg()  
>>> */
>>> +       if (serial->dev->descriptor.idVendor == FOUR_G_SYSTEMS_VENDOR_ID &&
>>> +               serial->dev->descriptor.idProduct == FOUR_G_SYSTEMS_PRODUCT_W14 &&
>>> +               (ifNum == 0 || ifNum == 1) )
>>> +               return -EIO;
>>>
>> I'd appreciate if you'd implement this generically.
>>
>> I.e., use the driver_info field of struct usb_device for an appropriate
>> blacklist flag. (It's not going to be the only one.)
>
> Sure. I'll have a look into that ASAP.
>
> Could you do me a favor and apply the first two hunks (i.e. add the 
> vendor/device id) in the meantime?
>
> This makes the driver functional in general. And - ehrm, would save me some 
> time, because these hunks have to be rebased frequently. ;-)
>
> The 3rd hunk (we're talking about) is just an "optimization" to make 
> impatient userspace applications happy...

Yes, I'll queue that up to make it easier for you to add the later
options.

thanks,

greg k-h
