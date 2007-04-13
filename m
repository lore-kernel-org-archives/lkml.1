Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXDMTqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXDMTqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXDMTqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:46:04 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3895 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbXDMTqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:46:03 -0400
Message-ID: <461FDDF9.7040503@rtr.ca>
Date: Fri, 13 Apr 2007 15:46:01 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Buytaert_Steven@emc.com
Cc: davidsen@tmr.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: sched_yield proposals/rationale
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com> <20070412133158.GB31455@one.firstfloor.org> <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com> <461EB367.1050405@tmr.com> <585DC2133F7C974F87D4EC432896F1720309F645@CORPUSMX10A.corp.emc.com>
In-Reply-To: <585DC2133F7C974F87D4EC432896F1720309F645@CORPUSMX10A.corp.emc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Buytaert_Steven@emc.com wrote:
>> From: Bill Davidsen
>>
>> And having gotten same, are you going to code up what appears to be a
>> solution, based on this feedback?
> 
> The feedback was helpful in verifying whether there are any arguments against my approach. The real proof is in the pudding.
> 
> I'm running a kernel with these changes, as we speak. Overall system throughput is about up 20%. With 'system throughput' I mean measured performance of a rather large (experimental) system. The patch isn't even 24h old... Also the application latency has improved.

Cool.  You *do know* that there is a brand new CPU scheduler
scheduled to replace the current one for the 2.6.22 Kernel, right?

-ml
