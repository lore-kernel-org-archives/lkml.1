Return-Path: <linux-kernel-owner+w=401wt.eu-S1765445AbXIMS7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765445AbXIMS7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbXIMS7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:59:23 -0400
Received: from smtp.opengridcomputing.com ([71.42.183.126]:58826 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbXIMS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:59:22 -0400
Message-ID: <46E98889.1080706@opengridcomputing.com>
Date: Thu, 13 Sep 2007 13:59:21 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
References: <adahclymos8.fsf@cisco.com> <46E97BB0.9030106@opengridcomputing.com> <46E987E0.2010605@garzik.org>
In-Reply-To: <46E987E0.2010605@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeff Garzik wrote:
> Steve Wise wrote:
>> I was about to post v2 of my patch to avoid port space collisions with 
>> the native stack.  Can we get that 2.6.24?  It is high priority IMO. 
>> I've tried to solicit review on it, but I think folks are reluctant... 
>> ;-)
> 
> Well, if it involves /sharing/ port space with the native stack, i.e. 
> where port 1234 is IB but 1235 is Linux, pretty much all the networking 
> devs have NAK'd that approach AFAICS.
> 

Jeff, I posted a fix that doesn't do this.  No port sharing.  The iwarp 
device will use its own ip address and subnet to avoid collisions.  You 
should review the patch when I post v2.

Thanks,

Steve.
