Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbYA2BcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbYA2BcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 20:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYA2BcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 20:32:13 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:51173 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYA2BcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 20:32:11 -0500
Date: Mon, 28 Jan 2008 20:31:57 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <alpine.LNX.1.00.0801281909170.13593@iabervon.org>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801282031.58429.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801281905.35278.gene.heskett@gmail.com>
 <alpine.LNX.1.00.0801281909170.13593@iabervon.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Daniel Barkalow wrote:
>On Mon, 28 Jan 2008, Gene Heskett wrote:
>> On Monday 28 January 2008, Daniel Barkalow wrote:
>> >Building this and installing it along with the appropriate initrd (which
>> >might be handled by Fedora's install scripts)
>>
>> Or mine, which I've been using for years.
>
>You're ahead of a surprising number of people, including me, if you
>understand making initrds.

In my script, its one line:
mkinitrd -f initrd-$VER.img $VER && \

where $VER is the shell variable I edit to = the version number, located at 
the top of the script.

Unforch, its failing:
No module pata_amd found for kernel 2.6.24, aborting.

This is with pata_amd turned off and its counterpart under ATA/RLL/etc turned 
on.  So something is still dependent on it.  I do have one sata drive, on an 
accessory card in the box, so I need the rest of the sata_sil and friends 
stuff.  Its my virtual tapes for amanda.  Also home built, the amanda 
security model cannot be successfully bent into the shape of an rpm.  They 
BTW are #2 on coverity's list of most secure software.

So I've rebuilt 2.6.24 as it originally was, and added the acpi timer line to 
the 2.6.24-rc8 stanza's kernel argument list.  It will boot one or the other 
when I next reboot.  Its been about 8 hours since the last error was logged, 
which is totally weirdsville to this old fart.  Phase of the moon maybe?  The 
visit to the sawbones to see about my heart?  They are going to fit me with a 
30 day recorder tomorrow, my skip a beat problem is getting worse.  The sort 
of stuff that goes with the 7nth decade I guess.  Officially, I'm wearing out 
me, too much sugar, too many times nearly electrocuted=shingles yadda 
yadda. :-)  Oh, and don't forget Arther, he moved in uninvited about 25 years 
ago too.  Those people that talk about the golden years?  They're full of 
excrement...

>> >will either get you back to
>> >old IDE or will make your kernel panic on boot, depending on whether you
>> >got it right (so make sure you can still boot the kernel you're sure of
>> > or something from a boot disk). This will also cause your hard drives to
>> > show up as different device nodes, so if your boot process doesn't mount
>> > by disk uuid but by some other feature (and I don't know what Fedora
>> > does), you'll also need to change it to something either stable across
>> > access methods or which works for the one you're now using.
>>
>> It mounts by LABEL=.  All of it.
>
>That'll save a huge amount of hassle. So long as you manage to get the
>right drivers included and the wrong drivers not included, you should be
>pretty much set.
>
>> Fedora is not the only people having trouble,  name a distro, its probably
>> someplace in that 14,800 hit google returns.
>
>Yeah, but they each may need different instructions, particularly if
>they're not mounting by label in general, or not mounting the root
>partition by label. That was the big hassle going the opposite direction.
>And the procedure is 4 lines to describe to somebody who knows how to
>build and install a new kernel for the distro, which is much shorter than
>the explanation of how you generally build and install a kernel. A real
>howto would have to explain where to get the distro's kernel sources and
>default configuration, for example.
>
>	-Daniel
>*This .sig left intentionally blank*



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Never drink from your finger bowl -- it contains only water.
