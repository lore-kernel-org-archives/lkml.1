Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbYI1OtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYI1OtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 10:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYI1Os7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 10:48:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:35188 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYI1Os6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 10:48:58 -0400
Date: Sun, 28 Sep 2008 23:48:15 +0900
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for
	GART
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080927181438.GF1108@elte.hu>
References: <20080925102012.GA13631@elte.hu>
	<20080925104212.GA27928@amd.com>
	<20080927181438.GF1108@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080928234819T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Sep 2008 20:14:38 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > > > -		if (iommu_leak_tab)
> > > > -			memset(iommu_leak_tab, 0, iommu_pages * 8);
> > > >  		else
> > > >  			printk(KERN_DEBUG
> > > >  			       "PCI-DMA: Cannot allocate leak trace area\n");
> > > 
> > > hm, that looks broken.
> > 
> > Argh, yes. Please try this one:
> 
> applied these patches to tip/x86/iommu:
> 
>  0114267: x86/iommu: use __GFP_ZERO instead of memset for GART
>  3610f21: x86/iommu: convert GART need_flush to bool
>  237a622: x86/iommu: make GART driver checkpatch clean
> 
> thanks Joerg!
> 
> Fujita, do they look fine to you too?

Yeah, all the patches look trivial and fine.

Thanks,
