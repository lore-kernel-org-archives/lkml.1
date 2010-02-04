Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0BDSVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:21:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36198
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537Ab0BDSVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:21:00 -0500
Date: Thu, 04 Feb 2010 10:21:13 -0800 (PST)
Message-Id: <20100204.102113.267879565.davem@davemloft.net>
To: opurdila@ixiacom.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, linux-sctp@vger.kernel.org
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed
 port numbers
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002042015.51092.opurdila@ixiacom.com>
References: <201002041444.01897.opurdila@ixiacom.com>
	<20100204.094110.64247447.davem@davemloft.net>
	<201002042015.51092.opurdila@ixiacom.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Octavian Purdila <opurdila@ixiacom.com>
Date: Thu, 4 Feb 2010 20:15:51 +0200

> int inet_is_reserved_local_port(int port)
> {
> 	if (test_bit(port, reserved_ports))
> 		return 1;
> 	return 0;
> }
> 
> In theory it might be slower because of the reserved_ports bitmap will have a 
> larger memory footprint than just a min/max, especially with random port 
> allocation. But is this an issue in practice?

No need to speculate, some simple benchmarks would confirm or deny
this.
