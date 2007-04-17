Return-Path: <linux-kernel-owner+w=401wt.eu-S1031176AbXDQTny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031176AbXDQTny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031180AbXDQTny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:43:54 -0400
Received: from mail.tmr.com ([64.65.253.246]:41110 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031176AbXDQTnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:43:53 -0400
Message-ID: <4625220C.2060201@tmr.com>
Date: Tue, 17 Apr 2007 15:37:48 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mark Lord <lkml@rtr.ca>
CC: Buytaert_Steven@emc.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: sched_yield proposals/rationale
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com> <20070412133158.GB31455@one.firstfloor.org> <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com> <461EB367.1050405@tmr.com> <585DC2133F7C974F87D4EC432896F1720309F645@CORPUSMX10A.corp.emc.com> <461FDDF9.7040503@rtr.ca>
In-Reply-To: <461FDDF9.7040503@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Buytaert_Steven@emc.com wrote:
>>> From: Bill Davidsen
>>>
>>> And having gotten same, are you going to code up what appears to be a
>>> solution, based on this feedback?
>>
>> The feedback was helpful in verifying whether there are any arguments 
>> against my approach. The real proof is in the pudding.
>>
>> I'm running a kernel with these changes, as we speak. Overall system 
>> throughput is about up 20%. With 'system throughput' I mean measured 
>> performance of a rather large (experimental) system. The patch isn't 
>> even 24h old... Also the application latency has improved.
> 
> Cool.  You *do know* that there is a brand new CPU scheduler
> scheduled to replace the current one for the 2.6.22 Kernel, right?
> 
Having tried both nicksched and Con's fair sched on some normal loads, 
as opposed to benchmarks, I sure hope Linus changes his mind about 
having several schedulers in the kernel. The "one perfect and 
self-adjusting scheduler" isn't here yet.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
