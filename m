Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYJTIw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYJTIw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYJTIwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:52:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYJTIws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:52:48 -0400
Date: Mon, 20 Oct 2008 10:52:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
Message-ID: <20081020085217.GF798@elte.hu>
References: <1224343843.6770.1378.camel@macbook.infradead.org> <20081019111203.GB29705@8bytes.org> <1224415198.6770.1464.camel@macbook.infradead.org> <20081019211449.GG21841@8bytes.org> <1224488605.6770.1522.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224488605.6770.1522.camel@macbook.infradead.org>
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

> On Sun, 2008-10-19 at 23:14 +0200, Joerg Roedel wrote:
> > This is a reason for a seperate Intel IOMMU tree which is pulled by
> > Linus. But I don't think that this is a reason to take over control of
> > all IOMMU development.
> 
> I have no intention of taking over control of anything, if I can 
> possibly avoid it. The _less_ patch-monkey work I have to do, the 
> happier I'll be. There's more to life than Jon's patch statistics.
> 
> I'm perfectly happy for Ingo to pull my tree into his, as I keep 
> saying. As long as it gets into linux-next, that's fine.
> 
> When I discussed it with Thomas a few weeks ago, he seemed to be 
> suggesting that creating a new tree was the best thing to do, but I'm 
> more than happy to adapt.

Creating a new Git tree is a good thing to do in any case - as i 
expressed it to you earlier as well, repeatedly. I told it you a month 
ago and later as well. Here's that portion of my mail to you from Sept 
22:

| > I'm also planning to create a separate git tree for iommu work, 
| > where we can all have direct access. It doesn't really live in the 
| > x86 tree.
|
| the separate git tree is sure useful for the Intel IOMMU bits.
|
| Note that this all affects the x86 tree very significantly so please 
| send pull requests to us like Joerg does it for the AMD-IOMMU bits and 
| then we'll integrate and send it upstream from there.

A number of non-x86 and x86 contributors to various tip/* topics do that 
already and it's a great help to be able to pull Git trees, as it scales 
the maintenance overhead.

We already do it for tip/sched/* topics and tip/tracing/* topics 
-neither of which has anything to do with the x86 trees, and all of 
these feed into linux-next independently of any x86 bits. We'd obviously 
pull from you and send it towards Linus. (Long term we want to 
eventually reach the kind of sub-maintainer setup that DaveM does so 
well with the networking tree.)

There's tip/core/iommu for generic / non-x86 bits - should any such bits 
show up. And out of caution, despite all IOMMU work being currently 
centered around x86, we've got a separate tip/auto-iommu-next as well, 
integrated into linux-next independently of the x86 tree.

What was not fine for you was to declare tip/auto-iommu-next the 'old' 
tree and to request a zapping of linux-next's auto-iommu-next 
integration, unilaterally.

If all IOMMU developers and Andrew/Linus want that to happen and want 
you to maintain it all then sure i have no objections - but based on the 
history of this code there will be ongoing integration trouble as 90% of 
the current IOMMU activities are centered around x86 and is actually 
done by x86 developers, for obvious reasons. linux-next needs another 
source of integration trouble like a sore tooth.

	Ingo
