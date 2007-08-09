Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXHIVzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXHIVzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXHIVzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:55:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58022
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753845AbXHIVzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:55:40 -0400
Date: Thu, 09 Aug 2007 14:55:34 -0700 (PDT)
Message-Id: <20070809.145534.102938208.davem@davemloft.net>
To: mshefty@ichips.intel.com
Cc: swise@opengridcomputing.com, rdreier@cisco.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <46BB89C0.4040303@ichips.intel.com>
References: <46B883B5.8040702@opengridcomputing.com>
	<46BB61D0.4090101@opengridcomputing.com>
	<46BB89C0.4040303@ichips.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sean Hefty <mshefty@ichips.intel.com>
Date: Thu, 09 Aug 2007 14:40:16 -0700

> Steve Wise wrote:
> > Any more comments?
> 
> Does anyone have ideas on how to reserve the port space without using a 
> struct socket?

How about we just remove the RDMA stack altogether?  I am not at all
kidding.  If you guys can't stay in your sand box and need to cause
problems for the normal network stack, it's unacceptable.  We were
told all along the if RDMA went into the tree none of this kind of
stuff would be an issue.

These are exactly the kinds of problems for which people like myself
were dreading.  These subsystems have no buisness using the TCP port
space of the Linux software stack, absolutely none.

After TCP port reservation, what's next?  It seems an at least
bi-monthly event that the RDMA folks need to put their fingers
into something else in the normal networking stack.  No more.

I will NACK any patch that opens up sockets to eat up ports or
anything stupid like that.
