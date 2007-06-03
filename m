Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbXFCMk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbXFCMk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbXFCMkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:40:13 -0400
Received: from lucidpixels.com ([75.144.35.66]:33111 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbXFCMkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:40:12 -0400
Date: Sun, 3 Jun 2007 08:40:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <3ae72650706030535k26f9d982t382d8fd145c4e966@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706030837480.3790@p34.internal.lan>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan> 
 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz> 
 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan> 
 <Pine.LNX.4.64.0706031300240.29896@twin.jikos.cz> 
 <Pine.LNX.4.64.0706030716070.3574@p34.internal.lan> 
 <Pine.LNX.4.64.0706031321450.29896@twin.jikos.cz> 
 <Pine.LNX.4.64.0706030749580.3653@p34.internal.lan>
 <3ae72650706030535k26f9d982t382d8fd145c4e966@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Jun 2007, Kay Sievers wrote:

> On 6/3/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> On Sun, 3 Jun 2007, Jiri Kosina wrote:
>> 
>> > On Sun, 3 Jun 2007, Justin Piszcz wrote:
>> >
>> >>> Thanks. Does by any chance reverting the commit
>> >>> 9f8b17e643fe6aa505629658445849397bda4e4f improve the situation?
>> >> I have not played around with git/etc enough to back it out, if you have 
>> a
>> >> patch that applies on top of 2.6.22-rc3 that backs it out I can give it 
>> a try.
>> >
>> > Please try this
>> 
>> [[ .. snip .. ]]
>> 
>> The patch was successful and now my USB device is working again!
>
> Please set:
> CONFIG_USB_DEVICE_CLASS=y
> there should be no patch needed. The option already defaults to yes in
> the latest kernel.
>
> Thanks,
> Kay
>

   USB device class-devices (DEPRECATED) (USB_DEVICE_CLASS) [N/y/?] (NEW) y

Why is it deprecated if (nut/usb/etc fails) when its not used?  Does nut 
or udev have to play catch-up to adhere to the new kernel changes?

Compiling with this option and testing now.


