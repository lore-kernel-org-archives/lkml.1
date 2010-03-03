Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0CCNGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:06:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41306 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0CCNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:06:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=YKb_pKuDjkoI-Brn-IEA:9 a=JLqyiZtlF_dreqFYlsr1GI1E84AA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Mar 2010 08:05:58 -0500
Message-ID: <1267621558.10871.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
> Hi, Steven, Frederic, Ingo,
> 
> I am not sure if this is ftrace's fault, but it is ftrace who triggers
> the soft lockup. On my machine, it is pretty easy, just run:
> 
> echo function_graph > current_tracer
> 
> I found this when 2.6.33-rc7, but forgot to report here. I just tried today's
> Linus tree, it still has this problem.
> 
> Attached are the full soft lockup warnings.
> 
> Below is my related configs:

Actually this is not enough for me. Could you send me the full config,
as well as the full dmesg, not just the dump.

Thanks!

-- Steve

> 
> CONFIG_STACKTRACE_SUPPORT=y
> # CONFIG_RCU_TRACE is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_TRACEPOINTS=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> # CONFIG_NF_CONNTRACK is not set
> # CONFIG_NETFILTER_XT_TARGET_TRACE is not set
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FTRACE_NMI_ENTER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_FTRACE_NMI_ENTER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SYSPROF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_FTRACE_SYSCALLS is not set
> # CONFIG_BOOT_TRACER is not set
> # CONFIG_KSYM_TRACER is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_KMEMTRACE is not set
> # CONFIG_WORKQUEUE_TRACER is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_SAMPLE_TRACEPOINTS=m
> # CONFIG_SAMPLE_TRACE_EVENTS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> 
> Sorry that I don't have time to look into this. If you need other info,
> just say.
> 
> Thanks!


