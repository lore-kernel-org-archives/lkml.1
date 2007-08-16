Return-Path: <linux-kernel-owner+w=401wt.eu-S1030340AbXHPC1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030340AbXHPC1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765802AbXHPC1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:27:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48673 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765691AbXHPC1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:27:05 -0400
Message-ID: <46C3B5EF.5060409@garzik.org>
Date: Wed, 15 Aug 2007 22:26:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: David Miller <davem@davemloft.net>, mshefty@ichips.intel.com,
       rdreier@cisco.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
References: <46B883B5.8040702@opengridcomputing.com>	<46BB61D0.4090101@opengridcomputing.com>	<46BB89C0.4040303@ichips.intel.com> <20070809.145534.102938208.davem@davemloft.net> <46C310E1.7020503@opengridcomputing.com>
In-Reply-To: <46C310E1.7020503@opengridcomputing.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> 
> 
> David Miller wrote:
>> From: Sean Hefty <mshefty@ichips.intel.com>
>> Date: Thu, 09 Aug 2007 14:40:16 -0700
>>
>>> Steve Wise wrote:
>>>> Any more comments?
>>> Does anyone have ideas on how to reserve the port space without using 
>>> a struct socket?
>>
>> How about we just remove the RDMA stack altogether?  I am not at all
>> kidding.  If you guys can't stay in your sand box and need to cause
>> problems for the normal network stack, it's unacceptable.  We were
>> told all along the if RDMA went into the tree none of this kind of
>> stuff would be an issue.
> 
> I think removing the RDMA stack is the wrong thing to do, and you 
> shouldn't just threaten to yank entire subsystems because you don't like 
> the technology.  Lets keep this constructive, can we?  RDMA should get 
> the respect of any other technology in Linux.  Maybe its a niche in your 
> opinion, but come on, there's more RDMA users than say, the sparc64 
> port.  Eh?

It's not about being a niche.  It's about creating a maintainable 
software net stack that has predictable behavior.

Needing to reach out of the RDMA sandbox and reserve net stack resources 
away from itself travels a path we've consistently avoided.


>> I will NACK any patch that opens up sockets to eat up ports or
>> anything stupid like that.
> 
> Got it.

Ditto for me as well.

	Jeff


