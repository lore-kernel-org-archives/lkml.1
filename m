Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXFOREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXFOREt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXFOREj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:04:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbXFOREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:04:38 -0400
Date: Fri, 15 Jun 2007 10:03:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Gerdau <mgd@technosis.de>
cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <200706150825.15491.mgd@technosis.de>
Message-ID: <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <orabv29qtk.fsf@oliva.athome.lsd.ic.unicamp.br> <200706142049.41819.dhazelton@enter.net>
 <200706150825.15491.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Michael Gerdau wrote:
> 
> I find it obvious that the GPL was meant to prevent such to be possible.
> This is what I mean by the "the spirit of the GPL".

Umm. It may well have been meant by *rms*. But your argument fatally falls 
down on the fact that rms has had *nothing* to do with the Linux kernel.

> Living in germany I'm also used to the courts valueing the intention over
> the exact wording of a contract (a licence after all is a contract). So
> I _think_ in germany TiVo would have lost a lawsuit if they had tried it.

Ehh. The intent that matters is not the intent of the person who authored 
the license, but the intent of the person who *chose* the license.

In other words, rms has *no* input on the kernel.

What matters is *my* intent in *choosing* the GPLv2, not *his* intent in 
writing it. 

But to make it even less relevant: intent really only legally matters when 
the legal issues are unclear.

And they really aren't that unclear here.

> Anyway, if one considers Tivoisation acceptable then there is no reason
> to stop using GPLv2.

Indeed.

> If one wishes to prevent it there are two related questions:
> - does GPLv2 prevent it ?
> - if GPLv2 does not prevent it then how can we change it to achieve that ?

Well, I think it's fairly unquestionable that the GPLv3 does prevent it. 

So your second question isn't even really interesting. We know the answer. 
So the only question that is even remotely interesting is the first one.

> To me it seems as if the FSF tends to answer the first question with 'no'
> and consequently answers the second question with 'GPLv3'.

Yes, I do agree with that reasoning, but there are *other*, and more 
direct, reasons than just the FSF's answer to say that the answer to your 
first question is "no".

The fact is, plain reading of the license (which *always* takes precedence 
over "intent", even in Europe) simply doesn't make what Tivo did illegal.

You literally have to read the GPLv2 in ways that are obviously not true 
to get to any other situation.

For example, Alexandre made the same two mistakes over and over in his 
reading when he tried to argue that the GPLv2 disallows what Tivo did:

 (a) The right to modify means "modify in place"

     This was a point that Alexandre (and others) have tried to make, but 
     it really is *not* supported by any reality.

     First off, the GPLv2 simply never *ever* says "in place". That
     wording (or anything equivalent) simply does not exist! So you really 
     have to add it by "reading" it some special way, and quite frankly, 
     no such reading is sensible.

     I can logically *prove* that such a reading is not sensible by the 
     two examples I already made clear to Alexandre multiple times:

	- Red Hat sends out DVD's with GPL'd software, and thus 
	  distributes copies that CANNOT be "modified in place". So 
	  thinking that "modified in place" is made illegal by the GPLv2 
	  is simply untenable, unless you think that what Red Hat does is 
	  against the GPLv2.

	  Do you really believe that what Red Hat does is against the GPL? 
	  Does Alexandre? Judging by his email address, I don't think he 
	  does.

	- I myself distribute Linux by making it available for download 
	  publicly, and no, I do *not* allow people to modify it in place, 
	  even though I do distribute Linux.

	  Alexandre tried to argue against this point by saying that I'm 
	  not really "distributing" Linux, and that the actual copying is 
	  being done by people who download it, and that they *can* modify 
	  their downloads "in place", but that only shows a lack of 
	  knowledge about what "distribution" means in copyright law.

	  The US courts have made it very clear that you "distribute" 
	  things not by downloading them, but by making them *available* 
	  for public download. So from a purely *legal* standpoint, I do 
	  actually *distribute* Linux by making it available! And no, I 
	  don't allow people to modify it in place!

	  Again, do you *really* think that I am in violation of the GPL 
	  by making the kernel available for download (== distributing 
	  it), but not letting others modify it in place?

So clearly, the whole "modify in place" argument is simply *wrong*.

It cannot *possibly* be a valid reading of the GPLv2! When the GPLv2 talks 
about "legal permissions to copy, distribute and/or modify" the software, 
it does *not* mean that you have to have the ability to modify it in 
place!

The other argument Alexandre made was different, but equally invalid from 
a legal standpoint:

 (b) The language in the preamble: "must give the recipients all the 
     rights that you have" means really *all* the rights and abilities!

     This too is a totally flawed reading of the license, for a few 
     reasons:

	- It's not actually in the *conditions* section. It's part of the 
	  explanation of the conditions, and while it's part of the 
	  license, it actually *is* different in the sense that it's not 
	  even meant to specify the "precise terms and conditions". Those 
	  are explicitly laid out _elsewhere_ (look for that term: 
	  "precise terms and conditions").

	- However, I don't dispute that the language exists, I just 
	  dispute Alexandres _reading_ of it, and I offer an alternate 
	  meaning for it. I do not guarantee that *my* reading is the 
	  correct one (although practically speaking, I pretty much can 
	  guarantee that too), but I *do* guarantee that Alexandre's 
	  reading is wrong, because it is nonsensical and impossible.

	  It is nonsensical and impossible in the exact same way I
	  showed that he was trying to claim something nonsensical 
	  and impossible in adding the "in place" reading to "right to 
	  modify".

	- So the reason I want to mention the fact that it is in the 
	  "preamble" is exactly because the preamble is *not* meant to be 
	  the "exact terms and conditions", it's meant to be a much softer 
	  thing - something that _explains_ the exact terms and 
	  conditions.

	  In particular, in this case, it explains "Section 6" (and 
	  you could also say that it explains section 7 too, but the 
	  preamble actually talks about patents separately, so you should 
	  probably see "section 6" as just the most obvious example of 
	  what the preamble is talking about).

	- In other words, the preamble is just a preliminary and inexact 
	  explanation for the _real_ requirements, which are spelled out 
	  elsewhere, in places like section 6 of the license. And *that* 
	  section actually makes it clear that "all rights" only concerns 
	  the rights SPELLED OUT IN THE LICENSE ITSELF.

	  Section 6 explicitly says:

		"You may not impose any further restrictions on the 
		 recipients' exercise of the rights granted herein."

	  and that is what I claim is the *correct* and exact reading of 
	  the explanatory language in the preamble. Yes, it is "all 
	  rights", but it is "all rights" ONLY AS FAR AS THE GPLv2 itself 
	  is concerned! It's not about any _other_ additional rights you 
	  may have outside the GPLv2!

	- To finish that point, let me just point out that Alexandre's 
	  reading *cannot* possibly work!

	  In particular, reading the preamble to mean that you give the 
	  recipient *all* rights you have (even outside the actual 
	  requirements of the license itself) that Alexandre tried to 
	  argue, is actually legally simply impossible. The copyright 
	  owner *fundamentally* has more rights than any licensee, and no 
	  license can *ever* transfer all those legal rights!

	  In other words, Alexandre's reading of the preamble is simply 
	  not legally tenable, because it assumes that the license says 
	  something that simply is not legally possible. And obviously the 
	  license doesn't say anything like that at all: it's a legal 
	  document, it can only state legally valid things!

	  I'll use the *exact* same examples as previously to show how 
	  Alexandre's reading of "all the rights that you have" can not 
	  possibly be correct:

	  (a) Again, Red Hat makes DVD's that contain GPLv2'd programs on 
	      them. Red Hat is bound by the GPL, so each work they put 
	      on the DVD is always under the GPL, and Red Hat *must* give 
	      you the rights that the GPL specifies.

	      But does Red Hat actually give you *all* the rights they 
	      hold on the DVD? No, they definitely do not. They hold a 
	      compilation copyright on RHEL, and they very  much do *not* 
	      give you the right to copy the whole distribution and sell 
	      it as RHEL. You only get the rights to the individual 
	      pieces, not to the whole thing!

	  (b) Again, I make the Linux kernel available to you on a web 
	      site, and thus distribute it to you. Do I actually give you 
	      *all* the rights I have in it? Hell no. I cannot (and do 
	      not even want to). As an author, I have special rights in my 
	      code that you do not get. You get the rights spelled out in 
	      the GPLv2, and *nothing* more.

     In other words, Alexandre's reading of the text in the preamble is 
     *impossible*. It absolutely *cannot* be the way the license works. 
     It's not how Red Hat itself reads it, and it's not how it can even 
     legally be made to work even if somebody *wanted* to read it that 
     way.

See? Both of Alexandre's arguments about why Tivo did something "against 
the license" were actually totally bogus. Neither of them was relevant, 
they both hinged on Alexandre reading the GPLv2 *wrong*.

> Whether or not the GPLv3 is truely an acceptable answer to prevent
> Tivoisation is a completely different issue that I can't really judge.

Absolutely. I do think it prevents Tivoisation, but I personally think 
it's unacceptable in even *trying* to prevent it, and as I've tried to 
make clear, the GPLv2 definitely did *not* prevent Tivo from doing what 
they did.

			Linus
