Return-Path: <linux-kernel-owner+w=401wt.eu-S1751151AbZK0Gi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbZK0Gi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZK0Gi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:38:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:60257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbZK0Gi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:38:27 -0500
Message-ID: <4B0F73CA.7090804@kernel.org>
Date: Fri, 27 Nov 2009 15:38:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
References: <1259234619.4273.32.camel@twins> <20091126115605.GA15189@elte.hu> <1259239259.4273.82.camel@twins> <4B0F356B.3040206@kernel.org> <20091127045209.GA13914@elte.hu> <4B0F65DD.1090707@kernel.org> <20091127054621.GA25672@elte.hu> <4B0F6B32.4090401@kernel.org> <20091127061319.GA8620@elte.hu> <4B0F6EA9.6070105@kernel.org> <20091127062147.GB22149@elte.hu>
In-Reply-To: <20091127062147.GB22149@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/27/2009 03:21 PM, Ingo Molnar wrote:
>> No, I'm not gonna do that.  Just patches to reorganize code so that 
>> unnecessary conflicts won't occur.  There will be NO functional 
>> changes.
> 
> Not without the other changes - which you want to do too, right?

The extra things I want can stay in a devel branch until notifiers get
cleaned up and it will only be a few patches which aren't very likely
to cause conflicts when it gets exported for linux-next or other
testing branches.

> Please send all sched.c modifications via the scheduler tree. Going
> via other trees is fine when there's agreement by the maintainers -
> but this is one of the rare cases where that's not the case.

Yeah, sure.  So, two patchsets.  One for sched/core doing pure
reorganization without any functional changes.  The other for
sched/notifier (or whatever name you would prefer) which is purely for
development and testing and will not be pushed to Linus unless it
receives notifier framework cleanup.  wq#for-next will pull from
sched/notifier and be exported to linux-next but it will never be
submitted to Linus until sched/notifier is cleaned up.  Am I
understanding it correctly?

Thanks.

-- 
tejun
