Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0BCLQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:16:15 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:20015 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753126Ab0BCLQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:16:13 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Date: Wed, 3 Feb 2010 13:12:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-trunk-686; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org,
       David Miller <davem@davemloft.net>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain>
In-Reply-To: <20100203043332.3817.27932.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002031312.48531.opurdila@ixiacom.com>
X-OriginalArrivalTime: 03 Feb 2010 11:16:11.0764 (UTC) FILETIME=[4AB7A340:01CAA4C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010 06:30:07 you wrote:

> This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports,
> it can be used like ip_local_port_range, but this is used to
> reserve ports for third-party applications which use fixed
> port numbers within ip_local_port_range.
> 
> This only affects the applications which call socket functions
> like bind(2) with port number 0, to prevent the kernel getting the ports
> within the specified range for them. For applications which use fixed
> port number, it will have no effects.

It also affects the case where applications do connect, without previously 
doing bind, right?

> 
> Any comments are welcome.

I think it might be useful to allow setting individual ports as reserved, not 
only ranges, for example by using a bitmap. 


