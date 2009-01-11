Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZAKEdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZAKEdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZAKEdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:33:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZAKEdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:33:06 -0500
Date: Sun, 11 Jan 2009 05:32:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ian.Campbell@citrix.com, linux-kernel@vger.kernel.org, jeremy@goop.org,
       jj@chaosbits.net, weiyi.huang@gmail.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 0/2] Re: swiotlb: remove duplicated #include
Message-ID: <20090111043251.GB7361@elte.hu>
References: <20090111035527.GC28520@elte.hu> <20090111130018X.fujita.tomonori@lab.ntt.co.jp> <20090111040428.GE28520@elte.hu> <20090111132204L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111132204L.fujita.tomonori@lab.ntt.co.jp>
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

> On Sun, 11 Jan 2009 05:04:28 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > On Sun, 11 Jan 2009 04:55:27 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > > > 
> > > > > On Fri, 2009-01-09 at 18:10 +0000, Ian Campbell wrote:
> > > > > 
> > > > > > Patch is against Jeremy's Xen patch queue which is based on a pre-Xmas
> > > > > > tip tree so fairly out of date, I hope it is somewhat useful though.
> > > > > 
> > > > > Here's a version again tip-latest, only compile tested though since my
> > > > > testing relies on the Xen dom0 patch queue.
> > > > 
> > > > Applied them to tip/core/iommu:
> > > > 
> > > >  961d7d0: swiotlb: do not use sg_virt()
> > > >  0b8698a: swiotlb: range_needs_mapping should take a physical address.
> > > 
> > > I think that Xen camp wants these changes for 2.6.29. Are you trying to 
> > > push tip/core/iommu for 2.6.29?
> > 
> > Yet unclear, depends on testing. Will probably wait for 2.6.30 though.
> 
> Thanks, I see. Probably, it will get tons of conflict due to the dma API 
> unification touching everywhere.
>
> BTW, what happened to?
> 
> http://marc.info/?l=linux-kernel&m=123125853906986&w=2

it's in -rc1.

	Ingo
