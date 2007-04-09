Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbXDIMQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbXDIMQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXDIMQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:16:16 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:41978 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbXDIMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:16:15 -0400
Message-ID: <461A2E39.8060106@gmail.com>
Date: Mon, 09 Apr 2007 14:14:49 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
References: <200703290237.38777.kernel@kolivas.org>	 <200704071423.47790.gene.heskett@gmail.com>	 <20070407185220.GA31725@elte.hu>	 <200704071630.25830.gene.heskett@gmail.com>	 <20070408104125.GB11123@elte.hu>  <461939A4.2020305@gmail.com> <1176092598.6355.22.camel@Homer.simpson.net>
In-Reply-To: <1176092598.6355.22.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2007 06:23 AM, Mike Galbraith wrote:

> On Sun, 2007-04-08 at 20:51 +0200, Rene Herman wrote:

>> On 04/08/2007 12:41 PM, Ingo Molnar wrote:

>>>  commit 5ce74abe788a26698876e66b9c9ce7e7acc25413
>>>  Author: Mike Galbraith <efault@gmx.de>
>>>  Date:   Mon Apr 10 22:52:44 2006 -0700
>>>
>>>      [PATCH] sched: fix interactive task starvation
>>>
>>> (and a few smaller tweaks since then too.)
>>>
>>> and that change from Mike responded to a testcase. Mike's latest changes 
>>> (the ones you just tested) were mostly driven by actual testcases too, 
>>> which measured long-term timeslice distribution fairness.
>> 
>> Ah yes, that one. Here's the next one in that series:
>>
>> commit f1adad78dd2fc8edaa513e0bde92b4c64340245c
>> Author: Linus Torvalds <torvalds@g5.osdl.org>
>> Date:   Sun May 21 18:54:09 2006 -0700
>>
>>      Revert "[PATCH] sched: fix interactive task starvation"
>>
>> It personally had me wonder if _anyone_ was testing this stuff...
> 
> Well of course not.  Making random untested changes, and reverting
> them later is half the fun of kernel development.

The point ofcourse is that the very example Molnar quoted as an example 
of responsible, testcase driven development was in fact hugely broken 
and sat in the tree that way for 4 rc's.

To me, the example rather serves as confirmation of what Kolivas has 
been saying; endlessly tweaking the tweaks isn't going anywhere. The 
minute you tweak A, tweak B over there in corner C-Sharp falls flat on 
its face.

Computers are horribly stupid and tend to fail most situations their 
smart human programmers didn't specifically tell them about. If, as in 
the case of a scheduler, the real-world demands on a piece of software 
are so diverse that you cannot tell them about all possible situations 
specifically, the only workable solution is to make them _predictable_ 
so that when hitting one of those special situations, the smart human 
using the computer at least gets to know how to intervene if he feels 
inclined to do so.

This turned into an interactivity thing, and while interactivity is in 
fact better for a large majority of testers, that isn't what Kolivas' 
scheduler is about. It's about predictability and leaving the dead-end 
road of these endlesss tweaks, which then break previous tweaks, rinse, 
repeat.

It's unfortunate that Kolivas is having health problems currently, but I 
certainly do hope that his scheduler finds its way into _a_ -rc1. He 
said it was done...

Rene.

