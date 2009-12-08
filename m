Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZLHHty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZLHHty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZLHHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:49:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59693 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbZLHHtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:49:50 -0500
Message-ID: <4B1E0509.5070102@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 15:49:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] tracing: Extract duplicate	ftrace_raw_init_event_foo()
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC48C.7080603@cn.fujitsu.com> <20091208073042.GA4989@nowhere>
In-Reply-To: <20091208073042.GA4989@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index e79e2f3..55e7108 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -144,7 +144,7 @@ struct perf_event_attr;
>>  		.name                   = "sys_enter"#sname,		\
>>  		.system                 = "syscalls",			\
>>  		.event                  = &enter_syscall_print_##sname,	\
>> -		.raw_init		= init_syscall_trace,		\
>> +		.raw_init		= trace_event_raw_init,		\
>>  		.show_format		= syscall_enter_format,		\
>>  		.define_fields		= syscall_enter_define_fields,	\
>>  		.regfunc		= reg_event_syscall_enter,	\
>> @@ -166,7 +166,7 @@ struct perf_event_attr;
>>  		.name                   = "sys_exit"#sname,		\
>>  		.system                 = "syscalls",			\
>>  		.event                  = &exit_syscall_print_##sname,	\
>> -		.raw_init		= init_syscall_trace,		\
>> +		.raw_init		= trace_event_raw_init,		\
> 
> 
> 
> Nice cleanup.
> BTW, init_syscall_trace is left unused now. Could you please
> remove it too?
> 

I'd like to see the whole patchset be accepted first. I don't
won't to spam LKML with another 14 emails. ;)

Though I can just resend this patch, Ingo might be confused
which patch he should take.

btw, Lai Jiangshan just told me he has a pending patch that
will modify init_syscall_trace, so init_syscall_trace will
come back to use again.

> And add my Acked-by. Thanks!
> 

Thanks!
