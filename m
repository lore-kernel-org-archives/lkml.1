Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYIKH4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYIKH4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYIKH4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:56:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYIKH4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:56:40 -0400
Date: Thu, 11 Sep 2008 09:56:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] pci: fix merging left out for BAR print out v2
Message-ID: <20080911075623.GA5500@elte.hu>
References: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com> <200809101048.57119.jbarnes@virtuousgeek.org> <20080910180821.GA6864@elte.hu> <200809101123.46618.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101123.46618.jbarnes@virtuousgeek.org>
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

> On Wednesday, September 10, 2008 11:08 am Ingo Molnar wrote:
> > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > On Wednesday, September 10, 2008 1:44 am Ingo Molnar wrote:
> > > > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > > > print out for Device BAR address before kernel try to update them.
> > > > >
> > > > > also change it to KERN_DEBUG instead...
> > > > >
> > > > > v2: update to linux-pci next
> > > > >    also add (unsigned long long) cast
> > > > >
> > > > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > > >
> > > > Jesse, if you want to pick it up, could we please do this via git
> > > > methods (git-pull and stuff)? The commit below is the one in -tip -
> > > > should i separate it out?
> > >
> > > Sure, though I'm not sure why I shouldn't just be applying this stuff
> > > to my tree first... Seems weird to pull from you only to then ask
> > > Linus to pull.
> >
> > sure - it's just that it all happened weeks ago so it's intermixed. As
> > long as you dont mind the duplicate commit (git will sort it out fine)
> > we can apply it to both trees.
> 
> Ah I see, sure I can pull your bits.  /me gets out his breadcrumbs in 
> preparation for entering the x86 forest.  Does your -tip just contain 
> stuff you're sending to Linus for 2.6.27?

no, the .27 buckets of -tip are almost completely emptied - we are in 
the final stages of .27 stabilization. -tip includes all the v2.6.28 
bits. (which this patch would be too IMHO)

anyway, there's no big issue here i think, upstream -git is fine i 
think, please apply the patch to your tree (it only changes printouts), 
it should not cause any big conflicts.

	Ingo
