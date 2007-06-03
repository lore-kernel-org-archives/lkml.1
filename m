Return-Path: <linux-kernel-owner+w=401wt.eu-S1762638AbXFCMoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638AbXFCMoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbXFCMoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:44:17 -0400
Received: from lucidpixels.com ([75.144.35.66]:43796 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbXFCMoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:44:16 -0400
Date: Sun, 3 Jun 2007 08:44:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <Pine.LNX.4.64.0706030837480.3790@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706030843550.3678@p34.internal.lan>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan> 
 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz> 
 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan> 
 <Pine.LNX.4.64.0706031300240.29896@twin.jikos.cz> 
 <Pine.LNX.4.64.0706030716070.3574@p34.internal.lan> 
 <Pine.LNX.4.64.0706031321450.29896@twin.jikos.cz> 
 <Pine.LNX.4.64.0706030749580.3653@p34.internal.lan>
 <3ae72650706030535k26f9d982t382d8fd145c4e966@mail.gmail.com>
 <Pine.LNX.4.64.0706030837480.3790@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Jun 2007, Justin Piszcz wrote:

>
>
> On Sun, 3 Jun 2007, Kay Sievers wrote:
>
>> On 6/3/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>> On Sun, 3 Jun 2007, Jiri Kosina wrote:
>>> 
>>> > On Sun, 3 Jun 2007, Justin Piszcz wrote:
>>> >
>>> >>> Thanks. Does by any chance reverting the commit
>>> >>> 9f8b17e643fe6aa505629658445849397bda4e4f improve the situation?
>>> >> I have not played around with git/etc enough to back it out, if you 
>>> have a
>>> >> patch that applies on top of 2.6.22-rc3 that backs it out I can give it 
>>> a try.
>>> >
>>> > Please try this
>>> 
>>> [[ .. snip .. ]]
>>> 
>>> The patch was successful and now my USB device is working again!
>> 
>> Please set:
>> CONFIG_USB_DEVICE_CLASS=y
>> there should be no patch needed. The option already defaults to yes in
>> the latest kernel.
>> 
>> Thanks,
>> Kay
>> 
>
>  USB device class-devices (DEPRECATED) (USB_DEVICE_CLASS) [N/y/?] (NEW) y
>
> Why is it deprecated if (nut/usb/etc fails) when its not used?  Does nut or 
> udev have to play catch-up to adhere to the new kernel changes?
>
> Compiling with this option and testing now.
>
>
>

With that option enabled, it is successful.

$ upsc belkin@localhost
battery.charge: 100
battery.charge.low: 30
battery.charge.warning: 50
battery.runtime: 210
battery.type: PbAc
battery.voltage: 27.1
battery.voltage.nominal: 24
driver.name: newhidups
driver.parameter.pollfreq: 5
driver.parameter.port: auto
driver.version: 2.0.4
driver.version.data: Belkin HID 0.1
driver.version.internal: 0.28
input.frequency: 59.8
input.frequency.nominal: 60
input.sensitivity: normal
input.transfer.high: 136
input.transfer.high.max: 141
input.transfer.high.min: 131
input.transfer.low: 90
input.transfer.low.max: 95
input.transfer.low.min: 85
input.voltage: 122.0
input.voltage.nominal: 120
output.frequency: 59.8
output.voltage: 121.6
ups.beeper.status: enabled
ups.delay.restart: 0
ups.delay.shutdown: 0
ups.firmware: 4
ups.load: 33
ups.load.high: 100
ups.mfr: Belkin
ups.mfr.date: 2002/03/01
ups.model: UPS
ups.power.nominal: 1200
ups.serial: D2002337105
ups.status: OL CHRG
ups.test.result: No test initiated
ups.type: offline

