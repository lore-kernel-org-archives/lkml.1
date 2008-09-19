Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYISSso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYISSso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYISSsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:48:35 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:39498 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYISSse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:48:34 -0400
Date: Sat, 20 Sep 2008 03:48:11 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919180118.GV24392@amd.com>
References: <20080919173004.GA9837@amd.com>
	<20080920024046W.fujita.tomonori@lab.ntt.co.jp>
	<20080919180118.GV24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920034750X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 20:01:18 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 02:40:35AM +0900, FUJITA Tomonori wrote:
> > On Fri, 19 Sep 2008 19:30:04 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Sat, Sep 20, 2008 at 02:09:21AM +0900, FUJITA Tomonori wrote:
> > > > 
> > > > Please keep it for AMD option for now. Please send a patch to make it
> > > > generic to other IOMMU people and give them a chance to discuss on
> > > > it.
> > > >
> > > 
> > > Btw, you already agreed with a generic iommu= parameter for lazy IO/TLB
> > > flushing"
> > > 
> > > 
> > >  > True. We should merge common parameters across IOMMUs into the
> > >  > iommu= parameter some time in the future, I think. It would also be the
> > >  > place for the IOMMU size parameter.
> > > 
> > >  Hmm, now is better than the future? I think that now you can add
> > >  something like 'disable_batching_flush' as a common parameter and
> > >  change AMD IOMMU to use it.
> > > 
> > > in http://lkml.org/lkml/2008/9/17/376
> > > 
> > > And since we already have a iommu=fullflush parameter it makes sense of
> > > make it generic.
> > 
> > I'm not against fullflush but we need to discuss it with other people
> > before making the change.
> 
> Weird. Just 2 hours ago you wrote:
> 
> |http://lkml.org/lkml/2008/9/19/106
> |
> |For me, adding these boot parameters doesn't make sense.

See:

http://lkml.org/lkml/2008/9/19/221


> Anyway, I wrote to the Intel and Calgary developers and asked them for
> their opinion. If they have real objections I am the last person NACKing
> your original patch in this thread again.

I think that I already expressed a real objection for nofullflush
twice though I'm not the maintainer of any IOMMUs.


> The reason why I queued this patch in AMD IOMMU updates was that I
> didn't wanted to implement an option specificly for AMD IOMMU when there
> will be a generic one soon. This is double work I prefered to do it

You were not sure that they will be generic before discussion.


> right in the first step. The change does not break anything on Intel and
> Calgary.
