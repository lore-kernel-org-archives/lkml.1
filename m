Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbYJSR1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbYJSR1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYJSR1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:27:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYJSR1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:27:23 -0400
Date: Sun, 19 Oct 2008 19:26:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
Message-ID: <20081019172651.GA19265@elte.hu>
References: <1224343843.6770.1378.camel@macbook.infradead.org> <20081019111203.GB29705@8bytes.org> <1224415198.6770.1464.camel@macbook.infradead.org> <20081019124732.GA21115@elte.hu> <1224422474.6770.1475.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224422474.6770.1475.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Sun, 2008-10-19 at 14:47 +0200, Ingo Molnar wrote:
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Sun, 2008-10-19 at 13:12 +0200, Joerg Roedel wrote:
> > > > On Sat, Oct 18, 2008 at 04:30:43PM +0100, David Woodhouse wrote:
> > > > > As previously threatened, I've created an iommu-2.6.git tree:
> > > > > 	git://git.infradead.org/iommu-2.6.git
> > > > > 	http://git.infradead.org/iommu-2.6.git
> > > > 
> > > > Is there a specific reason why IOMMU stuff should go to Linus 
> > > > without testing them in the x86 tree before? The DMA layer and IOMMU 
> > > > drivers are an integral component of the architecture and patches 
> > > > for it are best placed in the architecture tree instead of a 
> > > > seperate one, imho.
> > > 
> > > This is the purpose that linux-next serves, not the x86 
> > > forest-of-doom.
> > > 
> > > And I thought Ingo said his old iommu tree wasn't in there anyway? 
> > > [...]
> > 
> > That's weird, where did you get the impression from that i "dropped" the 
> > "old" IOMMU tree? It's alive and kicking, all the new IOMMU code that we 
> > queued up and tested in the last cycle for v2.6.28 have just gone 
> > upstream - about 80 commits.
> 
> I cannot find the tree which allegedly already exists [...]

it's tip/auto-iommu-next. "Empty" right now because it just got merged 
upstream last week.

> [...] -- and unless I'm mistaken, a number of patches seem to have 
> fallen through the cracks in the last few weeks. Since I've been asked 
> to start looking after the Intel IOMMU parts, it seemed sensible to 
> make a git tree and round up those patches.

hm, no patches have been lost that i'm aware of - the last ~10 days of 
inbox is not queued up yet because of the merge window - but those 
(except for urgent fixes) are v2.6.29 items anyway.

> I thought you and Thomas were working together, and I spoke to Thomas 
> about it during the Kernel Summit. Unless I'm very much mistaken, he 
> agreed that it makes sense to have a separate, real, git tree for 
> cross-platform IOMMU-related work.
> 
> If you want to pull that tree into yours, that's fine by me -- as long 
> as it gets into linux-next.

okay, we can certainly do that. And if/when all future activities center 
around your tree, and there's no interaction with x86 platform bits, it 
will be natural for you to just not go over any middlemen.

But i'd prefer to at least have some transitionary period - IOMMU 
changes are not easy topics and they caused subtle breakages a couple of 
times and it was quite handy that those breakages were generally seen by 
all x86 developers (and immediately fixed afterwards). 99% of the 
current iommu development activities are in the x86 space, so there's 
quite some alignment there.

	Ingo
