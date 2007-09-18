Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbXIROof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbXIROof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXIROoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:44:25 -0400
Received: from mail.tmr.com ([64.65.253.246]:51485 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879AbXIROoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:44:24 -0400
Message-ID: <46EFE3F5.5070201@tmr.com>
Date: Tue, 18 Sep 2007 10:43:01 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel
To: David Miller <davem@davemloft.net>
CC: ytht.net@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.22.6 NETWORKING [IPV4]: Always use source addr in
   skb to reply packet
References: <20070918021617.GA15540@router.lepton.home> <20070917.192044.48396034.davem@davemloft.net>
In-Reply-To: <20070917.192044.48396034.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: lepton <ytht.net@gmail.com>
> Date: Tue, 18 Sep 2007 10:16:17 +0800
> 
>> Hi,
>>   In some situation, icmp_reply and ip_send_reply will send
>>   out packet with the wrong source addr, the following patch
>>   will fix this.
>>
>>   I don't understand why we must use rt->rt_src in the current
>>   code, if this is a wrong fix, please correct me.
>>
>> Signed-off-by: Lepton Wu <ytht.net@gmail.com>
> 
> That the address is wrong is your opinion only :-)

Mine too, since an ICMP reply from an unexpected source IP is likely to 
be logged as a probe and dropped.
> 
> Source address selection is a rather complex topic, and
> here we are definitely purposefully using the source
> address selected by the routing lookup for the reply.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
