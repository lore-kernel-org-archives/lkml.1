Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbXCEXEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbXCEXEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXCEXEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:04:54 -0500
Received: from mail.tmr.com ([64.65.253.246]:58515 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbXCEXEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:04:50 -0500
Message-ID: <45ECA239.5000306@tmr.com>
Date: Mon, 05 Mar 2007 18:05:29 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: jos poortvliet <jos@mijnkamer.nl>
CC: ck@vds.kolivas.org, Gene Heskett <gene.heskett@gmail.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free   interactive
 cpu scheduler
References: <200703041800.53360.kernel@kolivas.org>	<200703050049.50149.kernel@kolivas.org> <20070304143638.GG943@1wt.eu> <200703041708.54953.jos@mijnkamer.nl>
In-Reply-To: <200703041708.54953.jos@mijnkamer.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jos poortvliet wrote:
> Op Sunday 04 March 2007, schreef Willy Tarreau:
>> Hi Con !
>>> This was designed to be robust for any application since linux demands a
>>> general purpose scheduler design, while preserving interactivity, instead
>>> of optimising for one particular end use.
>> Well, I haven't tested it yet, but your design choices please me. As you
>> know, I've been one of those encountering big starvation problems with
>> the original scheduler, making 2.6 unusable for me in many situations. I
>> welcome your work and want to thank you for the time you spend trying to
>> fix it.
>>
>> Keep up the good work,
>> Willy
>>
>> PS: I've looked at your graphs, I hope you're on the way to something
>> really better than the 21 first 2.6 releases !
> Well, imho his current staircase scheduler already does a better job compared 
> to mainline, but it won't make it in (or at least, it's not likely). So we 
> can hope this WILL make it into mainline, but I wouldn't count on it.
> 
Wrong problem, what is really needed is to get CPU scheduler choice into 
mainline, just as i/o scheduler finally did. Con has noted that for some 
loads this will present suboptimal performance, as will his -ck patches, 
as will the default scheduler. Instead of trying to make ANY one size 
fit all, we should have a means to select, at runtime, between any of 
the schedulers, and preferably to define an interface by which a user 
can insert a new scheduler in the kernel (compile in, I don't mean 
plugable) with clear and well defined rules for how that can be done.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
