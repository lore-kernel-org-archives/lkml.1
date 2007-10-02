Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbXJBWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbXJBWEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXJBWEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:04:42 -0400
Received: from mail.tmr.com ([64.65.253.246]:37249 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbXJBWEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:04:42 -0400
Message-ID: <4702C1AD.3090701@tmr.com>
Date: Tue, 02 Oct 2007 18:09:49 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mel Gorman <mel@skynet.ie>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <1191326858.28962.8.camel@localhost> <20071002121556.GA22864@elte.hu> <20071002172135.GA12182@skynet.ie>
In-Reply-To: <20071002172135.GA12182@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (02/10/07 14:15), Ingo Molnar didst pronounce:
>> * Mel Gorman <mel@csn.ul.ie> wrote:
>>
>>> Dirt. Booting with "profile=sleep,2" is broken in 2.6.23-rc9 and 
>>> 2.6.23-rc8 but working in 2.6.22. I was checking it out as part of a 
>>> discussion in another thread and noticed it broken in -mm as well 
>>> (2.6.23-rc8-mm2). Bisect is in progress but suggestions as to the 
>>> prime candidates are welcome or preferably, pointing out that I'm an 
>>> idiot because I missed twiddling some config change.
>> Mel, does the patch below fix this bug for you? (Note: you will need to 
>> enable CONFIG_SCHEDSTATS=y too.)
>>
> 
> Nice one Ingo - got it first try. The problem commit was
> dd41f596cda0d7d6e4a8b139ffdfabcefdd46528 and it's clear that the code removed
> in this commit is put back by this latest patch.  When applied, profile=sleep
> works as long as CONFIG_SCHEDSTAT is set.
> 
And if it isn't set? I can easily see building a new kernel with stats 
off and forgetting to change the boot options.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
