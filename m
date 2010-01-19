Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805Ab0ASUHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0ASUHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632Ab0ASUG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:06:59 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:49213 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0ASUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:06:58 -0500
Date: Tue, 19 Jan 2010 15:06:01 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
In-reply-to: <20100119195933.GA3060@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4B5610A9.7030902@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20100118204658.GC3157@del.dom.local> <4B54CB0D.5070604@majjas.com>
 <20100118212516.GE3157@del.dom.local> <4B54D50C.90608@majjas.com>
 <20100118220814.GG3157@del.dom.local> <20100118221747.GH3157@del.dom.local>
 <4B54E4EF.8080602@majjas.com> <4B554730.6090000@majjas.com>
 <20100119104739.GA9088@ff.dom.local> <4B55D40F.5080509@majjas.com>
 <20100119195933.GA3060@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2010 2:59 PM, Jarek Poplawski wrote:
> On Tue, Jan 19, 2010 at 10:47:27AM -0500, Michael Breuer wrote:
> ...
>    
>> Still get the warning... but now 60 bytes.
>> Jan 19 10:43:50 mail kernel: ------------[ cut here ]------------
>> Jan 19 10:43:50 mail kernel: WARNING: at lib/dma-debug.c:902
>>      
> Thanks for trying this.
> Jarek P.
>    
NP. Let me know what else I can do to help with this one. Note that it 
seems innocuous. I'll continue with the older set and no dmar for now 
and see if I get another crash.
