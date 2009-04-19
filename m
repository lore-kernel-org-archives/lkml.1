Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbZDSKSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbZDSKSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 06:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZDSKSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 06:18:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbZDSKSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 06:18:36 -0400
Message-ID: <49EAF9D6.1010600@redhat.com>
Date: Sun, 19 Apr 2009 13:15:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>	 <20090408145440.GN12931@elte.hu> <1239203512.4557.2575.camel@laptop>
In-Reply-To: <1239203512.4557.2575.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-04-08 at 16:54 +0200, Ingo Molnar wrote:
>   
>>>  kernel/sched.c                     |    2 -
>>>       
>> Needs the ack of ... oh, never mind - this one is fine i guess ;-)
>>     
>
> Ah, about that. This new preemption hook has slightly different
> requirements than the current preempt-notifiers have (hence the new
> hook), I was wondering if KVM (afaik currently the only preempt-notifier
> consumer) could live with these requirements.
>
> That is, could these be merged?
>   

What are the slight differences in requirements?

KVM wants to run in non-preemptible, interrupts-enabled context.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

