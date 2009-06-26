Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbZFZQ3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbZFZQ3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZFZQ2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:28:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41867
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbZFZQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:28:53 -0400
Date: Fri, 26 Jun 2009 09:28:58 -0700 (PDT)
Message-Id: <20090626.092858.64239359.davem@davemloft.net>
To: avorontsov@ru.mvista.com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: Fix checksum endianness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090626145159.GA2242@oksana.dev.rtsoft.ru>
References: <20090626145159.GA2242@oksana.dev.rtsoft.ru>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@ru.mvista.com>
Date: Fri, 26 Jun 2009 18:51:59 +0400

> sky2 driver on PowerPC targets floods kernel log with following errors:
> 
>   eth1: hw csum failure.
>   Call Trace:
>   [ef84b8a0] [c00075e4] show_stack+0x50/0x160 (unreliable)
>   [ef84b8d0] [c02fa178] netdev_rx_csum_fault+0x3c/0x5c
>   [ef84b8f0] [c02f6920] __skb_checksum_complete_head+0x7c/0x84
>   [ef84b900] [c02f693c] __skb_checksum_complete+0x14/0x24
>   [ef84b910] [c0337e08] tcp_v4_rcv+0x4c8/0x6f8
>   [ef84b940] [c031a9c8] ip_local_deliver+0x98/0x210
>   [ef84b960] [c031a788] ip_rcv+0x38c/0x534
>   [ef84b990] [c0300338] netif_receive_skb+0x260/0x36c
>   [ef84b9c0] [c025de00] sky2_poll+0x5dc/0xcf8
>   [ef84ba20] [c02fb7fc] net_rx_action+0xc0/0x144
> 
> The NIC is Yukon-2 EC chip revision 1.
> 
> Converting checksum field from le16 to CPU byte order fixes the issue.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Applied, thank you!
