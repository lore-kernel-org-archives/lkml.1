Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbXHPOJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbXHPOJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbXHPOI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:08:59 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:32869 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757118AbXHPOI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:08:58 -0400
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 10:08:58 EDT
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
	from the host TCP port space.
From: Tom Tucker <tom@opengridcomputing.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Steve Wise <swise@opengridcomputing.com>,
       David Miller <davem@davemloft.net>, mshefty@ichips.intel.com,
       rdreier@cisco.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
In-Reply-To: <46C3B5EF.5060409@garzik.org>
References: <46B883B5.8040702@opengridcomputing.com>
	 <46BB61D0.4090101@opengridcomputing.com>
	 <46BB89C0.4040303@ichips.intel.com>
	 <20070809.145534.102938208.davem@davemloft.net>
	 <46C310E1.7020503@opengridcomputing.com>  <46C3B5EF.5060409@garzik.org>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 08:43:11 -0500
Message-Id: <1187271791.4685.9.camel@trinity.ogc.int>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 22:26 -0400, Jeff Garzik wrote:

[...snip...]

> > I think removing the RDMA stack is the wrong thing to do, and you 
> > shouldn't just threaten to yank entire subsystems because you don't like 
> > the technology.  Lets keep this constructive, can we?  RDMA should get 
> > the respect of any other technology in Linux.  Maybe its a niche in your 
> > opinion, but come on, there's more RDMA users than say, the sparc64 
> > port.  Eh?
> 
> It's not about being a niche.  It's about creating a maintainable 
> software net stack that has predictable behavior.

Isn't RDMA _part_ of the "software net stack" within Linux? Why isn't
making RDMA stable, supportable and maintainable equally as important as
any other subsystem? 

> 
> Needing to reach out of the RDMA sandbox and reserve net stack resources 
> away from itself travels a path we've consistently avoided.
> 
> 
> >> I will NACK any patch that opens up sockets to eat up ports or
> >> anything stupid like that.
> > 
> > Got it.
> 
> Ditto for me as well.
> 
> 	Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

