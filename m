Return-Path: <linux-kernel-owner+w=401wt.eu-S936315AbXGRTE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936315AbXGRTE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935804AbXGRTDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:03:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:43820 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbXGRTDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:03:50 -0400
Date: Wed, 18 Jul 2007 12:02:45 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <1184741938.12353.484.camel@chaos>
Message-ID: <Pine.LNX.4.63.0707181159010.3157@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> 
 <1184662429.12353.426.camel@chaos>  <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
  <1184703427.12353.476.camel@chaos>  <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
  <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain> 
 <1184738755.12353.481.camel@chaos> <1184741938.12353.484.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 18 Jul 2007 19:02:45.0072 (UTC) FILETIME=[39723500:01C7C96E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Thomas Gleixner wrote:

> On Wed, 2007-07-18 at 08:05 +0200, Thomas Gleixner wrote:
>> On Tue, 2007-07-17 at 16:58 -0700, Jeremy Katz wrote:
>>
>>> EFLAGS: 00010246   (2.6.22.1-WR1.4aq_cgl #2)
>>
>> Hmm. Are there any other patches on that kernel ?

Just hrt6 and your proposed fix.  The build system I'm using appends the 
WR1.4aq_cgl, but isn't patching anything.

>> Is there a chance that you can whip up a test program which is not
>> secret sauce ?

I've taken a brief stab at it, but haven't produced anything successful 
thus far.  Unfortunately, I don't even have complete source to the test 
code, and the people that do have expressed an inability to release it due 
to contractual obligations.

>> Also can you please enable CONFIG_PROVE_LOCKING, which might catch any
>> locking problem, which might be related to this.
>
> Another test: Can you please disable CONFIG_SCHED_SMT to narrow it down
> further ?

I'll try both of these.

Jeremy
