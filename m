Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab0BEFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 00:09:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36845
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab0BEFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 00:09:26 -0500
Date: Thu, 04 Feb 2010 21:09:39 -0800 (PST)
Message-Id: <20100204.210939.133998827.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: netdev@vger.kernel.org, rolandd@cisco.com, eli@mellanox.co.il,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx4: replace the dma_sync_single_range_for_cpu/device
 API
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100205135626G.fujita.tomonori@lab.ntt.co.jp>
References: <20100205135626G.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 5 Feb 2010 13:57:42 +0900

> There are only two users of the dma_sync_single_range_for_cpu/device
> API in mainline (mlx4 and ssb). The
> dma_sync_single_range_for_cpu/device API has never been documented and
> the dma_sync_single_for_cpu/device API also support a partial sync.
> 
> This converts mlx4 to use the dma_sync_single_for_cpu/device API
> (preparations for the removal of the dma_sync_single_range_for_cpu/device API).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David S. Miller <davem@davemloft.net>
