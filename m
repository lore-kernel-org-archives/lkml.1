Return-Path: <linux-kernel-owner+w=401wt.eu-S1765389AbYB1UB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765389AbYB1UB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764982AbYB1T5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:57:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35115 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764772AbYB1T5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:57:37 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5241"; a="987646"
Message-ID: <47C7122E.1000404@qualcomm.com>
Date: Thu, 28 Feb 2008 11:57:34 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org,
       "markh@compro.net >> Mark Hounschell" <markh@compro.net>
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl> <47C6A516.4070707@cfl.rr.com>
In-Reply-To: <47C6A516.4070707@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Peter Zijlstra wrote:
>> My vision on the direction we should take wrt cpu isolation.
>>
>> Next on the list would be figuring out a nice solution to the workqueue
>> flush issue.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> Is it now the intent, not only that I have to enable cpusets in the
> kernel but I will also have to use them in userland to take advantage of
> this.
> 
> And hot-plug too??
> 
> Can I predict that in the future that userland sched_setaffinity will be
> taken away also and be forced to use cpusets?
> 
> And hot-plug too??

Mark,
I bet you won't get any replies (besides mine). And yes this means that you
will have to enable cpusets if Peter's patches go in (looks like they will).
Hot-plug may not be needed unless I convince people to reuse the hot-plug
instead of introducing new notifiers.
I guess we can make some extensions to expose "system" bit just like I did
with "isolated" bit via sysfs. In which case cpusets may not be needed. We'll see.

Max


