Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYHVGpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYHVGpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYHVGow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:44:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbYHVGov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:44:51 -0400
Date: Fri, 22 Aug 2008 08:44:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, jbarnes@virtuousgeek.org, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Message-ID: <20080822064414.GT14110@elte.hu>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com> <20080820094612.GA28492@elte.hu> <20080821231230V.fujita.tomonori@lab.ntt.co.jp> <20080822001238F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822001238F.fujita.tomonori@lab.ntt.co.jp>
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

> > As I wrote in another mail, GART should return zeroed memory 
> > (keeping the current behavior is better). Except for it, the 
> > patchset looks fine.
> 
> I think that you can apply the following patch after Joerg's patchset.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] x86: remove map_simple hook in struct dma_mapping_ops
> 
> pci-dma.c doesn't use map_simple hook any more so we can remove it 
> from struct dma_mapping_ops now.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

applied to tip/x86/iommu - thanks!

i also grepped the full tree and this is indeed the last user of this. 
Nice cleanup.

	Ingo
