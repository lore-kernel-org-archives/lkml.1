Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXFOPWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXFOPWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXFOPWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:22:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbXFOPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:22:41 -0400
Date: Fri, 15 Jun 2007 08:21:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Alexandre Oliva <aoliva@redhat.com>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070615124211.GA11830@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706150748180.14121@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org>
 <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141311330.14121@woody.linux-foundation.org>
 <orir9q9rgl.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141424160.14121@woody.linux-foundation.org>
 <orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141545470.14121@woody.linux-foundation.org>
 <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br> <87r6oeytin.fsf@jbms.ath.cx>
 <orsl8u54pa.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070615124211.GA11830@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Carlo Wood wrote:
> 
> Therefore, it seems pretty weird to me that LONG before version 3
> was written and released, someone purposely would choose to freeze
> their software at version 2. Why make it "impossible" to use this
> safe-guard?

Because what you call "safe-guard" is just call "idiotic".

The fact is, anybody who cares about the copyright license he uses on 
software (and I sure do care!) should *never* give a blank check to 
somebody else that they don't trust to change that license for them.

In other words, the whole "v2 or later" language *only* makes sense if:

 - You are the FSF, and you *decide* what "or later" actually means

   In this case, you obviously don't have to trust "somebody else". You 
   just trust yourself.

 - You don't care about your choice of license.

   In this case, you might as well let somebody else make that decision 
   for you, although quite frankly, you might as well use something like 
   the BSD license and let many *more* people make that decision to 
   relicense for you.

 - ..or you trust the FSF implicitly.

   In this case, you're not an independent entity, you're just a lackey of 
   the FSF when it comes to the license.

If none of those conditions are true, you'd be *incompetent* to leave the 
"v2 or later".

And I'm not incompetent.  None of the above conditions holds true for me, 
so the "v2 or later" would be totally idiotic. Which is why Linux has 
*never* had that statement for *any* code I have ever written!

So the fact that *you* (and the FSF) call it a "safe-guard" by no means 
makes it so.

> I never knew it was possible to change the "version 2 or higher" into
> "only version 2", but I am not a laywer and not into licenses at all,
> and I am sure Linus had laywers look into this, so we can take this
> as a fact.

What you state above is that you didn't even *READ* the GPL, yet you make 
some arguments about it as if you had!

So let me educate you. You may not want to be educated, but I'll try 
anyway:

 - Please *read* the license that you discuss. If you don't read it, 
   there's no point in you making any arguments about it.

   And by reading it, I don't mean just mechanical "reading" in a 
   technical sense. I mean "read and think about it"

 - Once you have actually read it, you'll notice that there *is* no 
   "either version 2 of the License, or (at your option) any later 
   version" in the GPL v2 license AT ALL.

   Really. That phrase DOES NOT EXIST in the GPLv2. 

 - That phrase exists *outside* the license, in the *suggestion* of how 
   you migth want to use it! Notice how that license comes *after* the 
   "END OF TERMS AND CONDITIONS" thing, and in the section that describes 
   how you might *use* the license.

In other words, you are a perfect example of somebody who argues about the 
GPLv2 without ever having read or understood it!

I'm really tired of people claiming that the kernel license is a 
"modified" GPLv2 to remove the "v2 or later" language. It's *not* modified 
at all: that language simply DOES NOT EXIST in the GPLv2. It exists 
outside the license, in a suggestion on how you _might_ use it, and it's a 
suggestion that my code has *never* *ever* actually followed.

>From the very first version of Linux that used the GPLv2 (that would be 
Linux-0.95, iirc), Linux has *always* been under a unmodified GPLv2. Not 
"any later". Not "modified".  It has *always* stated the version 
explicitly (by *including* it verbatim - there was certainly never any 
ambiguity about versions), and it has *never* stated "v2 or later" in any 
source code I wrote!

Yes, afterwards, I have added clarifications, because it turns out that 
lawyers (and non-lawyers, for that matter) actually prefer having certain 
things clarified and written out, so that nobody can later claim that they 
misunderstood certain things.

But even those clarifications NEVER MODIFIED THE ACTUAL LICENSE. They are 
literally just clarifications. The license didn't change.

The clarifications are

 - the obvious *fact* that user-mode code using standard system calls is 
   not a derived work of the kernel.

   This is so obvious to anybody with any knowledge of what "derived work" 
   means that there is absolutely no legal question about this being a 
   fact, but the FSF had made such a name for the GPL being "viral" that 
   some people were still worried that I was crazy and would sue. They 
   probably weren't actually worried that they'd lose, but a lawsuit is 
   potentially quite damaging (to PR and in just legal expenses) even if 
   you do end winning, so to make it clear that I wasn't crazy, I added a 
   clarification about this very early on.

   Side note: while it's just a clarification, and as such doesn't 
   actually alter the license in *any* way, it's *also* a "public 
   statement of intent", and as such has legal meaning: it means that if I 
   were to stop taking my meds and go crazy, I *still* couldn't sue, 
   because of the so-called "doctrine of lathes" (and probably other 
   legal issues), since I have made it clear that you cannot be *expected* 
   to be sued over it.

   So please do realize that while a clarification does not change the 
   license in any way, shape, or form, it does actually have some real 
   legal implications as to whether you can effectively sue somebody. You 
   cannot first claim that certain uses are ok, and then suddenly change 
   your mind when people have made decisions based on your claim.

 - the above *fact* that the source code never followed the FSF suggestion 
   of "v2 or later" was clarified and made explicit.

   Again, this in no way changed the license itself (that "v2 or later" 
   language simply _does_not_exist_ in the GPLv2), but it *also* didn't 
   actually change the licensing of the code itself. Because the whole "v2 
   or later" language (in the "how to use") only takes effect 
   *if*it*exists* in the source code, and the whole "any version of your 
   choice" language (which *does* exist in the GPLv2) only takes effect if 
   there wasn't some explicit license version that was obvious (and 
   dammit, it doesn't get much more obvious than a COPYING file that 
   includes the whole license *verbatim*)

So I am 100% sure that the whole Linux kernel is "v2 only". It has 
*always* been "v2 only" since very early in 1992, and before that, it 
wasn't GPL'd at all.

Certain individual *parts* of the kernel can be used under other licenses 
(BSD, Mozilla, and yes, GPLv3+), but that is very much a localized issue, 
and does not in any way change the fact that the Linux kernel itself in 
its entirety is GPL version *2*. And nothing else.

And I'm also 100% sure that anybody who claims otherwise is totally 
ignorant of either copyright law, the GPLv2, or *both*.

				Linus
