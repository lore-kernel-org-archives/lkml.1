Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503Ab0AVXuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0AVXuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234Ab0AVXug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:50:36 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:59708 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0AVXuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:50:35 -0500
Date: Fri, 22 Jan 2010 18:50:21 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
In-reply-to: <20100122234656.GC3105@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Message-id: <4B5A39BD.8020305@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20100120094103.GA6225@ff.dom.local> <4B58B217.8030001@majjas.com>
 <20100121204133.GB3085@del.dom.local> <4B59E7EB.3050605@majjas.com>
 <20100122215304.GA3105@del.dom.local> <4B5A2362.6000306@majjas.com>
 <20100122230605.GB3105@del.dom.local> <4B5A33D8.90501@majjas.com>
 <20100122234656.GC3105@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2010 6:46 PM, Jarek Poplawski wrote:
> On Fri, Jan 22, 2010 at 06:25:12PM -0500, Michael Breuer wrote:
>    
>
> You wrote earlier:
>    
>> [...] Also, there is always a dhcp exchange of some sort
>> preceding the event.
>>      
> So, I'm not sure there was "3) Normal DHCP traffic." if the switch
> could drop DHCP packets in some buggy conditions. Anyway, let's try
> the new one with really "3) Normal DHCP traffic.", I hope.
>
> Jarek P.
>    
When the packets were dropped, there was a different sequence in the log 
- DISCOVER/OFFER repeated. The "normal" is that the sequence appeared 
correct and complete - DISCOVER/OFFER/REQUEST/ACK - or INFORM/ACK (vs. 
INFORM repeatedly sans ACK) as the case may be.
