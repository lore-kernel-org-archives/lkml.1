Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbZKZKop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbZKZKop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZKZKoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:44:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:46789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZKZKon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:44:43 -0500
Message-ID: <4B0E5C06.8080500@kernel.org>
Date: Thu, 26 Nov 2009 19:44:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au> <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org> <20091126092631.GA17253@elte.hu> <4B0E4EFB.2070705@kernel.org> <20091126095154.GE32275@elte.hu> <4B0E5458.30303@kernel.org> <20091126102936.GA1196@elte.hu>
In-Reply-To: <20091126102936.GA1196@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

11/26/2009 07:29 PM, Ingo Molnar wrote:
> That could be done with just two callbacks - one for sched-out, one for 
> sched-in.
> 
> The best way to do that would be to use two TRACE_EVENT() callbacks, 
> make them unconditional and register to them. (with wrappers to make it 
> all convenient to use)
> 
> This requires some work but needs to be done.

Thought about that but trace events and scheduler callbacks have very
different trigger enable/disable conditions.  I couldn't think of a
way to do both in reasonably efficient manner.  Although they both are
notification mechanisms, they do have pretty different requirements
and I'm not quite sure whether unifying them is a good idea.  Of
course if you have an idea to do both efficiently, no reason not to do
it.

Thanks.

-- 
tejun
