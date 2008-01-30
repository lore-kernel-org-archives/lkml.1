Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYA3IKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYA3IKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYA3IKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:10:21 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:7538 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYA3IKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:10:20 -0500
Message-ID: <47A02FDC.1050309@fr.ibm.com>
Date: Wed, 30 Jan 2008 09:05:48 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-git6 net build failure when SYSFS=n, PROC_FS=n
References: <20080129160254.b7ff01bc.randy.dunlap@oracle.com>
In-Reply-To: <20080129160254.b7ff01bc.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> linux-2.6.24-git6/net/ipv4/fib_frontend.c: In function 'fib_net_init':
> linux-2.6.24-git6/net/ipv4/fib_frontend.c:1024: error: implicit declaration of function 'fib_proc_init'
> linux-2.6.24-git6/net/ipv4/fib_frontend.c: In function 'fib_net_exit':
> linux-2.6.24-git6/net/ipv4/fib_frontend.c:1039: error: implicit declaration of function 'fib_proc_exit'
> 
> linux-2.6.24-git6/net/ipv6/sysctl_net_ipv6.c: In function 'ipv6_sysctl_net_init':
> linux-2.6.24-git6/net/ipv6/sysctl_net_ipv6.c:71: error: implicit declaration of function 'ipv6_route_sysctl_init'
> linux-2.6.24-git6/net/ipv6/sysctl_net_ipv6.c:71: warning: assignment makes pointer from integer without a cast
> linux-2.6.24-git6/net/ipv6/sysctl_net_ipv6.c:75: error: implicit declaration of function 'ipv6_icmp_sysctl_init'
> linux-2.6.24-git6/net/ipv6/sysctl_net_ipv6.c:75: warning: assignment makes pointer from integer without a cast
> 
> 
> config attached.
> 
> ---
> ~Randy

Hi,

thanks for catching this. I sent a fix for these two compilation errors 
a few days ago. I guess they will be merged very soon by Dave.

   -- Daniel
