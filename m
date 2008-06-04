Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbYFDXlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbYFDXlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYFDXlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:41:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbYFDXlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:41:42 -0400
Message-ID: <484727D3.7090004@redhat.com>
Date: Wed, 04 Jun 2008 19:40:03 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <peterz@infradead.org>, Hideo AOKI <haoki@redhat.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Kernel marker has no performance impact on ia64.
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <4846210E.8080401@redhat.com> <20080604232640.GB8488@Krystal>
In-Reply-To: <20080604232640.GB8488@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
>>> Maybe we could settle for an intermediate solution : I agree with you
>>> that defining the trace points in headers, like you did for the
>>> scheduler, makes the code much cleaner and makes things much easier to
>>> maintain afterward. However, having the trace_mark mechanism underneath
>>> helps a lot in plugging a generic tracer (actually, if we can settle the
>>> marker issue, I've got a kernel tracer, LTTng, that I've been waiting
>>> for quite a while to push to mainline that I would like to post someday).
>> That's good to me.
>> BTW, I'd like to know your plan, would those static inline functions be
>> defined in new headers or marker.h(or other existing headers)?
>>
> 
> Hi Masami,
> 
> What do you think of kernel/sched-trace.h for the scheduler as proposed
> by Peter ? Having these headers close to the c file instrumentation they
> deal with seems to scale maintenance better. Placing all these in one
> big kernel header included everywhere would require to recompile the
> whole kernel when the header is touched, which is, I guess, not what we
> want.

I agree with you, one big kernel header is hard to maintain, especially
by patches :-)

Thanks,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

