Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYBEQAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYBEQAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYBEQAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:00:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:26116 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYBEP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:59:59 -0500
Message-ID: <47A887F4.70801@mellanox.co.il>
Date: Tue, 05 Feb 2008 17:59:48 +0200
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [GIT PULL] please pull infiniband.git
References: <adamyqgf1nz.fsf@cisco.com>
In-Reply-To: <adamyqgf1nz.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Linus, please pull from
>
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This tree is also available from kernel.org mirrors at:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This will get a second batch of InfiniBand/RDMA batches.  In addition
> to the usual motley crew of changes, this pull includes a new driver
> for NetEffect RNICs in drivers/infiniband/hw/nes.  The code could use
> some further cleaning, but I don't think it's worth holding off on the
> merge.
>
> David Dillow (1):
>       IB/srp: Retry stale connections
>
> Eli Cohen (2):
>       IB/mthca: Remove checks for srq->first_free < 0
>       IB/ib_mthca: Pre-link receive WQEs in Tavor mode
>
> Glenn Streiff (1):
>       RDMA/nes: Add a driver for NetEffect RNICs
>
> Hoang-Nam Nguyen (1):
>       IB/ehca: Add PMA support
>
> Jack Morgenstein (2):
>       IB/mthca: Don't read reserved fields in mthca_QUERY_ADAPTER()
>       mlx4_core: Don't read reserved fields in mlx4_QUERY_ADAPTER()
>
> Joachim Fenkes (2):
>       IB/ehca: Prevent sending UD packets to QP0
>       IB/ehca: Update sma_attr also in case of disruptive config change
>
> Olaf Kirch (1):
>       IB/mthca: Return proper error codes from mthca_fmr_alloc()
>
> Or Gerlitz (3):
>       IPoIB: Handle bonding failover race for connected neighbours too
>       IPoIB: Remove a misleading debug print
>       IB/fmr_pool: Allocate page list for pool FMRs only when caching enabled
>
> Roland Dreier (4):
>       mlx4_core: Fix more section mismatches
>       IB/mthca: Fix and simplify page size calculation in mthca_reg_phys_mr()
>       IB/mlx4: Actually print out the driver version
>       IB: Avoid marking __devinitdata as const
>
> Sean Hefty (1):
>       IB/cm: Add interim support for routed paths
>
>
>   

Does this means ConnectX WQE BB and stateless offload will not be in for 
2.6.25?

Tziporet

