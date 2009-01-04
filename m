Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZADMUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZADMUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZADMUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:20:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZADMUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:20:02 -0500
Date: Sun, 4 Jan 2009 13:19:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>
Cc: jj@chaosbits.net, weiyi.huang@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove duplicated #include
Message-ID: <20090104121914.GA30255@elte.hu>
References: <20090104110951.C9AB.WEIYI.HUANG@gmail.com> <alpine.LNX.2.00.0901041057400.26359@swampdragon.chaosbits.net> <20090104112541.GA25434@elte.hu> <20090104210420X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104210420X.fujita.tomonori@lab.ntt.co.jp>
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

> On Sun, 4 Jan 2009 12:25:43 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Jesper Juhl <jj@chaosbits.net> wrote:
> > 
> > > On Sun, 4 Jan 2009, Huang Weiyi wrote:
> > > 
> > > > Removed duplicated #include in lib/swiotlb.c.
> > > > 
> > > 
> > > This is identical to a patch I already submitted - 
> > > http://lkml.org/lkml/2009/1/2/360 - but I don't know if that one has been 
> > > merged anywhere yet.
> > 
> > i've applied yours to tip/core/urgent, thanks Jesper!
> 
> The same cleanup is in tip/core/iommu:
> 
> http://marc.info/?l=linux-kernel&m=123044446721529&w=2

yes, correct - as part of Becky and Jeremy's highmem series.

> My cleanup patches in it are trivial, but I like to see Becky's swiotlb 
> highmem work, which is still in tip/core/iommu. When do you plan to push 
> it to mainline?

In a few days, but wanted to hear back from either Jeremy or Becky first 
about how well they actually work in their usecases.

	Ingo
