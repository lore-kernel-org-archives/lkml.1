Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZLHIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZLHIIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZLHIIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:08:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:22564 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZLHIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:08:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mmX8Drlr70dENj89dhHUz0Lqc2ghuyTQLiEVela05YN/YaDhDxMNzBQTcDd5EABu/d
         QyX4wgCVoBjTdmpkvSHaIXmS4peoTLMGK6W8LBiykX7hFW88gZjdvDjWOD7vhjwAzk0N
         Wj+IIkIK+jug9DN5UZWpDYCrcBNMRbOkMzYHM=
Date: Tue, 8 Dec 2009 09:08:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] tracing: Extract duplicate
	ftrace_raw_init_event_foo()
Message-ID: <20091208080853.GE4989@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC48C.7080603@cn.fujitsu.com> <20091208073042.GA4989@nowhere> <4B1E0509.5070102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E0509.5070102@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 03:49:29PM +0800, Li Zefan wrote:
> >> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> >> index e79e2f3..55e7108 100644
> >> --- a/include/linux/syscalls.h
> >> +++ b/include/linux/syscalls.h
> >> @@ -144,7 +144,7 @@ struct perf_event_attr;
> >>  		.name                   = "sys_enter"#sname,		\
> >>  		.system                 = "syscalls",			\
> >>  		.event                  = &enter_syscall_print_##sname,	\
> >> -		.raw_init		= init_syscall_trace,		\
> >> +		.raw_init		= trace_event_raw_init,		\
> >>  		.show_format		= syscall_enter_format,		\
> >>  		.define_fields		= syscall_enter_define_fields,	\
> >>  		.regfunc		= reg_event_syscall_enter,	\
> >> @@ -166,7 +166,7 @@ struct perf_event_attr;
> >>  		.name                   = "sys_exit"#sname,		\
> >>  		.system                 = "syscalls",			\
> >>  		.event                  = &exit_syscall_print_##sname,	\
> >> -		.raw_init		= init_syscall_trace,		\
> >> +		.raw_init		= trace_event_raw_init,		\
> > 
> > 
> > 
> > Nice cleanup.
> > BTW, init_syscall_trace is left unused now. Could you please
> > remove it too?
> > 
> 
> I'd like to see the whole patchset be accepted first. I don't
> won't to spam LKML with another 14 emails. ;)



You can just answer the pervious patch with a new one, putting
a v2 prefix in the title :)


 
> Though I can just resend this patch, Ingo might be confused
> which patch he should take.
> 
> btw, Lai Jiangshan just told me he has a pending patch that
> will modify init_syscall_trace, so init_syscall_trace will
> come back to use again.


Ah ok.

Thanks.

