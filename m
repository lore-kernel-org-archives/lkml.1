Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYG2L16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYG2L16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbYG2L1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:27:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbYG2L1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:27:49 -0400
Date: Tue, 29 Jul 2008 13:27:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080729112724.GA11276@elte.hu>
References: <20080725134159.GA7493@amd.com> <20080725225724J.fujita.tomonori@lab.ntt.co.jp> <20080725141425.GB7493@amd.com> <20080725233325W.fujita.tomonori@lab.ntt.co.jp> <20080726134156.GC4401@elte.hu> <20080729110749.728c54e6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729110749.728c54e6.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Sat, 26 Jul 2008 15:41:56 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > ok, i'll apply the 3 patches to tip/x86/iommu. As usual, feel free to 
> > send IOMMU cleanups/generalizations/fixes against tip/master:
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> 
> So, I assume a patch created on July 25 is not destined for 2.6.27, 
> right?  Especially since it breaks another architecture build and has 
> only made it to linux-next on July 29 ... and needs more work given 
> the comments already on this patch.

Correct, they were not intended for immediate upstream merging, they 
werent even in auto-x86-next so there was no meaningful linux-next 
exposure.

I was surprised they went upstream via the PCI tree yesterday, just 
hours after i sent them over to Jesse and about an hour before -rc1 was 
released. [ Nor did intend the core/generic-dma-coherent bits to go 
upstream right before -rc1 - although those seem to be problem-free so 
far. ]

I stopped sending non-urgent patches to Linus days ago, to let things 
calm down for a smooth -rc1 release.

	Ingo
