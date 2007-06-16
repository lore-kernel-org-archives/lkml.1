Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXFPNVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXFPNVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 09:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXFPNVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 09:21:41 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:49974 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbXFPNVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 09:21:40 -0400
Message-ID: <4673E3D9.2020300@linux.vnet.ibm.com>
Date: Sat, 16 Jun 2007 18:51:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: malc <av1474@comtv.ru>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] sched: accurate user accounting
References: <200703251159.03616.kernel@kolivas.org> <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org> <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru> <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru> <20070614204253.GA14076@elte.hu> <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru> <20070614211828.GA21243@elte.hu> <Pine.LNX.4.64.0706150129430.3526@linmac.oyster.ru> <46720B19.5000006@linux.vnet.ibm.com> <Pine.LNX.4.64.0706151002530.2175@linmac.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0706151002530.2175@linmac.oyster.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

malc wrote:
> On Fri, 15 Jun 2007, Balbir Singh wrote:
> 
>> malc wrote:
>>> On Thu, 14 Jun 2007, Ingo Molnar wrote:
>>>
> 
> [..snip..]
> 
>>>
>>> Now integral load matches the one obtained via the "accurate" method.
>>> However the report for individual cores are of by around 20% percent.
>>>
>>
>> I think I missed some of the context, is the accounting of individual
>> tasks
>> or cpustat values off by 20%? I'll try and reproduce this problem.
> 
> Neither actually, the individual core idle times reported via `/proc/stat'
> are off by 20 percent, one over estimates and the other under estimates
> and the sum is right on the mark.
> 

Interesting, the idle time accounting (done from account_system_time())
has not changed. Has your .config changed? Could you please send
it across. I've downloaded apc and I am trying to reproduce your problem.

>>
>> Could you provide more details on the APC tool that you are using -- I
>> do not understand the orange and yellow lines, do they represent system
>> and user time?
> 
> It's somewhat documented on the page: http://www.boblycat.org/~malc/apc
> Anyway the left bar is based on information from `/proc/stat' the right
> one is derived from the kernel module that just times how much time was
> spent in idle handler. The graphs: red - `/proc/stat', yellow - module.
> 
>> NOTE: There is some inconsistency in the values reported by /usr/bin/time
>> (getrusage) and values reported in /proc or through delay accounting.
> 
> I don't really use `getrusage'.
> 

Tools like /usr/bin/time do.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
