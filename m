Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZL2LgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZL2LgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 06:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZL2LgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 06:36:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51070 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZL2LgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 06:36:17 -0500
Message-ID: <4B39E93D.60605@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 19:34:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
References: <c76f371a0912290249u5bbeee4ckadfc94f5d2df4d8e@mail.gmail.com>
In-Reply-To: <c76f371a0912290249u5bbeee4ckadfc94f5d2df4d8e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Stijn Devriendt wrote:
>> 'inject' event is a very useful feature and it's suggested by Ingo
>> [ See http://lkml.org/lkml/2009/12/28/31 ]
> 
> Is it possible to, instead of injecting a specific inject_event enum,
> pass a type/config pair (+task/cpu?) to inject the value of that
> specific event? Then the HZ could have it's own perf_event type.
> 

Until now, 'inject' event just trigger parameter/query events, if
you need sample cpu/task, you can use other event.

> This integrates better with what I'm struggling with right now:
> counters that are not ever incrementing but rather indicate
> a discrete value inside the kernel that might change both
> up and down. My dynticks knowledge is rather limited but
> if HZ might vary then this approach is definately worth it.
> 

dynticks not touch HZ at all as i know.

Thanks,
Xiao
