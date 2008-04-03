Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbYDCQUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbYDCQUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYDCQTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:19:54 -0400
Received: from smtp23.orange.fr ([80.12.242.97]:22148 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbYDCQTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:19:54 -0400
X-ME-UUID: 20080403161950122.1DF997000086@mwinf2358.orange.fr
Message-ID: <47F5039D.1070007@cosmosbay.com>
Date: Thu, 03 Apr 2008 18:19:41 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC,PATCH] loopback: calls netif_receive_skb() instead of	netif_rx()
References: <47BDC848.50607@cosmosbay.com> <20080226.182120.183405235.davem@davemloft.net> <47C92F49.4070100@cosmosbay.com> <20080323.032949.194309002.davem@davemloft.net> <47E6A5FD.6060407@cosmosbay.com> <20080331094823.GA11651@elte.hu> <47F0B66C.6080404@cosmosbay.com> <20080331101237.GA12324@elte.hu> <47F1FE0A.9090501@cosmosbay.com> <20080403140600.GA4507@ucw.cz>
In-Reply-To: <20080403140600.GA4507@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek a écrit :
> Hi!
>
>   
>>> the rule on x86 should be something like this: on 4K 
>>> stacks and 64-bit [which have irqstacks] free stack 
>>> space can go as low as 25%. On 8K stacks [which doesnt 
>>>       
> ...
>   
>>   32 bits and 4K stacks (separate irq stacks) : can use 
>>   up to 25% of stack
>>     
>
> I think ingo meant 'up to 75% used'.
>
>
>   
Patch is OK, my english might be a litle bit unsual :)




