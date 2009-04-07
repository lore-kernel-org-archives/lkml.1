Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZDGFIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZDGFIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZDGFIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:08:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:52831 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZDGFIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ijoa3vu1y8aK0+jZuWsdQNmEgTHMAF8S4d3ORZJkYuhEpEysdO0/Z14gd3l5ywYt8f
         zit2MQdyCeGaA5pRI/jO1zqdpHp5Qwmyeprf3tk5OILylZB/AFkWQDC1xhwKOZS5G9ZV
         mifqely/gJ38oaFT4NWco9BwuseqdUpazv3/4=
MIME-Version: 1.0
In-Reply-To: <1239068812.4753.15.camel@localhost.localdomain>
References: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
	 <1239068812.4753.15.camel@localhost.localdomain>
Date: Tue, 7 Apr 2009 14:08:10 +0900
Message-ID: <49b7c2350904062208qc16ef6ag9a33bef66721f4e@mail.gmail.com>
Subject: Re: [PATCH] Update old Mini-HOWTO for ftrace
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nikanth Karthikensan <knikanth@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear steven,

I  confirm http://lkml.org/lkml/2009/3/23/24 webpage now.
I am gratified with a similar patch that another people sent  this problem.

In fact, I figured out trivial problem of old mini-HOWTO according to
http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.1/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Using_the_ftrace_Utility_for_Tracing_Latencies.html
web manual.

I want you to change MRG Kernel from ftrace to function for
consistency in private.
Thank you for interesting article

Regards,
GeunSik Lim..

2009/4/7 Steven Rostedt <srostedt@redhat.com>:
>
> On Mon, 2009-04-06 at 23:02 +0900, GeunSik Lim wrote:
>> Dear Steven,
>>
>>    The author of ftrace(Internal kernel Function Tracer) feature
>> renamed the ftrace tracer
>>     to function to avoid further confusion between the ftrace
>> infrastructure and the
>>     function tracer on Oct-20, 2008.
>>
>>     But, Update of Mini-HOWTO document are still not working
>>     .
>>     Most of the developers often utilize "/debug/tracing/README" file
>> as Mini-HOWTO.
>>     They will confuse definition and usage about ftrace  between
>> README(ftrace) file
>>     and available_tracers(function) file after linux-2.6.27 like me.
>>     And, I want you to append "chrt -f 5 sleep 1" command as simple
>> example for latency.
>>
>>     Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
>>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  kernel/trace/trace.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index a0174a4..15f0eec 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -2358,7 +2358,7 @@ static const char readme_msg[] =
>>         "# mkdir /debug\n"
>>         "# mount -t debugfs nodev /debug\n\n"
>>         "# cat /debug/tracing/available_tracers\n"
>> -       "wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
>> +       "wakeup preemptirqsoff preemptoff irqsoff function
>> sched_switch none\n\n"
>>         "# cat /debug/tracing/current_tracer\n"
>>         "none\n"
>>         "# echo sched_switch > /debug/tracing/current_tracer\n"
>> @@ -2368,6 +2368,7 @@ static const char readme_msg[] =
>>         "noprint-parent nosym-offset nosym-addr noverbose\n"
>>         "# echo print-parent > /debug/tracing/trace_options\n"
>>         "# echo 1 > /debug/tracing/tracing_enabled\n"
>> +       "# chrt -f 5 sleep 1\n"
>>         "# cat /debug/tracing/trace > /tmp/trace.txt\n"
>>         "echo 0 > /debug/tracing/tracing_enabled\n"
>>  ;
>>
>
> Actually Nikanth sent a similar patch a month ago, but somehow it
> slipped under the radar. I'll be picking that one up instead.
>
> http://lkml.org/lkml/2009/3/23/24
>
> But thanks anyway.
>
> -- Steve
>
>
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
