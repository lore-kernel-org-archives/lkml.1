Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYLIVkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYLIVkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYLIVkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:40:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49988 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbYLIVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:40:22 -0500
Date: Tue, 9 Dec 2008 16:40:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: [PATCH 1/3] tracing/function-graph-tracer: introduce
 __notrace_funcgraph to filter special functions
In-Reply-To: <c62985530812091205r5b5afb29o5d9282076c7094c3@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812091639390.19875@gandalf.stny.rr.com>
References: <4939E600.804@gmail.com> <20081208141406.GA14856@elte.hu>  <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com>  <20081208155018.GB405@elte.hu> <20081209023822.GA3602@elte.hu>  <c62985530812090059g27bcb36dg8318123d16a15664@mail.gmail.com>
 <c62985530812091205r5b5afb29o5d9282076c7094c3@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Dec 2008, Fr?d?ric Weisbecker wrote:
> 2008/12/9 Fr?d?ric Weisbecker <fweisbec@gmail.com>:
> 
> 
> I built this config on an smp x86-64 and booted several times (and
> tested the function tracer manually) with and without the following
> options:
> 
> initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel
> selinux=0 nmi_watchdog=2 idle=poll
> 
> And I can't reproduce this bug.... That might be a very nasty race condition...

Neither can I :-(

Ingo, is this on the box that stresses NMIs?

-- Steve

