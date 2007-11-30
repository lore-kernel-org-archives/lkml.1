Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbXK3U1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbXK3U1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXK3U06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:26:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbXK3U05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:26:57 -0500
Date: Fri, 30 Nov 2007 21:26:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops
	on x86_64
Message-ID: <20071130202622.GA15006@elte.hu>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu> <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com> <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com> <20071130183512.GA8985@elte.hu> <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com> <20071130194517.GD9928@elte.hu> <Pine.LNX.4.64.0711301147100.2242@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711301147100.2242@schroedinger.engr.sgi.com>
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
> > This was not any "formal" x86 maintainance activity - your patches are 
> > still cooking. But i was thinking about maybe putting these patches into 
> > the x86 test grind to get them shaken out some more the random 1000 
> > bootup tests a day that it does. When integrating your patches I found a 
> > bug and tentatively reported it to you, pointing out that it could 
> > easily be my merge fault. Basically i was offering you to let your 
> > patches cook in another kitchen as well. I never before had a negative 
> > response to that :-/
> 
> You could have asked me for a patch against the x86 tree instead of 
> forcing these into your tree. [...]

ugh? What i did was something even better: i merged your patches myself 
(with some caveats, which i pointed out). That's something that people 
consider as a "cool, you just saved me some work!" moment, not a "hey, 
dont you dare forcing MY patches into your tree" incident ;-) At least 
that's how 99.9% of the people on lkml typically see it.

You really need to take a vacation ASAP! =B-)

	Ingo
