Return-Path: <linux-kernel-owner+w=401wt.eu-S1764417AbZDHMns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764417AbZDHMns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZDHMnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:43:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36016 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbZDHMni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:43:38 -0400
Date: Wed, 8 Apr 2009 14:43:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: galak@kernel.crashing.org, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org, jeremy@goop.org, ian.campbell@citrix.com
Subject: Re: [PATCH 5/7] swiotlb: (re)Create swiotlb_unmap_single
Message-ID: <20090408124322.GG18581@elte.hu>
References: <77EA4458-602F-4DA9-B7E7-E48B5B0DCF91@kernel.crashing.org> <20090408022241U.fujita.tomonori@lab.ntt.co.jp> <726BF449-4F7A-472D-AC5A-D8218B61210B@kernel.crashing.org> <20090408031541G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408031541G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > Same here.  It makes it easier for us to work on the powerpc arch  
> > specific changes for .31 if we can get these into .30.  What are you  
> > looking at for .31?
> 
> I need to finish the dma_mapping_ops cleanups and cross-arch 
> unification stuff:
> 
> http://marc.info/?l=linux-kernel&m=123827903216314&w=2
> 
> But the changes to swiotlb is minor. BTW, I have the patches for 
> powerpc too.
> 
> > Ingo, any comments on that?

if it's genuine fixes we can do it post-rc1, but it looks a tad wide 
for that:

 arch/x86/kernel/pci-swiotlb.c |    2 +-
 include/linux/swiotlb.h       |    3 +-
 lib/swiotlb.c                 |  115 ++++++++++++++++++++++-------------------

the patches came right in the merge window - that's too late for 
IOMMU bits, the patch cutoff is generally the beginning of the merge 
window. (Which was on March 23 in this window)

But i can queue them up in the .31 queue if it has all the Acks from 
you folks. Becky, mind resending the latest version, with all the 
acks in place?

Thanks,

	Ingo
