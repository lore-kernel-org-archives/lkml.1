Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZIWMEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZIWMEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZIWMEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:04:24 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44322 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbZIWMEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gBQMKNBpCzBuqI0RLEgrsj2R3lbFf1VS8ZoHjzF6hESeCrj/MFuKcb8TFDUcnK0NuF
         03JnJcgQQ68llbdLrHAFnE7wkFG/cIP0mRnVonTYgx/eMhcacoo/JwjY2oPhdsPbc9NY
         kYQ/AwjiZcIvWu6ygrXc2pNudmLqr25ZDRp9A=
MIME-Version: 1.0
In-Reply-To: <20090923105252.GA32176@elte.hu>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
	 <20090923105252.GA32176@elte.hu>
Date: Wed, 23 Sep 2009 14:04:26 +0200
Message-ID: <c62985530909230504l2ede68fq4bcc7fa4fecabcb9@mail.gmail.com>
Subject: Re: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling 
	updates
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/23 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Hi Ingo,
>>
>> Kprobes has been nicely improved lately. The x86 instruction decoder
>> has been fixed to support cross builds and mmx instruction set,
>> besides of a lot of various kprobes core fixes.
>>
>> The tracing part has evolved too, we can define human names for
>> arguments and custom subsystem names for dynamic tracepoints.
>>
>> And also kprobes profiling and raw dynamic tracepoint samples are now
>> supported through perf. Looks like most of the kernel parts are now in
>> place for a perf support. Things are going to be focused on a perf
>> kprobes tool to exploit that.
>
> Nice progress. What's the expected timeline of exhaustive tools/perf/
> support?


Masami is better suited to answer that, so I let him respond.


>> Concerning this git tree, based on tip:/tracing/kprobes, I had to
>> merge tracing/core inside few weeks ago because it needed build fixes
>> that were in tracing/core (the merge commit provides the details). The
>> tree is self contained but it's already async with recent upstream
>> tracing updates. It means that merging upstream tree or tracing/core
>> inside may result in non-trivial conflicts. I can handle them, or
>> rebase the whole, as you prefer.
>>
>> The tree can be found at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>>       tracing/kprobes
>
> Would be nice to merge latest -git into this tree and resolve the
> conflicts:
>
>  kernel/trace/Makefile
>  kernel/trace/trace.h
>  kernel/trace/trace_event_types.h
>  kernel/trace/trace_export.c
>
> Then i could pull it into tip:tracing/kprobes for more testing.


Sure, I'll do that soon.

Frederic.
