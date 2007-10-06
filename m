Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXJFRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXJFRbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 13:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbXJFRbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 13:31:05 -0400
Received: from mail.tmr.com ([64.65.253.246]:40879 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbXJFRbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 13:31:03 -0400
Message-ID: <4707C795.7030507@tmr.com>
Date: Sat, 06 Oct 2007 13:36:21 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
CC: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <m3wsu2u7y6.fsf@bigip.mine.nu>
In-Reply-To: <m3wsu2u7y6.fsf@bigip.mine.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Chouquet-Stringer wrote:
>          Hey there,
> 
> I've seen the changes you made in commit b6a2fea39318 and I guess they
> might be responsible for my xargs breakage...
> 
> In the kernel source tree, if I run a stupid find | xargs ls, I now get
> this:
> xargs: ls: Argument list too long
> 
> Which is kind of annoying but I can work around it though make distclean in
> my kernel tree dies with the same symptom (aka -E2BIG).
> 
You can work around it many ways, using the options provided for xargs 
or using ls directly being among them.
    find . -ls

I don't see it with 2.6.23-rc8-git3 so it may be related to xargs 
version as well, I have 4.2.27 in FC6.

> I run a vanilla 2.6.23-rc9 (Linux version 2.6.23-rc9 (mchouque@shookaylt)
> (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #1 Tue Oct 2 08:13:47 EDT
> 2007) on FC7...
> 
> Let me know if I can do anything.  I'm going to try to bisect the problem
> after I recompile the kernel without this patch...
> 
> Best,
> Mathieu
> 
> torvalds@linux-foundation.org (Linus Torvalds) writes:
>> I said I was hoping that -rc8 was the last -rc, and I hate doing this, but 
>> we've had more changes since -rc8 than we had in -rc8. And while most of 
>> them are pretty trivial, I really couldn't face doing a 2.6.23 release and 
>> take the risk of some really stupid brown-paper-bag thing.
>> [...]
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
