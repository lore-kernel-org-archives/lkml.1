Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbXIRRYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbXIRRYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760301AbXIRRXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:23:39 -0400
Received: from smtp.opengridcomputing.com ([71.42.183.126]:56850 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760269AbXIRRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:23:36 -0400
Message-ID: <46F00993.9080706@opengridcomputing.com>
Date: Tue, 18 Sep 2007 12:23:31 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Sean Hefty <sean.hefty@intel.com>
CC: rdreier@cisco.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH] RDMA/CMA: Use neigh_event_send() to initiate neighbour
 discovery.
References: <20070912100025.3190.89259.stgit@dell3.ogc.int> <000101c7f568$9275b520$ff0da8c0@amr.corp.intel.com>
In-Reply-To: <000101c7f568$9275b520$ff0da8c0@amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once this is applied upstream, I can pull it back in to ofed-1.2.5 and 
ofed-1.3.

Steve.

Sean Hefty wrote:
>> RDMA/CMA: Use neigh_event_send() to initiate neighbour discovery.
>>
>> Calling arp_send() to initiate neighbour discovery (ND) doesn't do the
>> full ND protocol.  Namely, it doesn't handle retransmitting the arp
>> request if it is dropped. The function neigh_event_send() does all this.
>> Without doing full ND, rdma address resolution fails in the presence of
>> dropped arp bcast packets.
>>
>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> 
> Acked-by: Sean Hefty <sean.hefty@intel.com>
> 
> Roland - can you please queue this up for 2.6.24?
