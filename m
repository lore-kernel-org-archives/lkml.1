Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYEVQcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYEVQcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYEVQcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:32:21 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:55366 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbYEVQcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:32:19 -0400
Message-ID: <4835A007.7020601@krogh.cc>
Date: Thu, 22 May 2008 18:32:07 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Matheos.Worku@Sun.COM, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <4824CBA1.8040703@sun.com>	<4824CCF0.5050302@krogh.cc>	<4824D1E1.10007@sun.com> <20080509.154538.28321777.davem@davemloft.net>
In-Reply-To: <20080509.154538.28321777.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Matheos Worku <Matheos.Worku@Sun.COM>
> Date: Fri, 09 May 2008 15:36:17 -0700
> 
>> I have observed TX throughput degradation (and increased CPU 
>> utilization)  occurs with increased # of connections, when CPU count > 4 
>> CPUs.  I don't think it is related to the driver (or HW).
> 
> All transmits through a device are fully serialized currently,
> it's a known problem and something we plan to fix.

I google'd up this one:

http://vger.kernel.org/~davem/davem_tokyo08.pdf (slide 23+).

Does this mean that I can expect every 10G card to have this limitation
under Linux? Or are some known to be better than others?
(I can probably justify paying for another 10G card if I can expect to
gain the last 400MB/s).

Since I cannot push more than ~600MB/s through the NIC before a single 
cpu is bottlenecked, it seem most likely to be this TX throughput
thing I hit.

Thanks

Jesper
-- 
Jesper
