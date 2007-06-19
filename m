Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbXFSRhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbXFSRhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXFSRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:37:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:19811 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbXFSRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JfKsMjXdcKD+wMZ+iSgP1dFmdepURjH3LkKJnOIVweZG0tsmu+9F8eJYoqlKydCWBV08qLBXuOa2PN9LSzO4aExX2/J6SoUCfcTjOnhV6pt7disqdYrzfvVETlRZBq533b9Gvg/rR8VBckfcvKZWAaHW5gvwk6i0RYEFp4F4zeg=
Message-ID: <32209efe0706191037l1f1e6411t8d4af6dbe9b29bc6@mail.gmail.com>
Date: Tue, 19 Jun 2007 10:37:24 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
Cc: "Oleg Verych" <olecom@flower.upol.cz>, "Adrian Bunk" <bunk@stusta.de>,
       "Martin Bligh" <mbligh@mbligh.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0706190949440.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070617220927.99ebc1ee.akpm@linux-foundation.org>
	 <46770A22.4020007@mbligh.org>
	 <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
	 <46771C5D.10809@mbligh.org>
	 <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org>
	 <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de>
	 <alpine.LFD.0.98.0706190732150.3593@woody.linux-foundation.org>
	 <20070619165300.GD19904@flower.upol.cz>
	 <alpine.LFD.0.98.0706190949440.3593@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 19 Jun 2007, Oleg Verych wrote:
> >
> > I'm proposing kind of smart tracking, summarized before. I'm not an
> > idealist, doing manual work. Making tools -- is what i've picked up from
> > one of your mails. Thus hope of having more opinions on that.
>
> Don't get me wrong, I wasn't actually responing to you personally, I was
> actually responding mostly to the tone of this thread.
>
> So I was responding to things like the example from Bartlomiej about
> missed opportunity for taking developer review into account (and btw, I
> think a little public shaming might not be a bad idea - I believe more in
> *social* rules than in *technical* rules), and I'm responding to some of
> the commentary by Adrian and others about "no regressions *ever*".
>
> These are things we can *wish* for. But the fact that we migth wish for
> them doesn't actually mean that they are really good ideas to aim for in
> practice.
>
> Let me put it another way: a few weeks ago there was this big news story
> in the New York Times about how "forgetting" is a very essential part
> about remembering, and people passed this around as if it was a big
> revelation. People think that people with good memories have a "good
> thing".
>
> And personally, I was like "Duh".
>
> Good memory is not about remembering everything. Good memory is about
> forgetting the irrelevant, so that the important stuff stands out and you
> *can* remember it. But the big deal is that yes, you have to forget stuff,
> and that means that you *will* miss details - but you'll hopefully miss
> the stuff you don't care for. The keyword being "hopefully". It works most
> of the time, but we all know we've sometimes been able to forget a detail
> that turned out to be crucial after all.
>
> So the *stupid* response to that is "we should remember everything". It
> misses the point. Yes, we sometimes forget even important details, but
> it's *so* important to forget details, that the fact that our brains
> occasionally forget things we later ended up needing is still *much*
> preferable to trying to remember everything.
>
> The same tends to be true of bug hunting, and regression tracking.
>
> There's a lot of "noise" there. We'll never get perfect, and I'll argue
> that if we don't have a system that tries to actively *remove* noise,
> we'll just be overwhelmed. But that _inevitably_ means that sometimes
> there was actually a signal in the noise that we ended up removing,
> because nobody saw it as anything but noise.
>
> So I think people should concentrate on turning "noise" into "clear
> signal", but at the same time remember that that inevitably is a "lossy"
> transformation, and just accept the fact that it will mean that we
> occasionally make "mistakes".

This is the most crucial point so far in my opinion.
Well, not only people who report bugs are smart - they are curious,
enthusiastic, and passionate about their system, and job, hobby -
whatever linux means to them. They often do own investigations, give
lots of detail, and often others jump in with "me too" and give even
more detail (and more noise) But real detail that would help in bug
assessment is not there, and needs to be requested in lengthy
exchanges (time wise, since every request takes  hours, days,
months...)
I think  would help to make some attempt to lead them on to giving out
what's important. Cold and impersonal upfront fields and drop-down
menus are taking a lot of noise and heat off the actual report.
Another observation - things like "me too" should be encouraged to
become separate reports because generally only maintainer and people
who work directly on the module can sort out if this is same problem,
and in fact real problems get lost and not accounted for when getting
in wrong buckets this way.
--Natalie
>
> This is why I've been advocating bugzilla "forget" stuff, for example. I
> tend to see bugzilla as a place where noise accumulates, rather than a
> place where noise is made into a signal.
>
> Which gets my to the real issue I have: the notion of having a process for
> _tracking_ all the information is actually totally counter-productive, if
> a big part of the process isn't also about throwing noise away.
>
> We don't want to "save" all the crud. I don't want "smart tracking" to
> keep track of everything. I want "smart forgetting", so that we are only
> left with the major signal - the stuff that matters.
>
>                 Linus
>
