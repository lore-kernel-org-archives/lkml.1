Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYH1N5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYH1N5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYH1N51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:57:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46658 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbYH1N50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:57:26 -0400
Date: Thu, 28 Aug 2008 15:56:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: SLUB/debugobjects locking (Re: 2.6.27-rc4-git1: Reported
	regressions from 2.6.26)
Message-ID: <20080828135659.GA1929@elte.hu>
References: <19f34abd0808251244v439e78b1hbb24f77c637559c3@mail.gmail.com> <6278d2220808261514p2661251aw914215652c547125@mail.gmail.com> <19f34abd0808280642j529eab2ct17722644d1550ad9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808280642j529eab2ct17722644d1550ad9@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Wed, Aug 27, 2008 at 12:14 AM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
> > On Mon, Aug 25, 2008 at 8:44 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >> I tried your suggestion of promoting the lock to irq-safe, and it
> >> fixed the warning for me (didn't get or look for deadlocks yet, but it
> >> seems likely that it is caused by the same thing?), the patch is
> >> attached for reference.
> >>
> >> I also don't know if this is the best fix, but I also don't have any
> >> other (better) suggestions.
> >>
> >> Others are welcome to pick it up from here...
> >
> > The solution looks like is needs to get the lock ordering correct
> > w.r.t. SLUB, as we get this, alas:
> >
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.27-rc4-229c-debug #1
> 
> Hm. Is this with my first patch + the one in the e-mail you replied
> to? It was intended to be a delta patch on top of my first one.
> 
> That would be the one in
> 
>     http://marc.info/?l=linux-kernel&m=121946972307110&w=4
> 
> plus the one in
> 
>     http://marc.info/?l=linux-kernel&m=121969394110327&w=1
> 
> Thanks for testing and sorry for the confusion. (Maybe I just confused
> myself. Please let me know either way.)

could you resend the final patch please? It's a candidate for .27, if it 
works out fine.

	Ingo
