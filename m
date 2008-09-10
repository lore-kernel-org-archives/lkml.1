Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYIJSIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYIJSIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYIJSIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:08:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57662 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbYIJSIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:08:39 -0400
Date: Wed, 10 Sep 2008 20:08:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] pci: fix merging left out for BAR print out v2
Message-ID: <20080910180821.GA6864@elte.hu>
References: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com> <20080910084450.GJ15255@elte.hu> <200809101048.57119.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101048.57119.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wednesday, September 10, 2008 1:44 am Ingo Molnar wrote:
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > print out for Device BAR address before kernel try to update them.
> > >
> > > also change it to KERN_DEBUG instead...
> > >
> > > v2: update to linux-pci next
> > >    also add (unsigned long long) cast
> > >
> > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> > Jesse, if you want to pick it up, could we please do this via git
> > methods (git-pull and stuff)? The commit below is the one in -tip -
> > should i separate it out?
> 
> Sure, though I'm not sure why I shouldn't just be applying this stuff 
> to my tree first... Seems weird to pull from you only to then ask 
> Linus to pull.

sure - it's just that it all happened weeks ago so it's intermixed. As 
long as you dont mind the duplicate commit (git will sort it out fine) 
we can apply it to both trees.

	Ingo
