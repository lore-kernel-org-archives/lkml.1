Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0BAKS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:18:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0BAKS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:18:26 -0500
Message-ID: <4B66AB33.60202@redhat.com>
Date: Mon, 01 Feb 2010 18:21:39 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: Re: [Patch v2] net: export TCP send buffer size via netlink
References: <20100201092153.4194.91507.sendpatchset@localhost.localdomain>	<20100201.020055.57470143.davem@davemloft.net> <20100201.020622.91421099.davem@davemloft.net>
In-Reply-To: <20100201.020622.91421099.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Before you spend the next couple hours trying to figure out what to
> do...
> 
> We already provide the information you're trying to export via
> linux/inet_diag.h:inet_diag_meminfo
> 
> I hope the light goes on now :-)
> 

Oh, I was just looking for a pointer.

Ok, ->idiag_wmem is gotten from sk->sk_wmem_queued, so ->sk_wmem_queued
is the TCP send buffer size that we want? I thought it is ->sk_sndbuf...

Thanks for your help!
