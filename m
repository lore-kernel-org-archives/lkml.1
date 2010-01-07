Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964Ab0AGTz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0AGTz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927Ab0AGTz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:55:57 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:50316 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0AGTz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:55:56 -0500
Date: Thu, 07 Jan 2010 14:55:22 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
In-reply-to: <20100107193607.GC3208@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4B463C2A.2090209@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B457711.1040008@majjas.com> <4B458B36.6050509@majjas.com>
 <20100107074756.GB6258@ff.dom.local> <4B459368.2000503@majjas.com>
 <4B45F841.8030407@majjas.com> <20100107180114.GB3088@del.dom.local>
 <4B4625BD.3070202@majjas.com> <20100107183545.GA3208@del.dom.local>
 <4B462B3C.90506@majjas.com> <20100107185040.GB3208@del.dom.local>
 <20100107193607.GC3208@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/2010 2:36 PM, Jarek Poplawski wrote:
> On Thu, Jan 07, 2010 at 07:50:40PM +0100, Jarek Poplawski wrote:
>    
>>> Going to rerun with these patches and with and without MMAP. Will
>>> also retry both with jumbo frames if possible.
>>>        
>> If MMAP then some "alternative" too. But first no MMAP.
>>      
> Another things IMHO worth to try: a sky2 module parameter
> "disable_msi=1", and CONFIG_DMAR off.
>
> Jarek P.
>    
Ok - that'd be with or without MMAP enabled? (note that so-far, without 
MMAP I'm not seeing any errors - throughput is running about half what I 
was seeing with MMAP enabled (before crashing that is). CPU is also way 
busier (also to be expected). One other observation - I had been seeing 
lots of DNS errors - IPV6 related format errors I really didn't think 
much of it as they were mostly .ru and seemed spam-related, but now I 
don't see any. Haven't updated bind; doubt the world has changed - so 
perhaps this is related to the network issue.
