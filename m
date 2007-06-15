Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbXFOBjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbXFOBjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXFOBjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:39:23 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50263 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXFOBjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:39:23 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 21:39:07 -0400
User-Agent: KMail/1.9.6
Cc: Florin Malita <fmalita@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <4671A528.5040300@gmail.com> <or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142139.07720.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 17:39:32 Alexandre Oliva wrote:
<snip>
>
> And since the specific implementation involves creating a derived work
> of the GPLed kernel (the signature, or the signed image, or what have
> you) and refraining from providing the corresponding sources to that
> derived work (the key and the signature "build scripts"), I still
> think this specific case is a violation of the letter of the GPLv2,
> even if the FSF doesn't take this position.

Not entirely correct. If TiVO is making a change to the binary to include the 
signature, then it *could* be considered a derivative work. If the signature 
is stored in another place - say a bit of Flash or a separate file on the 
disc - then there is no way for it to be considered a derivative work. (Under 
US law, IIRC and I I've interpreted it (and the related cases) properly then 
the change would have to be to the source of the program for it to be 
considered a "derivative". But, as you say often and I should make clear 
myself, IANAL) 

>
> > It seems pretty obvious that the only right Tivo is withholding is the
> > right to install new versions on the device
>
> Actually, no.  They withhold the right to run versions that they don't
> authorize themselves.

And this is relevant to a software license in which way? In particular how is 
this relevant to the GPL, which has always *only* guaranteed access to the 
source if you have access to the binary, the right to distribute your own 
versions and the right to modify the code.

Since the "right to run code" was never guaranteed it *cannot* be a violation. 
It might be in conflict with what RMS intended when he wrote the first 
version of the GPL and in conflict with the intent of the people that 
contributed to GPLv2 but that doesn't matter. However, I will not use (or 
recommend) the GPLv3 in its current form because I feel it makes unnecessary 
restrictions. The fact that you have to "allow additional rights" to make it 
equal to the GPLv2 makes a functional (and spiritual) difference to me.

(Why? Because I'm opposed to "In order to protect freedom X we have to 
restrict freedom Y. Its happening in the US *RIGHT* *NOW* and I have been 
doing what I can to fight that. Now the same faulty logic is being applied by 
the FSF with GPLv3)

> Back when GPLv2 was written, the right to run was never considered an
> issue.  It was taken for granted, because copyright didn't control
> that in the US (it does in Brazil), and nobody had thought of
> technical measures to stop people from running modified copies of
> software.  At least nobody involved in GPLv2, AFAIK.

Why isn't it in the US? Because the binary form of a program does not and 
cannot have a separate copyright than the source code. Since it is the 
*SOURCE* that is actually copyright (mechanical translation cannot create a 
new work, only a new form of an already copyrighted work) guaranteeing 
the "right to run" is pointless.

And you are wrong about that "Nobody thought of it" thing - what you mean is 
that "Nobody that had a hand in drafting and ratifying the GPLv2 thought of 
it". The "NSA Guidelines for Trusted Systems" (aka "The Orange Book") talks 
about methods of preventing the execution of code.

What you and the rest of the FSF is doing in response to "tivoization" is 
saying "we don't care if it wasn't designed to do X, we want to be able to 
make it do that anyway *AND* the manufacturer has to help us do it". There is 
no legal way for you to make that demand of a hardware manufacturer. Instead 
you've gone with the only legal recourse - saying "If you want to use my 
copyrighted work under license X, you have to do Y".  I have no problem with 
that, and if the FSF wants that, it's fine by me. But, as I said, I could 
care less where and/or if something I release under the GPL is used. This 
makes the GPLv2 perfect for me.

> The landscape has changed, and GPLv3 is meant to defend this freedom
> that was taken for granted.
>
> > they never do (and really never could) "modify" the physical copy on
> > your device (which is your main argument).
>
> Qualifying it as the main argument is a bit of an exaggeration.  I
> have a number of different arguments.  The one about incomplete
> sources is the most solid IMHO.

Yes, it is. But your argument about the TiVO is "they can modify the copy on 
it but I can't". Hence it is your main argument. And remember, replace != 
modify.

> >> What do you think you do when you save a modified source file in your
> >> editor?
> >
> > Don't skip the part where the in-memory version started as an exact
> > copy of the original being replaced. Notice the difference? ;)
>
> Sorry, I really don't follow.  Both versions of the kernel binary also
> started from a common source ancestor.  Were you trying to make a
> distinction on these grounds?

No. He was making a distinction that I have seen made a number of times. That 
is, a copy of a copyright work in a computers RAM is a *distinct* copy, 
separate from the file on disc it started as. (And that has actually been 
argued in a court case. I don't recall the specifics, but I do recall that 
the argument was held as valid)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
