Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYJ3Sos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYJ3Sos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYJ3Soh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:44:37 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:46776 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYJ3Sog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:44:36 -0400
Message-ID: <490A0054.2030903@cosmosbay.com>
Date: Thu, 30 Oct 2008 19:43:32 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Evgeniy Polyakov <s0mbre@tservice.net.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
References: <20081009231759.GA8664@tservice.net.ru>	<20081010115518.GA3159@tservice.net.ru>	<20081010115725.GD19487@elte.hu>	<200810250025.35734.rjw@sisk.pl>	<20081026112924.GA29258@ioremap.net>	<20081026122300.GA30905@ioremap.net> <20081030111526.7d9bb0f8@extreme>
In-Reply-To: <20081030111526.7d9bb0f8@extreme>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 30 Oct 2008 19:43:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> Has anyone looked into the impact of port randomization on this benchmark.
> If it is generating lots of sockets quickly there could be an impact:
>   * port randomization causes available port space to get filled non-uniformly
>     and what was once a linear scan may have to walk over existing ports.
>     (This could be improved by a hint bitmap)
> 
>   * port randomization adds at least one modulus operation per socket
>     creation. This could be optimized by using a loop instead.



tbench setups one socket per client, then send/receive lot of messages on this socket.

Connection setup time can be ignored for the tbench regression analysis


