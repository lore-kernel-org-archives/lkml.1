Return-Path: <linux-kernel-owner+w=401wt.eu-S1762762AbXHIXXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762AbXHIXXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXHIXWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:22:50 -0400
Received: from mga06.intel.com ([134.134.136.21]:27744 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752799AbXHIXWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,243,1183359600"; 
   d="scan'208";a="276884806"
Message-ID: <46BBA1C6.9010702@ichips.intel.com>
Date: Thu, 09 Aug 2007 16:22:46 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: swise@opengridcomputing.com, rdreier@cisco.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
References: <46B883B5.8040702@opengridcomputing.com>	<46BB61D0.4090101@opengridcomputing.com>	<46BB89C0.4040303@ichips.intel.com> <20070809.145534.102938208.davem@davemloft.net>
In-Reply-To: <20070809.145534.102938208.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> How about we just remove the RDMA stack altogether?  I am not at all
> kidding.  If you guys can't stay in your sand box and need to cause
> problems for the normal network stack, it's unacceptable.  We were
> told all along the if RDMA went into the tree none of this kind of
> stuff would be an issue.

There are currently two RDMA solutions available.  Each solution has 
different requirements and uses the normal network stack differently. 
Infiniband uses its own transport.  iWarp runs over TCP.

We have tried to leverage the existing infrastructure where it makes sense.

> After TCP port reservation, what's next?  It seems an at least
> bi-monthly event that the RDMA folks need to put their fingers
> into something else in the normal networking stack.  No more.

Currently, the RDMA stack uses its own port space.  This causes a 
problem for iWarp, and is what Steve is looking for a solution for.  I'm 
not an iWarp guru, so I don't know what options exist.  Can iWarp use 
its own address family?  Identify specific IP addresses for iWarp use? 
Restrict iWarp to specific port numbers?  Let the app control the 
correct operation?  I don't know.

Steve merely defined a problem and suggested a possible solution.  He's 
looking for constructive help trying to solve the problem.

- Sean
