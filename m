Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYHVGgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYHVGgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYHVGgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:36:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757964AbYHVGge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:36:34 -0400
Date: Fri, 22 Aug 2008 08:36:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: make gart_alloc_coherent return zeroed memory
Message-ID: <20080822063615.GR14110@elte.hu>
References: <20080821225038E.fujita.tomonori@lab.ntt.co.jp> <1219339707-30592-1-git-send-email-joerg.roedel@amd.com> <20080822081517F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822081517F.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 21 Aug 2008 19:28:27 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > The dma_alloc_coherent function should return memory set to zero. This patch
> > adds this to the GART implementation.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> This should be foiled to the first patch in the patchset. No good
> reason to push a patch that might cause a problem.

agreed - i folded the fix back and respun this portion of tip/x86/iommu.

	Ingo
