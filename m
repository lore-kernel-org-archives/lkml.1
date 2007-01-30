Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbXA3BiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbXA3BiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXA3BiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:38:05 -0500
Received: from ironport-out.pppoe.ca ([206.248.154.186]:2272 "EHLO
	ironport-out.pppoe.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbXA3BiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:38:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwPAL4wvkVBJ8TuX2dsb2JhbACORRUPKQ
X-IronPort-AV: i="4.13,254,1167627600"; 
   d="scan'208"; a="70236410:sNHT16719888"
Message-ID: <45BEA162.3030204@teksavvy.com>
Date: Mon, 29 Jan 2007 20:37:38 -0500
From: Yavuz Onder <yavuz@teksavvy.com>
Reply-To: yavuz@teksavvy.com
Organization: Whatever ISP
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: yavuz@teksavvy.com
Subject: Re: 2.6.19.2: bad reads/writes from/to CMOS clock
References: <9e18e56a85195bf4a507163df8e2f62e@teksavvy.com>
In-Reply-To: <9e18e56a85195bf4a507163df8e2f62e@teksavvy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have since found out that SMP kernels should(must?) have Enhanced RTC 
support built-in.

It is stated in kernel config help for Enhanced RTC support, and I found 
a number of references on the net as well.

Now I wonder why selecting SMP does not set Enhanced RTC support to "Y" 
automatically?

I am building a kernel right now, and will monitor for a week or so, 
then come back and report if it removes the problem.

Yavuz

yavuz@teksavvy.com wrote:
> Hi everyone,
>
> I am running 2.6.19.2 kernel from kernel.org.
>
> This is my first SMP kernel. 
>
> The problem I describe below has not happend with non-SMP kernels ever...
>
> I have installed my new AMD64 x2 4800 CPU just a few days ago. My mobo is Asus A8N SLI
> (Nvidia chipset).
>
> My problem with this new setup is that my CMOS clock is thrown off by varying 
> amounts of time. I have seen system times as long as ten months into future, and as
> long as 25 days in the past. At the moment my system clock has correct 
> hh:mm:ss, but it shows the date Jan 1st, instead of correct 25th.
>
> In last few days have systematically checked CMOS clock after shutdown and before
> boot-up.
>
> I have observed CMOS clock set to a wrong value, immediately after shutdown. 
> I also ended up with a wrong system time following a boot after verifying 
> correctness of the CMOS clock.
>
> Problem does not happen 100% of the time. But 6-7 times in a week is bad 
> enough. 
>
> I searched mailing list archives, and found some NMI-RTC race condition discussion, 
> and some other discussions about timers not running, clock ticks being missed
> etc. But they were all at least one year old. The fixes to those should have found
> their way into 2.6.19 kernels.
>
> I would appreciate any ideas on how to follow-up on this problem. 
>
> I am eager to try things, collect data as needed. Just tell me what to do.
>
> Thanks in advance.
>
>
>
>
> Yavuz Onder
>
>   
