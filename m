Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZHMHER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZHMHER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZHMHER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:04:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZHMHEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:04:16 -0400
Date: Thu, 13 Aug 2009 09:04:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com
Subject: Re: [PATCH resend 0/8] sparc: use asm-generic/dma-mapping-common.h
	and pci-dma-compat.h
Message-ID: <20090813070402.GE12143@elte.hu>
References: <1249872797-1314-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090812.163427.161326946.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812.163427.161326946.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Mon, 10 Aug 2009 11:53:09 +0900
> 
> > This is the repost of the patchset (as Ingo asked me offline) :
> > 
> > http://lkml.org/lkml/2009/7/13/20
> > 
> > There is no functional change. I just added David's ack to #3-8
> > patches and Robert's Tested-by to #8 patch.
> > 
> > I confirmed that it can be applied cleanly to mainline, -next, and
> > -tip trees.
> > 
> > The git tree is also available:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git 
> > sparc
> 
> I just made a quick build test on sparc32 and sparc64, as well as 
> a non-debug execution test on sparc64 and it all looks fine.
> 
> Thanks for doing this work!
> 
> I assume Ingo or someone else is going to merge this stuff?

Yeah, it's in the tip:core/iommu tree:

451d740: sparc: Add CONFIG_DMA_API_DEBUG support
ee664a9: sparc: Use asm-generic/pci-dma-compat
c2c07db: sparc: Replace sbus_map_single and sbus_unmap_single with sbus_map_page and sbus_unmap_page
595cc85: sparc: Remove no-op dma_4v_sync_single_for_cpu and dma_4v_sync_sg_for_cpu
02f7a18: sparc: Use asm-generic/dma-mapping-common.h
bc0a14f: sparc: Use dma_map_ops struct

and pushed out to linux-next as well and present there as well.

I did a cross-build test of Sparc before i pushed it out, but it 
would be nice if you could check the end result linux-next as well 
... just in case. (whenever you get around to do it - there's no 
urgency.)

	Ingo
