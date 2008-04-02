Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYDBQTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYDBQTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYDBQTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:19:20 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:57497 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbYDBQTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:19:18 -0400
From: Roland Dreier <rdreier@cisco.com>
To: tziporet@dev.mellanox.co.il
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's in infiniband.git)
References: <adave31bayd.fsf@cisco.com> <47F37CA4.8000109@mellanox.co.il>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Apr 2008 09:19:17 -0700
In-Reply-To: <47F37CA4.8000109@mellanox.co.il> (Tziporet Koren's message of
	"Wed, 02 Apr 2008 15:31:32 +0300")
Message-ID: <adahcek2pru.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2008 16:19:18.0055 (UTC) FILETIME=[4CFF6B70:01C894DD]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > We want to add send with invalidate & mask compare and swap.
 > Eli will be able to send the patches next week and since they are
 > small I think they can be in for 2.6.26

Send with invalidate should be OK.  Let's see about the masked atomics
stuff -- we have a ton of new verbs and I think we might want to slow
down and make sure it all makes sense.

 > What about the split CQ for UD mode? It's improved the IPoIB
 > performance for small messages significantly.

Oh yeah... I'll try to get that in too.

 > mlx4- we plan to send patches for the low level driver only to enable
 > mlx4_en. These only affect our low level driver.

No problem in principle, let's see the actual patches.

 > I think we should try to push for XEC in 2.6.26 since there are
 > already MPI implementation that use it and this ties them to use OFED
 > only.
 > Also this feature is stable and now being defined in IBTA
 > Not taking it causing changes between OFED and the kernel and your
 > libibverbs and we wish to avoid such gaps.
 > Is there any thing we can do to help and make it into 2.6.26?

I don't have a good feeling that the user-kernel interface is well
thought out, so I want to consider XRC + ehca LL stuff + new iWARP verbs
and make sure we have something that makes sense for the future.

 - R.
