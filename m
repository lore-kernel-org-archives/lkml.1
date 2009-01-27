Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZA0Oqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZA0Oqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 09:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZA0OqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 09:46:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZA0OqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:46:22 -0500
Date: Tue, 27 Jan 2009 15:46:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH -tip] IA64: fix the compile error on IA64_DIG_VTD
Message-ID: <20090127144602.GA12183@elte.hu>
References: <20090127233530U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127233530U.fujita.tomonori@lab.ntt.co.jp>
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

> Sorry about fallout from my dma mapping ops unification.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] IA64: fix the compile error on IA64_DIG_VTD
> 
> This moves iommu_detected to arch/ia64/kernel/dma-mapping.c from
> arch/ia64/kernel/pci-swiotlb.c to fix the following error on on
> IA64_DIG_VTD:
> 
> arch/ia64/kernel/built-in.o: In function `pci_iommu_init':
> pci-dma.c:(.init.text+0xa021): undefined reference to `iommu_detected'
> pci-dma.c:(.init.text+0xa030): undefined reference to `iommu_detected'
> drivers/built-in.o: In function `detect_intel_iommu':
> (.init.text+0x11c0): undefined reference to `iommu_detected'
> drivers/built-in.o: In function `detect_intel_iommu':
> (.init.text+0x11e1): undefined reference to `iommu_detected'
> 
> iommu_detected is used to handle IOMMUs so I guess that
> arch/ia64/kernel/dma-mapping.c is ok (there might be a better place
> for it though).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/ia64/kernel/dma-mapping.c |    3 +++
>  arch/ia64/kernel/pci-swiotlb.c |    3 ---
>  2 files changed, 3 insertions(+), 3 deletions(-)

Applied to tip/core/iommu, thanks!

	Ingo
