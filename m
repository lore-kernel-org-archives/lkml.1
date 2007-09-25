Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXIYMzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXIYMzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXIYMzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:55:00 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34476 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbXIYMy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:54:59 -0400
Message-ID: <46F904E6.40601@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 18:23:58 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, eugene.surovegin@zultys.com
Subject: Re: 2.6.23-rc8-mm1 - drivers/net/ibm_newemac/mal - broken
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The drivers/net/ibm_newemac/mal seems to be broken, which stop with
build error

CC      drivers/net/ibm_newemac/mal.o
drivers/net/ibm_newemac/mal.c: In function ‘mal_schedule_poll’:
drivers/net/ibm_newemac/mal.c:238: error: too few arguments to function ‘netif_rx_schedule_prep’
drivers/net/ibm_newemac/mal.c:238: error: too few arguments to function ‘netif_rx_schedule_prep’
drivers/net/ibm_newemac/mal.c:238: error: too few arguments to function ‘netif_rx_schedule_prep’
drivers/net/ibm_newemac/mal.c:241: error: too few arguments to function ‘__netif_rx_schedule’
drivers/net/ibm_newemac/mal.c: In function ‘mal_poll_disable’:
drivers/net/ibm_newemac/mal.c:321: error: ‘__LINK_STATE_RX_SCHED’ undeclared (first use in this function)
drivers/net/ibm_newemac/mal.c:321: error: (Each undeclared identifier is reported only once
drivers/net/ibm_newemac/mal.c:321: error: for each function it appears in.)
drivers/net/ibm_newemac/mal.c: In function ‘mal_poll’:
drivers/net/ibm_newemac/mal.c:337: error: ‘struct net_device’ has no member named ‘quota’
drivers/net/ibm_newemac/mal.c:337: warning: type defaults to ‘int’ in declaration of ‘_x’
drivers/net/ibm_newemac/mal.c:337: error: ‘struct net_device’ has no member named ‘quota’
drivers/net/ibm_newemac/mal.c:375: error: too few arguments to function ‘__netif_rx_complete’
drivers/net/ibm_newemac/mal.c:390: warning: passing argument 2 of ‘netif_rx_reschedule’ makes pointer from integer without a cast
drivers/net/ibm_newemac/mal.c:404: error: ‘struct net_device’ has no member named ‘quota’
drivers/net/ibm_newemac/mal.c: In function ‘mal_probe’:
drivers/net/ibm_newemac/mal.c:542: error: ‘struct net_device’ has no member named ‘weight’
drivers/net/ibm_newemac/mal.c:543: error: ‘struct net_device’ has no member named ‘poll’
drivers/net/ibm_newemac/mal.c: In function ‘mal_remove’:
drivers/net/ibm_newemac/mal.c:660: error: implicit declaration of function ‘netif_poll_disable’
make[3]: *** [drivers/net/ibm_newemac/mal.o] Error 1
make[2]: *** [drivers/net/ibm_newemac] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
