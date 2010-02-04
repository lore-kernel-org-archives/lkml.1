Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0BDDUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:20:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab0BDDUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:20:48 -0500
Message-ID: <4B6A3DBA.1000706@redhat.com>
Date: Thu, 04 Feb 2010 11:23:38 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port
 numbers
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain> <201002031312.48531.opurdila@ixiacom.com>
In-Reply-To: <201002031312.48531.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Wednesday 03 February 2010 06:30:07 you wrote:
> 
>> This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports,
>> it can be used like ip_local_port_range, but this is used to
>> reserve ports for third-party applications which use fixed
>> port numbers within ip_local_port_range.
>>
>> This only affects the applications which call socket functions
>> like bind(2) with port number 0, to prevent the kernel getting the ports
>> within the specified range for them. For applications which use fixed
>> port number, it will have no effects.
> 
> It also affects the case where applications do connect, without previously 
> doing bind, right?


Yeah, I forgot to mention this, sorry.

> 
>> Any comments are welcome.
> 
> I think it might be useful to allow setting individual ports as reserved, not 
> only ranges, for example by using a bitmap. 
> 

This is a good idea, but I am not sure if this will be overkill? :-/
Also, using bitmap is not friendly to sysctl interface, I am afraid.


Thanks!
