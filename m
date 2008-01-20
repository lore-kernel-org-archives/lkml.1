Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYATSYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYATSYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYATSYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:24:25 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43772 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbYATSYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:24:24 -0500
Date: Sun, 20 Jan 2008 12:24:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: Celeron Core
In-reply-to: <fa.LZLUxfR64dAZFPtin9JNet7ieiY@ifi.uio.no>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <479391C9.9020004@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.2Y+LplM9PCtpiAXzv/aJ3Pcnv4Y@ifi.uio.no>
 <fa.OpXJDCw416yeXEvt0cwrupi/qS0@ifi.uio.no>
 <fa.sj34KNXkf9z/ZO3fVJ+CYcgcuCs@ifi.uio.no>
 <fa.qpK4b5H7lkLeIaPtbJKzKV46yFY@ifi.uio.no>
 <fa.WeBRuL3UPPVPESVzfopvVyNcAw4@ifi.uio.no>
 <fa.LZLUxfR64dAZFPtin9JNet7ieiY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Andi Kleen wrote:
>>> Isn't it the case that an idle machine will use
>>> less power when throttled than when not?
>>>     
>> No that is not the case (not even on old CPUs) 
>>   
> Then why would it run cooler?  What generates the heat when not
> throttled?  What stops generating heat when throttled?  And you say this
> happens without reducing power consumption?  I'm not convinced.  I'm a
> long way from that.

I believe that all throttling does is forcibly halt the CPU on a 
particular duty cycle. This will reduce the rate of power consumption, 
but reduces the CPU performance by a greater amount (since even at 100% 
halted the CPU still consumes power) and so actually reduces performance 
per watt. It will spread the heat and power usage produced from a given 
workload task out in time (thus its usefulness in limiting CPU 
temperature) but will consume more power overall.

Real CPU clock throttling schemes like SpeedStep, PowerNow, etc. 
actually do increase performance per watt when they kick in.
