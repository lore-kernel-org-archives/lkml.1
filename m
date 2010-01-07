Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509Ab0AGSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0AGSle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497Ab0AGSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:41:31 -0500
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:47513 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab0AGSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:41:26 -0500
Date: Thu, 07 Jan 2010 13:40:53 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
In-reply-to: <20100107183545.GA3208@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4B462AB5.3040405@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B455C62.6030504@majjas.com> <20100106205343.5460d658@nehalam>
 <4B4571D5.30002@majjas.com> <4B457711.1040008@majjas.com>
 <4B458B36.6050509@majjas.com> <20100107074756.GB6258@ff.dom.local>
 <4B459368.2000503@majjas.com> <4B45F841.8030407@majjas.com>
 <20100107180114.GB3088@del.dom.local> <4B4625BD.3070202@majjas.com>
 <20100107183545.GA3208@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/2010 1:35 PM, Jarek Poplawski wrote:
> On Thu, Jan 07, 2010 at 01:19:41PM -0500, Michael Breuer wrote:
>    
>> On 1/7/2010 1:01 PM, Jarek Poplawski wrote:
>>      
>>> On Thu, Jan 07, 2010 at 10:05:37AM -0500, Michael Breuer wrote:
>>>        
>>>> Bad news - crashed about an hour after I wrote this email - under
>>>> load - same crash as before. Network watchdog... lots of attempts to
>>>> reset the adapter... then hw watchdog rebooted the system.
>>>>          
>>> It's a pity. Anyway, I'd be still interested in CONFIG_PACKET_MMAP off
>>> if you find time.
>>>
>>> Jarek P.
>>>        
>> Ok - any particular patch set to try with? I'm going to start with a
>> clean tree using the latest 2.6.32 from git (tried 2.6.33-rc3, but
>> can't get a usable console... will look at that later.)
>>      
> My "Berck E. Nash" and Stephen's "pskb_may_pull" sky2 patches. (BTW,
> could you remind if it worked any better with 2.6.31 or earlier?)
>
> Jarek P.
>    
   Never tried earlier than 2.6.31 - new machine. I had a bunch of 
issues on 2.6.31, including sky2 DMAR errors... so probably not a 2.6.32 
regression.
