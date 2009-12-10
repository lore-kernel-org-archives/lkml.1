Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbZLJR3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbZLJR3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761048AbZLJR3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZLJR3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:29:11 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	<20091210120332.GA5042@nowhere> <20091210141121.GB1436@elte.hu>
	<1260456803.2146.167.camel@gandalf.stny.rr.com>
	<20091210153845.GA28230@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 10 Dec 2009 12:28:46 -0500
In-Reply-To: <20091210153845.GA28230@elte.hu> (Ingo Molnar's message of "Thu, 10 Dec 2009 16:38:45 +0100")
Message-ID: <y0md42magc1.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [...]
> Just off the top of my head we want to be able to trace:
>
>  - max irq service latencies for a given IRQ
>  - max block IO completion latencies for a app
>  - max TLB flush latencies in the system
>  - max sys_open() latencies in a task
>  - max fork()/exit() latencies in a workload
>  - max scheduling latencies on a given CPU
>  - max page fault latencies
>  - max wakeup latencies for a given task
>  - max memory allocation latencies
>
>  - ... and dozens and dozens of other things where there's a "start"
>    and a "stop" event and where we want to measure the time between
>    them.
> [...]

FWIW, those who want to collect such measurements today can do so with
a few lines of systemtap script for each of the above.


- FChE
