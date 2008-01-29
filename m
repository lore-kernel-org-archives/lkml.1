Return-Path: <linux-kernel-owner+w=401wt.eu-S1764232AbYA2AGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764232AbYA2AGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbYA2AFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:05:43 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:48119 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbYA2AFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:05:40 -0500
Date: Mon, 28 Jan 2008 19:05:33 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <alpine.LNX.1.00.0801281445200.13593@iabervon.org>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281905.35278.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <479E1D9E.3000900@bobjweil.com>
 <alpine.LNX.1.00.0801281445200.13593@iabervon.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Daniel Barkalow wrote:
>On Mon, 28 Jan 2008, Richard Heck wrote:
>> Daniel Barkalow wrote:
>> > Can you switch back to old IDE to get your work done (and to make sure
>> > it's not a hardware issue that's developed recently)?
>>
>> I think it'd be really, REALLY helpful to a lot of people if you, or
>> someone, could explain in moderate detail how this might be done. I tried
>> doing it myself, but I'm not sufficiently expert at configuring kernels
>> that I was ever able to figure out how to do it.
>
>As far as configuring the kernel, I can help:
>
>Go to Device Drivers, ATA/ATAPI/MFM/RLL support, and turn on anything that
>looks relevant; go to Device Drivers, Serial ATA and Parallel ATA drivers,
>and turn off anything that's PATA and looks relevant.
>
Done.

>(Whether a device uses IDE or PATA depends on which driver that supports
>the device is present and find it first, not on any sort of global
>configuration, which is probably what tripped you up)
>
>Building this and installing it along with the appropriate initrd (which
>might be handled by Fedora's install scripts)

Or mine, which I've been using for years.

>will either get you back to 
>old IDE or will make your kernel panic on boot, depending on whether you
>got it right (so make sure you can still boot the kernel you're sure of or
>something from a boot disk). This will also cause your hard drives to show
>up as different device nodes, so if your boot process doesn't mount by
>disk uuid but by some other feature (and I don't know what Fedora does),
>you'll also need to change it to something either stable across access
>methods or which works for the one you're now using.

It mounts by LABEL=.  All of it.

>> Obviously, the short version is: switch back to Fedora 6. But this kind of
>> problem with libata---and yes, you're almost surely right that it's not
>> one problem but lots---is sufficiently widespread that a Mini HOWTO, say,
>> would be really welcome and, I'm guessing, widely used.
>
>Fedora really ought to provide documentation, because there's some
>distro-specific stuff (like how you deal with the kernel's device node for
>the root partition changing), and they're using code by default that's at
>least somewhat documented as experimental (although it doesn't seem to be
>actually marked as experimental in all cases).

Fedora is not the only people having trouble,  name a distro, its probably 
someplace in that 14,800 hit google returns.

>	-Daniel
>*This .sig left intentionally blank*

Thanks Daniel, try #1 is building now.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Those who do not understand Unix are condemned to reinvent it, poorly.
		-- Henry Spencer
