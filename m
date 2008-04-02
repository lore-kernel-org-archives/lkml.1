Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYDBMbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYDBMbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYDBMbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:31:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:16219 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYDBMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:31:40 -0400
Message-ID: <47F37CA4.8000109@mellanox.co.il>
Date: Wed, 02 Apr 2008 15:31:32 +0300
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's
 in infiniband.git)
References: <adave31bayd.fsf@cisco.com>
In-Reply-To: <adave31bayd.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Core:
>
>  - I did a bunch of cleanups all over drivers/infiniband and the
>    gcc and sparse warning noise is down to a pretty reasonable level.
>    Further cleanups welcome of course.
>   
We want to add send with invalidate & mask compare and swap.
Eli will be able to send the patches next week and since they are small 
I think they can be in for 2.6.26
> ULPs:
>
>  - I merged Eli's IPoIB stateless offload changes for checksum
>    offload and LSO changes.  The interrupt moderation changes are
>    next, and should not be a problem to merge.  Please test IPoIB
>    on all sorts of hardware!
>   
What about the split CQ for UD mode? It's improved the IPoIB performance 
for small messages significantly.
>
> HW specific:
>
>   
mlx4- we plan to send patches for the low level driver only to enable 
mlx4_en. These only affect our low level driver.
Should be ready next week. I hope these can get in too.
> Here are a few topics that I believe will not be ready in time for the
> 2.6.26 window and will need to wait for 2.6.27 at least:
>
>  - XRC.  I still don't have a good feeling that we have settled on all
>    the nuances of the ABI we want to expose to userspace for this, and
>    ideally I would like to understand how ehca LL QPs fit into the
>    picture as well.
>   
I think we should try to push for XEC in 2.6.26 since there are already 
MPI implementation that use it and this ties them to use OFED only.
Also this feature is stable and now being defined in IBTA
Not taking it causing changes between OFED and the kernel and your 
libibverbs and we wish to avoid such gaps.
Is there any thing we can do to help and make it into 2.6.26?


