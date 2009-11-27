Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZK0GB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZK0GB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZK0GB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:01:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:44846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZK0GB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:01:57 -0500
Message-ID: <4B0F6B32.4090401@kernel.org>
Date: Fri, 27 Nov 2009 15:01:22 +0900
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
References: <20091126095154.GE32275@elte.hu> <4B0E5458.30303@kernel.org> <20091126102936.GA1196@elte.hu> <1259231565.4273.31.camel@twins> <1259234619.4273.32.camel@twins> <20091126115605.GA15189@elte.hu> <1259239259.4273.82.camel@twins> <4B0F356B.3040206@kernel.org> <20091127045209.GA13914@elte.hu> <4B0F65DD.1090707@kernel.org> <20091127054621.GA25672@elte.hu>
In-Reply-To: <20091127054621.GA25672@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/27/2009 02:46 PM, Ingo Molnar wrote:
> Other code will benefit from it though, such as the page fault callbacks 
> i already mentioned.
> 
> My position on this is rather clear: i want no new callbacks and no 
> changes to callbacks in the scheduler until this situation is cleaned 
> up. Five callback sites are _way_ too much - so if you want to add 
> callbacks or change them, please clean it up and improve it first.

Even changes which cause no functional differences?  It's just
logistics at that point and I'll only be pushing the actual changes
(addition of wakeup/sleep callbacks) to linux-next so that different
stages of workqueue changes can receive some amount of testing.  If
you don't want that in sched development tree, I can maintain a
temporary branch for linux-next testing but I really can't see what
will be the benefit of doing things that way.

Thanks.

-- 
tejun
