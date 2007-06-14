Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbXFNDKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbXFNDKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 23:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbXFNDKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 23:10:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbXFNDKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 23:10:06 -0400
Date: Wed, 13 Jun 2007 20:09:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070614004419.GL3588@stusta.de>
Message-ID: <alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>
 <alpine.LFD.0.98.0706131456230.14121@woody.linux-foundation.org>
 <orejkfla3l.fsf@oliva.athome.lsd.ic.unicamp.br> <200706131946.15714.dhazelton@enter.net>
 <20070614004419.GL3588@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Adrian Bunk wrote:
> 
> "For an executable work, complete source code means all the source code 
> for all modules it contains, plus any associated interface definition 
> files, plus the scripts used to control compilation and installation of 
> the executable."
> 
> The question is whether this includes private keys.

No. That's the question as the FSF would like to frame it.

But the real fact is that it *not* the right question.

You can install Linux on a Tivo all you like. Take out the harddisk, 
install your own version of Linux on it, and put it back in. That's pretty 
much how Tivo installs Linux on the things too, afaik, although they don't 
need to take the disk out (since they just assemble it).

No magic needed. In fact, no keys needed.

Now, maybe the hardware/firmware knows to expect a certain SHA1 on that 
disk, that's a different issue. Tivo could even tell you exactly what the 
SHA1 they are checking is. Maybe they have a list of SHA1's, and maybe 
they have a way to upgrade THEIR OWN FIRMWARE with new SHA1's, and they 
could still tell you all of them, and be very open.

And you could actually replace their copy of Linux with another one. It 
would have to have the same SHA1 to actually start _running_, but that's 
the hardware's choice. 

See? No private keys needed. No magic install scripts. It really _is_ that 
easy.

Of course, using private keys, and signing the image with them is possibly 
a technically more flexible/easier/more obvious way to do it, but in the 
end, do you really want to argue technical details?

But I think the whole thing is totally misguided, because the fact is, the 
GPLv2 doesn't talk about "in place" or "on the same hardware". 

So take another example: I obviously distribute code that is copyrighted 
by others under the GPLv2. Do I follow the GPLv2? I sure as hell do! But 
do I give you the same rights as I have to modify the copy on 
master.kernel.org as I have? I sure as hell DO NOT!

So by the idiotic logic of "modifying in place", I'm violating the GPLv2 
every time I'm makign a release - because I make Linux available, but I 
don't actually give people the "same rights" to that particular copy that 
I have! Oh horrors of horrors! You need to make a _copy_ of the thing I 
distribute, and then you have the same rights I have to that _copy_, but 
you never had the same rights to the thing I actually distributed!

And here's a big clue for people: anybody who thinks that I'm violating 
the GPLv2 by not giving out my private SSH key to master.kernel.org is a 
f*cking moron! You have the right to modify *copies* of the kernel I 
distribute, but you cannot actually modify the _actual_ entity that I made 
available!

See any parallels here? Any parallel to a CD-ROM distribution, or a Tivo 
distribution? The rights that the GPLv2 gives to "the software", is to 
something much bigger than "the particular copy of the software". 

Can people really not see the difference between "the software" and "a 
particular encoded copy of the software"? 

I'm sorry, but people who cannot see that difference are just stupid.

			Linus
