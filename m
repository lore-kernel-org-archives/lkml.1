Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931Ab0AXBxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0AXBxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 20:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417Ab0AXBxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 20:53:41 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:44116 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0AXBxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 20:53:40 -0500
Date: Sat, 23 Jan 2010 20:53:31 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
In-reply-to: <20100123232133.GA3487@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Message-id: <4B5BA81B.30908@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20100120094103.GA6225@ff.dom.local> <4B58B217.8030001@majjas.com>
 <20100121204133.GB3085@del.dom.local> <4B59E7EB.3050605@majjas.com>
 <20100122215304.GA3105@del.dom.local> <4B5A2362.6000306@majjas.com>
 <20100122230605.GB3105@del.dom.local> <4B5A33D8.90501@majjas.com>
 <20100122234656.GC3105@del.dom.local> <4B5A39BD.8020305@majjas.com>
 <20100123232133.GA3487@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/2010 6:21 PM, Jarek Poplawski wrote:
> On Fri, Jan 22, 2010 at 06:50:21PM -0500, Michael Breuer wrote:
>    
>> When the packets were dropped, there was a different sequence in the
>> log - DISCOVER/OFFER repeated. The "normal" is that the sequence
>> appeared correct and complete - DISCOVER/OFFER/REQUEST/ACK - or
>> INFORM/ACK (vs. INFORM repeatedly sans ACK) as the case may be.
>>      
> Anyway, I'd be intersted if the switch matters here.
>
> Plus one more test: could you try to load sky2 with the parameter:
> "copybreak=1" (the rest as in any recent test, which gave you dmar
> errors; any switch).
>
> Thanks,
> Jarek P.
>    
Ok - will try with and without the copybreak=1 after I'm done bisecting 
2.6.33 rc5 for something unrelated (it'll take a couple of days for each 
unless a crash occurs in less that 48 hours).
