Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0BSUjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:39:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46693
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034Ab0BSUjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:39:17 -0500
Date: Fri, 19 Feb 2010 12:39:31 -0800 (PST)
Message-Id: <20100219.123931.229106308.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: netdev@vger.kernel.org, rolandd@cisco.com, eli@mellanox.co.il,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx4: replace the dma_sync_single_range_for_cpu/device
 API
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100219164408H.fujita.tomonori@lab.ntt.co.jp>
References: <20100204.210939.133998827.davem@davemloft.net>
	<adavde35rr9.fsf@roland-alpha.cisco.com>
	<20100219164408H.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 19 Feb 2010 16:44:29 +0900

> On Thu, 11 Feb 2010 14:31:22 -0800
> Roland Dreier <rdreier@cisco.com> wrote:
> 
>>  > > There are only two users of the dma_sync_single_range_for_cpu/device
>>  > > API in mainline (mlx4 and ssb). The
>>  > > dma_sync_single_range_for_cpu/device API has never been documented and
>>  > > the dma_sync_single_for_cpu/device API also support a partial sync.
>>  > > 
>>  > > This converts mlx4 to use the dma_sync_single_for_cpu/device API
>>  > > (preparations for the removal of the dma_sync_single_range_for_cpu/device API).
>>  > > 
>>  > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>  > 
>>  > Acked-by: David S. Miller <davem@davemloft.net>
>> 
>> Dave, please go ahead and merge this -- this affects the mlx4 ethernet
>> driver, so it's your area anyway.
> 
> Seems that net-next still doesn't have this. Can you please merge
> this?

I'll take care of this later today.
