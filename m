Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbYGPOFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbYGPOFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbYGPOFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:05:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbYGPOFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:05:20 -0400
Date: Wed, 16 Jul 2008 16:05:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
Message-ID: <20080716140502.GA22631@elte.hu>
References: <20080714135034.GA7013@elte.hu> <200807161552.53427.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807161552.53427.bzolnier@gmail.com>
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

* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> Hi,
> 
> On Monday 14 July 2008, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest x86 git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/for-linus
> > 
> > this is our first merge window since we migrated over to a pure Git 
> > based patch management setup and integrated x86.git into the -tip tree. 
> > Going from Quilt to Git was quite hard for this 
> > 1000-patches-per-kernel-cycle tree, so please bear with us :-)
> 
> I see that fix patches are no longer folded into the guilty patch
> and it makes me a bit worried about kernel bisectability (on which
> many people depend on for hunting regressions)...
> 
> Random example (amongst many others) of what I mean:
> 
> [...]
> 
> >       x86: introduce max_low_pfn_mapped for 64-bit
> >       x86: max_low_pfn_mapped fix, #1
> >       x86: max_low_pfn_mapped fix, #2
> >       x86: max_low_pfn_mapped fix, #3
> 
> There is also a _ton_ of build fixes which could have been easily 
> folded into guilty patches.

actually, while there are indeed other examples where merging fixes 
would have made sense, those 3 above are conceptually different so we 
wanted to have them separate intentionally.

> Could you please consider adding this additional step into your 
> development process before push to Linus?

yeah, we definitely try to do that but -tip is released daily so the 
window to squash patches is small in an append-only setup. There were 2 
days between those fixes above so even if we wanted we couldnt squash 
them. The purpose of finegrained fixes is to observe the effects of the 
fixes. (sometimes the fix is worse than the bug it purports to fix)

Anyway, i think you'll see less of these in the next merge window.

	Ingo
