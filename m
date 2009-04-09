Return-Path: <linux-kernel-owner+w=401wt.eu-S936340AbZDITy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340AbZDITy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 15:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761949AbZDITyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 15:54:13 -0400
Received: from gw.goop.org ([64.81.55.164]:47023 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759488AbZDITyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:54:12 -0400
Message-ID: <49DE5260.3070603@goop.org>
Date: Thu, 09 Apr 2009 12:54:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: galak@kernel.crashing.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
References: <49DD3C9C.7060101@goop.org>	<20090410033357S.fujita.tomonori@lab.ntt.co.jp>	<49DE4A37.3080702@goop.org> <20090410045039G.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090410045039G.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> Hmm, I think that ia64 use swiotlb_alloc_boot too.
>
> ia64 uses swiotlb in two ways; using only swiotlb, using swiotlb and
> hw iommu. The latter is similar what x86 Calgary does.
>   

Yes, I see.  It also calls swiotlb_init() -> 
swiotlb_init_with_default_size(), though I got lost in the 
machvec/platform setup, so I couldn't quite work out where 
platform_dma_init() gets called from.

But I couldn't see any x86 references to 
swiotlb_late_init_with_default_size().

    J
