Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZK0GQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZK0GQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZK0GQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:16:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:60834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbZK0GQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:16:34 -0500
Message-ID: <4B0F6EA9.6070105@kernel.org>
Date: Fri, 27 Nov 2009 15:16:09 +0900
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
References: <20091126102936.GA1196@elte.hu> <1259231565.4273.31.camel@twins> <1259234619.4273.32.camel@twins> <20091126115605.GA15189@elte.hu> <1259239259.4273.82.camel@twins> <4B0F356B.3040206@kernel.org> <20091127045209.GA13914@elte.hu> <4B0F65DD.1090707@kernel.org> <20091127054621.GA25672@elte.hu> <4B0F6B32.4090401@kernel.org> <20091127061319.GA8620@elte.hu>
In-Reply-To: <20091127061319.GA8620@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/27/2009 03:13 PM, Ingo Molnar wrote:
>>> My position on this is rather clear: i want no new callbacks and no 
>>> changes to callbacks in the scheduler until this situation is cleaned 
>>> up. Five callback sites are _way_ too much - so if you want to add 
>>> callbacks or change them, please clean it up and improve it first.
>>
>> Even changes which cause no functional differences? [...]
> 
> Such as enabling preempt notifiers unconditionally? That's a functional 
> change - it turns a so-far optional callback into an essentially 
> mandatory one.

No, I'm not gonna do that.  Just patches to reorganize code so that
unnecessary conflicts won't occur.  There will be NO functional
changes.

-- 
tejun
