Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZHCBSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZHCBSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZHCBSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:18:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35416 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbZHCBST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=paU3mPvfB4toMdAEmaxKP/Q1nABZY2aGk7SxsJvHrk5YDH2TwHvYuOXANVVsORRM8R
         hO0fmLsCtEvmUxLwCEHy6zAZrQqVOLvXbEHDrlYF81zDXjdwwj2fp32NfpXhAJ1wKT7s
         IQ4F4fHEJB3529e7c34d7xAf9IWR1+G+8X4vU=
MIME-Version: 1.0
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
	 <20090802193416.GA24486@elte.hu> <20090802195312.GA18598@elte.hu>
Date: Mon, 3 Aug 2009 03:18:19 +0200
Message-ID: <c62985530908021818o5a462e83td24b18c173c05c1a@mail.gmail.com>
Subject: Re: [GIT PULL] tracing: Various cleanups for 2.6.32
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/2 Ingo Molnar <mingo@elte.hu>:
>
>> > Frederic Weisbecker (5):
>> >       tracing/function-graph-tracer: Drop the useless nmi protection
>> >       tracing/function-tracer: Move trace_function() in the function tracer file
>> >       tracing/core: Make the stack entry helpers global
>> >       tracing: Move sched event insertion helpers in the sched switch tracer file
>> >       tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file
>> >
>> > Lai Jiangshan (1):
>> >       tracing: Simplify print_graph_cpu()
>
> One of these causes this build failure in -tip testing:
>
> kernel/built-in.o: In function `ftrace':
> (.text+0x4f497): undefined reference to `trace_function'
> kernel/built-in.o: In function `trace_hardirqs_off_caller':
> (.text+0x530b1): undefined reference to `trace_function'
> kernel/built-in.o: In function `trace_hardirqs_off':
> (.text+0x53190): undefined reference to `trace_function'
> kernel/built-in.o: In function `start_critical_timings':
> (.text+0x5326f): undefined reference to `trace_function'
> kernel/built-in.o: In function `check_critical_timing':
> trace_irqsoff.c:(.text+0x533aa): undefined reference to `trace_function'
> kernel/built-in.o:trace_irqsoff.c:(.text+0x533e5): more undefined references to `trace_function' follow
>
> config attached.
>
>        Ingo
>


I may have forgotten a CONFIG dependency. I'll look at it very soon, thanks.
