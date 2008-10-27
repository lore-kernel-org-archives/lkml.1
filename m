Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbYJ0Xg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbYJ0Xg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYJ0Xgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:36:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYJ0Xgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:36:47 -0400
Date: Mon, 27 Oct 2008 19:36:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ftrace doesn't work anymore on latest tip
In-Reply-To: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Oct 2008, Fr?d?ric Weisbecker wrote:

> Hi,
> 
> I tried to launch the function tracer with the latest -tip.
> With DYNAMIC_FTRACE (I just tried one time), I set "function" to
> current_trace and it blocks during writing. I can't
> even switch to another console.
> Without DYNAMIC_FTRACE I can set the tracer to function but it doesn't
> produce any trace, even on trace or tracing_pipe.
> 
> My config is in attachment.
> I will try some revert...or some other tracers.
> 


You might want to update your config (make oldconfig?) The latest tip has 
FUNCTION_TRACER instead of FTRACE.

Also, the config you sent me, does not even have FTRACE on :-/

CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y


-- Steve

