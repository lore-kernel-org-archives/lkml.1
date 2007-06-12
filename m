Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbXFLPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbXFLPrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbXFLPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:46:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757080AbXFLPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:46:55 -0400
Date: Tue, 12 Jun 2007 08:45:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Tarkan Erimer <tarkan@netone.net.tr>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orsl8xsmwf.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706120818390.14121@woody.linux-foundation.org>
References: <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr>
 <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <466BCBBC.90305@netone.net.tr>
 <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
 <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
 <466C0901.4000405@netone.net.tr> <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706101029300.20321@woody.linux-foundation.org>
 <466D0A12.5030607@netone.net.tr> <20070611090348.GA18894@elte.hu>
 <orsl8xsmwf.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jun 2007, Alexandre Oliva wrote:
> 
> Per this reasoning, Sun wouldn't be waiting for GPLv3, and it would
> have already released the OpenSolaris kernel under GPLv2, would it
> not? ;-)

Umm. You are making the fundamental mistake of thinking that Sun is in 
this to actually further some open-source agenda.

Here's a cynical prediction (but backed up by past behaviour of Sun):

 - first off: they may be talking a lot more than they are or ever will
   be doing. How many announcements about Sun and Linux have you seen over
   the years? And how much of that has actually happened?

 - They may like open source, but Linux _has_ hurt them in the 
   marketplace. A lot.

   They almost used to own the chip design market, and it took quite a 
   long time before the big EDA vendors ported to Linux (and x86-64 in 
   particular). But when they did, their chip design market just basically 
   disappeared: sparc performance is so horribly bad (especially on a 
   workstation kind of setup), that to do chip design on them is just 
   idiotic. Which is not to say that there aren't holdouts, but let's face 
   it, for a lot of things, Solaris is simply the wrong choice these days.

   Ergo: they sure as hell don't want to help Linux. Which is fine. 
   Competition is good.

 - So they want to use Linux resources (_especially_ drivers), but they do 
   *not* want to give anything back (especially ZFS, which seems to be one 
   of their very very few bright spots).

 - Ergo: they'll not be releasing ZFS and the other things that people are 
   drooling about in a way that lets Linux use them on an equal footing. I 
   can pretty much guarantee that. They don't like competition on that 
   level. They'd *much* rather take our drivers and _not_ give anythign 
   back, or give back the stuff that doesn't matter (like core Solaris: 
   who are you kidding - Linux code is _better_).

End result:

 - they'll talk about it. They not only drool after our drivers, they 
   drool after all the _people_ who write drivers. They'd love to get 
   kernel developers from Linux, they see that we have a huge amount of 
   really talented people. So they want to talk things up, and the more 
   "open source" they can position themselves, the better.

 - They may release the uninteresting parts under some fine license. See 
   the OpenSolaris stuff - instead of being blinded by the code they _did_ 
   release under an open source license, ask yourself what they did *not* 
   end up releasing. Ask yourself why the open source parts are not ready 
   to bootstrap a competitive system, or why they are released under 
   licenses that Sun can make sure they control.

So the _last_ thing they want to do is to release the interesting stuff 
under GPLv2 (quite frankly, I think the only really interesting thing they 
have is ZFS, and even there, I suspect we'd be better off talking to 
NetApp, and seeing if they are interested in releasing WAFL for Linux).

Yes, they finally released Java under GPLv2, and they should be commended 
for that. But you should also ask yourself why, and why it took so long. 
Maybe it had something to do with the fact that other Java implementations 
started being more and more relevant?

Am I cynical? Yes. Do I expect people to act in their own interests? Hell 
yes! That's how things are _supposed_ to happen. I'm not at all berating 
Sun, what I'm trying to do here is to wake people up who seem to be living 
in some dream-world where Sun wants to help people. 

So to Sun, a GPLv3-only release would actually let them look good, and 
still keep Linux from taking their interesting parts, and would allow them 
to take at least parts of Linux without giving anything back (ahh, the 
joys of license fragmentation). 

Of course, they know that. And yes, maybe ZFS is worthwhile enough that 
I'm willing to go to the effort of trying to relicense the kernel. But 
quite frankly, I can almost guarantee that Sun won't release ZFS under the 
GPLv3 even if they release other parts. Because if they did, they'd lose 
the patent protection.

And yes, I'm cynical, and yes, I hope I'm wrong. And if I'm wrong, I'll 
very happily retract anything cynical I said about Sun. They _have_ done 
great things, and maybe I'm just too pessimistic about all the history 
I've seen of Sun with open source.

The _good_ news is that Jonathan Schwartz actually does seem to have made 
a difference, and I hope to God he is really as serious about 
open-sourcing things as he says he is. And don't get me wrong: I think a 
truly open-source GPLv3 Solaris would be a really really _good_ thing, 
even if it does end up being a one-way street as far as code is concerned!

			Linus
