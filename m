Return-Path: <linux-kernel-owner+w=401wt.eu-S965791AbXBOKml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965791AbXBOKml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965829AbXBOKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:42:41 -0500
Received: from mail.trixing.net ([87.230.125.58]:55805 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965791AbXBOKmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:42:40 -0500
Message-ID: <45D438F2.2040607@l4x.org>
Date: Thu, 15 Feb 2007 11:41:54 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061220 Thunderbird/1.5.0.9 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: stelian@popies.net, linux-acpi@vger.kernel.org, linux-pm@osdl.org,
       adaplas@pol.net, dawes@xfree86.org,
       Linux kernel <linux-kernel@vger.kernel.org>
References: <45D43489.3060409@l4x.org> <20070215103639.GB27338@elf.ucw.cz>
In-Reply-To: <20070215103639.GB27338@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.37
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [linux-pm] Suspend to RAM, Sony Vaio PCG-SRX51P, lcd stays off
X-SA-Exim-Version: 4.2.1 (built Mon, 27 Mar 2006 14:12:04 +0200)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> I own an older Sony Vaio SRX51P, European Model, P3 based. s2ram
>> identifies it with
>>
>>     sys_vendor   = "Sony Corporation    "
>>     sys_product  = "PCG-SRX51P(DE)      "
>>     sys_version  = "01                  "
>>     bios_version = "R0232U2"
>>
>> Suspend to RAM by using "s2ram -v -m -f" actually works and the
>> laptop comes back to life, is accessible by network, etc. kudos
>> so far.
>> The only but serious problem is, that the lcd stays off after
>> resume. No matter what kind of options for s2ram I try, if I disable
> 
> Is the _lcd_ off or the _backlight_ off? Use bright flashlight to
> tell.

The lcd. If you press the lid button you get the same effect (but you
cannot use it to turn the lcd on again :-(( ). But I'll doublecheck with
a flashlight nevertheless.

>> framebuffer or suspend from X, the lcd always stays off. Only
>> a reboot fixes this. Note that the X driver also cannot dis-/enable
>> the lcd (xset dpms force off). It always stays lit. I also tried
>> with i810switch, but that also does not affect the lcd.
>> spicctrl -b42 neither.
>> Latest kernel I tested is 2.6.20-git11 from today.
>>
>> So has anyone of you suspend, acpi, sonypi, fb people an idea how to fix
>> this? I suspect one has to call some magic ACPI method upon resume? What
>> other kind of information would be needed to debug this? Anything more
>> to try? Are there some sony people here listening who can fix this?
> 
> sonypi people actually might know how to help...
> 
>> 00:02.0 VGA compatible controller: Intel Corporation 82815 CGC
> [Chipset Graphics Controller] (rev 11)
> 
> Wait a moment, did not Intel release nice, commented, GPLed sources
> for their graphics cards somewhere? That might help.

URL? But I suspect the lcd on/off is controlled by some embedded controller
or such (reachable via acpi, at least I've an EC0 in /proc/acpi/).

Jan
