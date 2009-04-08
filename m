Return-Path: <linux-kernel-owner+w=401wt.eu-S933732AbZDHOPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbZDHOPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933470AbZDHOL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:11:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:35403 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbZDHOLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:11:54 -0400
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org,
       jeremy@goop.org, ian.campbell@citrix.com
Message-Id: <C60BE0D1-F750-4ED3-B1E6-CCF89F57B6C2@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090408140521.GB12931@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 5/7] swiotlb: (re)Create swiotlb_unmap_single
Date: Wed, 8 Apr 2009 09:10:38 -0500
References: <77EA4458-602F-4DA9-B7E7-E48B5B0DCF91@kernel.crashing.org> <20090408022241U.fujita.tomonori@lab.ntt.co.jp> <726BF449-4F7A-472D-AC5A-D8218B61210B@kernel.crashing.org> <20090408031541G.fujita.tomonori@lab.ntt.co.jp> <20090408124322.GG18581@elte.hu> <C650C751-B5D8-4FA5-87E1-CF20D596F3B7@kernel.crashing.org> <20090408140521.GB12931@elte.hu>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>
>>> the patches came right in the merge window - that's too late for
>>> IOMMU bits, the patch cutoff is generally the beginning of the merge
>>> window. (Which was on March 23 in this window)
>>
>> Fair.
>>
>>> But i can queue them up in the .31 queue if it has all the Acks from
>>> you folks. Becky, mind resending the latest version, with all the
>>> acks in place?
>>
>> I can do this in Becky's abscense this week.  The only "acks" I've
>> seen are from FUJITA Tomonori.
>
> _your_ ack (or signoff) counts too - so to me it's plural :-)

I've added my signoff :)

>> Can we ask there be a unique swiotlb branch in your tree to make
>> it easier for us to continue additional swiotlb work as well as
>> arch specific work.
>
> yes - tip:core/iommu is already distinct from tip:x86/iommu and is
> intended for such more generic patches. It has no patches pending
> right now (it just got all merged upstream) - so please use an
> upstream base - 2.6.30-rc1 would be a good starting point.

Just reposted v3 based on 2.6.30-rc1

- k
