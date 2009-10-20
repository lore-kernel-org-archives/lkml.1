Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbZJTB7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbZJTB7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 21:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbZJTB7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 21:59:38 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36149 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbZJTB7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 21:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XhtzY5IQDDwXVCauDQIiJJLaWo/GVm8xMM3ldFaRAtSDPDoD5h05gkBcKPyVyEoeOg
         8mM64KSTPM9MSMCZ7+nCURpobVx/B5cPm3e4U//+8iwp1dEoOMo7kxbLHiZbIX2PBJzd
         Qw17KB+VkacHO1hMYmtrI0s0Ju2haF5v2AhQk=
MIME-Version: 1.0
In-Reply-To: <4ADD049E.9080000@redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
	 <ad7a95ae0910191610q6f6200f1n112a71a0cbd483f1@mail.gmail.com>
	 <4ADD049E.9080000@redhat.com>
Date: Mon, 19 Oct 2009 21:59:42 -0400
Message-ID: <ad7a95ae0910191859l6e0246b8u8634fac5b8ec0770@mail.gmail.com>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf 
	probe and kprobe-tracer bugfixes
From: Ashwin Chaugule <ashbertslists@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 8:30 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
>
> Actually, perf-probe can add tracepoint-like events. It will allow you
> to probe function inside by both C-source-line level and address level.
> perf-probe already supports inline function too.
>
> Currently, even its syntax is unstable, but you can add an event inside
> some function which is at cfile.c line 100, as below;
>
>  perf probe -P 'p:probe1 cfile.c:100'
>
> and you can trace it by using perf record as same as other tracepoints
>
>  perf record -f -e kprobes:myprobe:record -F 1 -a ls
>
>
>> Alternately, I think even dynamic trace could provide similar insight
>> with perfevents ? If none of this is already done, I plan to work on
>> this in my spare time and would like to team up with anyone else
>> interested.
>
> Yes, it's done as I said above.
> But it still has long TODO list, including support type of arguments,
> arrays, fields of structures and so on (of course, defining useful
> syntax too). So any comments and contributes are welcome :-)
>
Excellent ! Time to give it a spin :)

Cheers,
Ashwin
