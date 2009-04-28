Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbZD1PBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbZD1PBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761457AbZD1PBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:01:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47172 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761272AbZD1PBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:01:22 -0400
Date: Tue, 28 Apr 2009 17:01:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LTTng "TIF_KERNEL_TRACE"
Message-ID: <20090428150102.GB26546@elte.hu>
References: <20090428132037.GA27519@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428132037.GA27519@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Ingo,
> 
> Looking at the current -tip tree, I notice that the 
> TIF_SYSCALL_FTRACE flag is only implemented for x86.
> 
> I have TIF_KERNEL_TRACE in my lttng tree which applies to all 
> architectures to do the exact same thing :
> 
> lttng-kernel-trace-thread-flag-alpha.patch
> lttng-kernel-trace-thread-flag-arm.patch
> lttng-kernel-trace-thread-flag-avr32.patch
> lttng-kernel-trace-thread-flag-blackfin.patch
> lttng-kernel-trace-thread-flag-cris.patch
> lttng-kernel-trace-thread-flag-frv.patch
> lttng-kernel-trace-thread-flag-h8300.patch
> lttng-kernel-trace-thread-flag-ia64.patch
> lttng-kernel-trace-thread-flag-m32r.patch
> lttng-kernel-trace-thread-flag-m68k.patch
> lttng-kernel-trace-thread-flag-mips.patch
> lttng-kernel-trace-thread-flag-parisc.patch
> lttng-kernel-trace-thread-flag-powerpc.patch
> lttng-kernel-trace-thread-flag-s390.patch
> lttng-kernel-trace-thread-flag-sh.patch
> lttng-kernel-trace-thread-flag-sparc.patch
> lttng-kernel-trace-thread-flag-um.patch
> lttng-kernel-trace-thread-flag-x86.patch
> lttng-kernel-trace-thread-flag-xtensa.patch
> lttng-kernel-trace-thread-flag-api.patch
> 
> Is there any way we could get this merged ?
> 
> One thing I like about the name TIF_KERNEL_TRACE compared to 
> TIF_SYSCALL_FTRACE is that it gives us a per-thread flag that 
> could eventually be used for more kernel tracing purposes than 
> just syscalls.

Yeah - TIF_KERNEL_TRACE indeed sounds more descriptive and less 
restrictive. TIF_SYSCALL_FTRACE was a bit ad-hoc.

	Ingo
