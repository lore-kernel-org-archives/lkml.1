Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbXDTUrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbXDTUrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXDTUrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:47:39 -0400
Received: from mail.tmr.com ([64.65.253.246]:43797 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbXDTUri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:47:38 -0400
Message-ID: <462926DF.1030404@tmr.com>
Date: Fri, 20 Apr 2007 16:47:27 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely   Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>	<200704151327.13589.kernel@kolivas.org>	<1176619384.6222.70.camel@Homer.simpson.net>	<46240F98.3020800@bigpond.net.au>	<1176776941.6222.21.camel@Homer.simpson.net>	<20070417034050.GD25513@wotan.suse.de>	<1176782489.13059.15.camel@Homer.simpson.net>	<20070417041420.GF25513@wotan.suse.de> <20070417095140.GB22626@elte.hu>
In-Reply-To: <20070417095140.GB22626@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> ( Lets be cautious though: the jury is still out whether people actually 
>   like this more than the current approach. While CFS feedback looks 
>   promising after a whopping 3 days of it being released [ ;-) ], the 
>   test coverage of all 'fairness centric' schedulers, even considering 
>   years of availability is less than 1% i'm afraid, and that < 1% was 
>   mostly self-selecting. )
> 
All of my testing has been on desktop machines, although in most cases 
they were really loaded desktops which had load avg 10..100 from time to 
time, and none were low memory machines. Up to CFS v3 I thought 
nicksched was my winner, now CFSv3 looks better, by not having stumbles 
under stupid loads.

I have not tested:
   1 - server loads, nntp, smtp, etc
   2 - low memory machines
   3 - uniprocessor systems

I think this should be done before drawing conclusions. Or if someone 
has tried this, perhaps they would report what they saw. People are 
talking about smoothness, but not how many pages per second come out of 
their overloaded web server.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
