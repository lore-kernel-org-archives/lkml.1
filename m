Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbXG2Imo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbXG2Imo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 04:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbXG2Imh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 04:42:37 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:4582 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301AbXG2Imf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 04:42:35 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 10:42:32 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Jessup <jonathanjessup@gmail.com>,
       linux-kernel@vger.kernel.org, lkml@metanurb.dk
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com> <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org> (sfid-20070729_101018_641139_13FD323F)
In-Reply-To: <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291042.32745.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 Juli 2007 schrieb Linus Torvalds:

> People are suggesting that you'd have a separate "desktop kernel".
> That's insane. It also shows total ignorance of maintainership, and
> reality. And I bet most of the people there haven't tested _either_
> scheduler, they just like making statements.

Ok, hands up again.

I tested both schedulers. And I know a lot of people from the ck patchset 
mailing list did, despite its narrow ck patchset related topic

> The fact is, I've _always_ considered the desktop to be the most
> important part. And I suspect that that actually is true for most
> kernel developers, because quite frankly, that's what 99% of them ends
> up using. If a kernel developer uses Windows for his day-to-day work, I
> sure as hell wouldn't want to have him developing Linux. That has
> nothing to do with anything anti-windows: but the whole "eat your own
> dogfood" is a very fundamental thing, and somebody who doesn't do that
> shouldn't be allowed to be even _close_ to a compiler!
>
> So the whole argument about how kernel developers think that the
> desktop isn't important is totally made-up crap by Con, and then
> parrotted by osnews and other places.

Ah, well. So where for example is a working, fast and reliable snapshot 
solution despite of one being available for *years*? And no, suspend to 
ram just doesn't cut it - its a complete nonsense for my laptop usage 
pattern.

> And btw, "the desktop" isn't actually one single load. It's in fact a
> lot of very different loads, and different people want different
> things. What makes the desktop so interesting is in fact that it shows
> more varied usage than any other niche - and no, 3D gaming isn't "it".

3D gaming was only *one* workload that people where happy with when 
running SD.

> Con wass fixated on one thing, and one thing only, and wasn't
> interested in anythign else - and attacked people who complained.
> Compare that to Ingo, who saw that what Con's scheduler did was good,
> and tried to solve the problems of people who complained.

One thing? How about

1) various improvements to VM stuff and
2) swap prefetch?
3) pluggable schedulers?

And various other patch sets. 

Con concentrated on Desktop performance thats right, but even there he 
didn't stop. Did you know for example that Con maintained a server 
related ck patchset for years as well?

Where actually is that "Con concrentates only on one thing"?

> The ck mailing list is/was also apparently filled with people who all
> had the same issues, which is seriously the *wrong* thing to do. 

Just one question: Did you actually look there *before* making above 
statement? Can you give a honest answer to this question?

> So if you are going to have issues with the scheduler, which one do you
> pick: the one where the maintainer has shown that he can maintain
> schedulers for years, can can address problems from _different_ areas
> of life? Or the one where the maintainer argues against people who
> report problems, and is fixated on one single load?

Do you have any concrete example? I have only one, one out of countless 
responses of Con to people how reported problems: The X11 renice issue.

If I requested from Ingo to make a scheduler exception that contradicts 
the design of CFS and I could not convince Ingo that this exception 
really does make sense, I think I will get into a discussion with Ingo - 
and exactly that makes perfect sense to me! Actually Ingo did have 
renicing for X and kernel threads in CFS for quite a while as well.

Still that said, I admit that the tone may well have played a role here - 
as it does in this discussion as well. Maybe Con reacted hurt where no 
offence was meant at times. But we are all humans, and given all the 
unfriendlyness Con apparently faced I can understand this. "survival of 
the fittest maintainer"? Maybe. But I invite you to listen on the last 
results in biological reasons: Darwins "survival of the fitttest" is only 
one principle and doesn't explain how lifing beings put themselves 
together at all. Biologist find out more and more than the genome is no 
command central at all, but being used by living beings in the way their 
complex parts being interacting with one another see fit.

One should take the tone in this discussion into account. Cause now one 
can argue that Con doesn't want to maintain the SD scheduler. Well thats 
true, but once he was more than willing to do that and IMHO he reacted to 
at least most problem reports in a very professional manner. Maybe not to 
100% of them, but can you actually say that from Ingo? From what I seen 
Ingo also is a human...

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
