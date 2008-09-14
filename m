Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYINOpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYINOpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYINOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:45:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYINOpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:45:23 -0400
Date: Sun, 14 Sep 2008 16:45:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
	virtual mappings
Message-ID: <20080914144508.GG12522@elte.hu>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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

> Currently, gart IOMMU ignores device's dma_mask when it does virtual
> mappings. So it could give a device a virtual address that the device
> can't access to.
> 
> Some IOMMUs, in x86 IOMMUs GART and Calgary, have this issue. This
> patchset fixes GART.
> 
> The first and second patches add helper functions, useful for some
> IOMMUs (both are taken from POWER IOMMU code). I'll convert some
> IOMMUs to use the functions after they are merged into mainline (to
> avoid complicated dependence on multiple trees).
> 
> This is against tip/x86/iommu plus a patch that I sent yesterday:
> 
> http://lkml.org/lkml/2008/9/11/147.

applied them to tip/x86/iommu:

bee44f2: x86: make GART to respect device's dma_mask about virtual mappings
589fc9a: iommu: add dma_get_mask helper function
eecfffc: iommu: add iommu_device_max_index IOMMU helper function

thanks!

	Ingo
