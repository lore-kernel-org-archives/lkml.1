Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbYJSMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbYJSMsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 08:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYJSMsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 08:48:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYJSMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 08:48:00 -0400
Date: Sun, 19 Oct 2008 14:47:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
Message-ID: <20081019124732.GA21115@elte.hu>
References: <1224343843.6770.1378.camel@macbook.infradead.org> <20081019111203.GB29705@8bytes.org> <1224415198.6770.1464.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224415198.6770.1464.camel@macbook.infradead.org>
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

> On Sun, 2008-10-19 at 13:12 +0200, Joerg Roedel wrote:
> > On Sat, Oct 18, 2008 at 04:30:43PM +0100, David Woodhouse wrote:
> > > As previously threatened, I've created an iommu-2.6.git tree:
> > > 	git://git.infradead.org/iommu-2.6.git
> > > 	http://git.infradead.org/iommu-2.6.git
> > 
> > Is there a specific reason why IOMMU stuff should go to Linus 
> > without testing them in the x86 tree before? The DMA layer and IOMMU 
> > drivers are an integral component of the architecture and patches 
> > for it are best placed in the architecture tree instead of a 
> > seperate one, imho.
> 
> This is the purpose that linux-next serves, not the x86 
> forest-of-doom.
> 
> And I thought Ingo said his old iommu tree wasn't in there anyway? 
> [...]

That's weird, where did you get the impression from that i "dropped" the 
"old" IOMMU tree? It's alive and kicking, all the new IOMMU code that we 
queued up and tested in the last cycle for v2.6.28 have just gone 
upstream - about 80 commits.

Please do not just jump into other people's workflow like that ... at 
minimum ask them what they'd prefer to do.

Firstly, it's not at all clear to me what your role in this whole matter 
is, because you've not talked to us about it. Does your interest in this 
whole topic come from the fact that you recently got hired by Intel and 
got assigned to maintain Intel's IOMMU bits two months ago?

The thing is, i havent seen a single IOMMU contribution from you in the 
last cycles, so it's weird that you now suddenly attempt to zap other 
people's trees from linux-next out of the blue ... without their 
knowledge and consent.

Your help is welcome, and as i said it before i'd encourage you to run 
your tree - and if Linus wants to pull from you directly that's his and 
Andrew's call.

At the moment IOMMU topics are a rather healthy machinery that clearly 
got new blood and new life in the past two kernel cycles. If you want to 
help out with this stuff then please start by contributing and working 
with people, not by trying to control it.

	Ingo
