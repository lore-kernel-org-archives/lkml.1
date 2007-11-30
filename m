Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbXK3TqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbXK3TqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXK3Tpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:45:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbXK3Tpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:45:51 -0500
Date: Fri, 30 Nov 2007 20:45:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops
	on x86_64
Message-ID: <20071130194517.GD9928@elte.hu>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu> <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com> <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com> <20071130183512.GA8985@elte.hu> <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 30 Nov 2007, Ingo Molnar wrote:
> 
> > if you treat testing and review efforts like that they might have to 
> > wait even longer :-( "My stuff is there somewhere amongst 1415 -mm 
> > patches. Thank you for your interest and buzz off already."
> 
> Well I guess you have to get used to maintainership I think. F.e. the 
> s390 people tested this patchset without requiring a backport. 
> Typically arch maintainers test mm and do not force the patches back 
> into mainline.

Huh?? This is getting absurd. Look at it from my perspective: i spent a 
few spare cycles on a Friday afternoon to check a few x86 relevant 
patches that looked interesting to me personally. At the moment they are 
still cooking in -mm and were not submitted to upstream merging yet - so 
i did not expect anything from them, but i wanted to help out because 
the patches looked good.

This was not any "formal" x86 maintainance activity - your patches are 
still cooking. But i was thinking about maybe putting these patches into 
the x86 test grind to get them shaken out some more the random 1000 
bootup tests a day that it does. When integrating your patches I found a 
bug and tentatively reported it to you, pointing out that it could 
easily be my merge fault. Basically i was offering you to let your 
patches cook in another kitchen as well. I never before had a negative 
response to that :-/

So i expected some "great that you are looking at this stuff, lemme help 
you sort it out, you missed these 2-3 patches in -mm" reaction (that's 
how i'd have reacted to you doing the same) instead i got these very 
surprising and fundamentlly hostile responses from you, an unfriendly 
"test -mm and dont pick out individual patches" suggestion and now this 
mail from you with this rather subtly formulated condescending tone:

> Well I guess you have to get used to maintainership I think. [...]

so i guess i'll leave it here for now with your percpu patches, i've got 
far better things to do on a Friday afternoon :-/ We'll deal with your 
stuff once it gets so far as upstream integration.

> I am a bit surprised since Andi and I never had this issue.

huh??? I am really wondering where this hostile attitude of yours comes 
from. Getting patches build and boot is something architecture 
maintainers do on a regular basis, it's a minimum requirement before 
getting something merged into an architecture.

And btw., -rc3-mm2 seems to have grown a spontaneous reboot problem, 
that looks quite similar to what i saw:

  http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/announce.txt

| - First bug report: after ten minutes happily compiling kernels my
|   2.6.24-rc3-mm2 x86_64 box spontaneously rebooted.

so from now on i guess i'll have to tag you as "does not want any 
advance testing and review help with his patches" person and will leave 
you alone.

	Ingo
