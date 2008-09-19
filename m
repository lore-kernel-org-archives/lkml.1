Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYISRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYISRlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYISRlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:41:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:58311 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbYISRlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:41:05 -0400
Date: Sat, 20 Sep 2008 02:40:35 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919173004.GA9837@amd.com>
References: <20080919164541.GS24392@amd.com>
	<20080920020917O.fujita.tomonori@lab.ntt.co.jp>
	<20080919173004.GA9837@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920024046W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 19:30:04 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 02:09:21AM +0900, FUJITA Tomonori wrote:
> > 
> > Please keep it for AMD option for now. Please send a patch to make it
> > generic to other IOMMU people and give them a chance to discuss on
> > it.
> >
> 
> Btw, you already agreed with a generic iommu= parameter for lazy IO/TLB
> flushing"
> 
> 
>  > True. We should merge common parameters across IOMMUs into the
>  > iommu= parameter some time in the future, I think. It would also be the
>  > place for the IOMMU size parameter.
> 
>  Hmm, now is better than the future? I think that now you can add
>  something like 'disable_batching_flush' as a common parameter and
>  change AMD IOMMU to use it.
> 
> in http://lkml.org/lkml/2008/9/17/376
> 
> And since we already have a iommu=fullflush parameter it makes sense of
> make it generic.

I'm not against fullflush but we need to discuss it with other people
before making the change.

Please,
