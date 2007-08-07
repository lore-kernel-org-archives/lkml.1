Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbXHGI1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbXHGI1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbXHGI12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:27:28 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:43384 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXHGI11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:27:27 -0400
Message-ID: <46B82CDD.7020503@free.fr>
Date: Tue, 07 Aug 2007 10:27:09 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: Old -rt patches
References: <46B0B7A4.8060805@free.fr>  <46B6E210.9090502@free.fr> <1186466508.22044.8.camel@imap.mvista.com>
In-Reply-To: <1186466508.22044.8.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:

> John Sigler wrote:
> 
>> Would anyone care to comment?
> 
> I'm not sure if this is the answer that you're looking for, but yes you
> certainly will find fixed bug is older version of the tree.

I am not a kernel hacker, therefore I can only imagine how complex it is 
to bring real-time to Linux. For some reason, I had come to believe that 
the case of a single CPU without dynticks had been "solved" in the more 
recent kernels (say 2.6.20), and that development had moved on, and was 
now active in more "complex" areas like SMP/multi-core, dynticks, etc.

>> Perhaps I could also test a different strategy, such as xenomai?
>> http://www.xenomai.org/
> 
> If it's a kernel bug it's not going to matter if you use a xenomai skin
> or not.. If you use some other real time layer that might fix it ..

*If* it is a bug in the -rt patch, then Adeos/Xenomai coupled with a 
vanilla Linux kernel should not be affected by the same bug. Unless my 
logic is broken somewhere.

> you really need to test your app on a current version of the kernel ..
> We as developers generally don't support out dated trees..

This is the part I don't understand. I work for a tiny company with 
limited resources. It's infeasible for me to track every new kernel 
release and upgrade every time. I need to pick a kernel version that has 
the functionality we need, test it thoroughly with my app, and then 
never touch that kernel again.

Unless I am mistaken, some people (like Thomas) have been deploying 
systems based on PREEMPT_RT (or just -hrt) in indutrial settings for a 
long time. (As far back as 2.6.15?) Obviously many bugs have been fixed 
since then, which means that these versions contained many bugs.

How does one react when an important bug in found in a system that is 
already in the field? Do they provide a way to upgrade the kernel (like 
consumer-grade network routers)? Do they replace the complete system?

Regards.
