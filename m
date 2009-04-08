Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbZDHNhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbZDHNhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZDHNhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:37:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:40624 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762696AbZDHNhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:37:18 -0400
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org,
       jeremy@goop.org, ian.campbell@citrix.com
Message-Id: <C650C751-B5D8-4FA5-87E1-CF20D596F3B7@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090408124322.GG18581@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 5/7] swiotlb: (re)Create swiotlb_unmap_single
Date: Wed, 8 Apr 2009 08:35:39 -0500
References: <77EA4458-602F-4DA9-B7E7-E48B5B0DCF91@kernel.crashing.org> <20090408022241U.fujita.tomonori@lab.ntt.co.jp> <726BF449-4F7A-472D-AC5A-D8218B61210B@kernel.crashing.org> <20090408031541G.fujita.tomonori@lab.ntt.co.jp> <20090408124322.GG18581@elte.hu>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8, 2009, at 7:43 AM, Ingo Molnar wrote:

>
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>>> Same here.  It makes it easier for us to work on the powerpc arch
>>> specific changes for .31 if we can get these into .30.  What are you
>>> looking at for .31?
>>
>> I need to finish the dma_mapping_ops cleanups and cross-arch
>> unification stuff:
>>
>> http://marc.info/?l=linux-kernel&m=123827903216314&w=2
>>
>> But the changes to swiotlb is minor. BTW, I have the patches for
>> powerpc too.
>>
>>> Ingo, any comments on that?
>
> if it's genuine fixes we can do it post-rc1, but it looks a tad wide
> for that:
>
> arch/x86/kernel/pci-swiotlb.c |    2 +-
> include/linux/swiotlb.h       |    3 +-
> lib/swiotlb.c                 |  115 +++++++++++++++++++++ 
> +-------------------
>
> the patches came right in the merge window - that's too late for
> IOMMU bits, the patch cutoff is generally the beginning of the merge
> window. (Which was on March 23 in this window)

Fair.

> But i can queue them up in the .31 queue if it has all the Acks from
> you folks. Becky, mind resending the latest version, with all the
> acks in place?

I can do this in Becky's abscense this week.  The only "acks" I've  
seen are from FUJITA Tomonori.

Can we ask there be a unique swiotlb branch in your tree to make it  
easier for us to continue additional swiotlb work as well as arch  
specific work.

- k
