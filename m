Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0BSHpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:45:12 -0500
Received: from sh.osrg.net ([192.16.179.4]:40247 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab0BSHpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:45:09 -0500
Date: Fri, 19 Feb 2010 16:44:29 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org, rolandd@cisco.com,
       eli@mellanox.co.il, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx4: replace the dma_sync_single_range_for_cpu/device
 API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <adavde35rr9.fsf@roland-alpha.cisco.com>
References: <20100205135626G.fujita.tomonori@lab.ntt.co.jp>
	<20100204.210939.133998827.davem@davemloft.net>
	<adavde35rr9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100219164408H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 19 Feb 2010 16:44:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 14:31:22 -0800
Roland Dreier <rdreier@cisco.com> wrote:

>  > > There are only two users of the dma_sync_single_range_for_cpu/device
>  > > API in mainline (mlx4 and ssb). The
>  > > dma_sync_single_range_for_cpu/device API has never been documented and
>  > > the dma_sync_single_for_cpu/device API also support a partial sync.
>  > > 
>  > > This converts mlx4 to use the dma_sync_single_for_cpu/device API
>  > > (preparations for the removal of the dma_sync_single_range_for_cpu/device API).
>  > > 
>  > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>  > 
>  > Acked-by: David S. Miller <davem@davemloft.net>
> 
> Dave, please go ahead and merge this -- this affects the mlx4 ethernet
> driver, so it's your area anyway.

Seems that net-next still doesn't have this. Can you please merge
this?

Thanks,
