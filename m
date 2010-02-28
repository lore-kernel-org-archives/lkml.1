Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031566Ab0B1IQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:16:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36234
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031512Ab0B1IQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:16:10 -0500
Date: Sun, 28 Feb 2010 00:16:28 -0800 (PST)
Message-Id: <20100228.001628.48507956.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: hancockrwd@gmail.com, bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking
 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100228033706G.fujita.tomonori@lab.ntt.co.jp>
References: <20100227.040502.182574085.davem@davemloft.net>
	<51f3faa71002271015i7c9ec45j18381b1269bfd799@mail.gmail.com>
	<20100228033706G.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sun, 28 Feb 2010 03:38:19 +0900

> When I proposed such approach (always use swiotlb) before, IIRC,
> the objections were:
> 
> - better to make allocation respect dma_mask. (I don't think that this
>   approach is possible since we don't know which device handles data
>   later when we allocate memory).

And such objects might end up being processed by multiple devices with
different DMA restrictions.

> - swiotlb is not good for small systems since it allocates too much
>   memory (we can fix this though).

Indeed.
