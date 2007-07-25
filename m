Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbXGYMvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbXGYMvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXGYMvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:51:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:38128 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXGYMvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:51:15 -0400
Message-ID: <46A7473E.6010807@qumranet.com>
Date: Wed, 25 Jul 2007 15:51:10 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/3] SCHED: Generic hooks for trapping task preemption
References: <11853673872732-git-send-email-avi@qumranet.com> <11853673871109-git-send-email-avi@qumranet.com> <20070725124911.GC6841@elte.hu>
In-Reply-To: <20070725124911.GC6841@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 25 Jul 2007 15:51:11 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> This adds a general mechanism whereby a task can request the scheduler 
>> to notify it whenever it is preempted or scheduled back in.  This 
>> allows the task to swap any special-purpose registers like the fpu or 
>> Intel's VT registers.
>>     
>
> ok, this looks very clean, i've added it to my scheduler tree. You've 
> tested this with KVM, on both 32-bit and 64-bit, correct?
>
>   

The previous iteration.  I'll do a run now to make sure it hasn't regressed.

Note that only the first patch will apply to -linus.  The others depend
on a small change that isn't there.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

