Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYDCLka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYDCLka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 07:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYDCLkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 07:40:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:39154 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYDCLkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:40:18 -0400
Message-ID: <47F4C21A.6090402@mellanox.co.il>
Date: Thu, 03 Apr 2008 14:40:10 +0300
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: tziporet@dev.mellanox.co.il, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's
 in infiniband.git)
References: <adave31bayd.fsf@cisco.com> <47F37CA4.8000109@mellanox.co.il> <adahcek2pru.fsf@cisco.com>
In-Reply-To: <adahcek2pru.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Send with invalidate should be OK.  Let's see about the masked atomics
> stuff -- we have a ton of new verbs and I think we might want to slow
> down and make sure it all makes sense.
>   
OK - will send and then we will see what will come out.

>  > What about the split CQ for UD mode? It's improved the IPoIB
>  > performance for small messages significantly.
>
> Oh yeah... I'll try to get that in too.
>   
thanks
>  > mlx4- we plan to send patches for the low level driver only to enable
>  > mlx4_en. These only affect our low level driver.
>
> No problem in principle, let's see the actual patches.
>   
Sure
>  > I think we should try to push for XEC in 2.6.26 since there are
>  > already MPI implementation that use it and this ties them to use OFED
>  > only.
>  > Also this feature is stable and now being defined in IBTA
>  > Not taking it causing changes between OFED and the kernel and your
>  > libibverbs and we wish to avoid such gaps.
>  > Is there any thing we can do to help and make it into 2.6.26?
>
> I don't have a good feeling that the user-kernel interface is well
> thought out, so I want to consider XRC + ehca LL stuff + new iWARP verbs
> and make sure we have something that makes sense for the future.
>
>   
I see - but can't we figure this all for the 2.6.26 window?

Tziporet

