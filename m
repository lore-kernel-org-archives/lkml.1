Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0CCRp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:45:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab0CCRp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:45:57 -0500
X-Authority-Analysis: v=1.0 c=1 a=JmiDjSKT-SYA:10 a=7U3hwN5JcxgA:10 a=gl09Se7XuoYjQc7g1kYA:9 a=Ogy0tFV7twjw2A2Y-K2MHyyBXZAA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1267636595.25158.93.camel@laptop>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
	 <1267632387.10871.59.camel@gandalf.stny.rr.com>
	 <1267634258.25158.88.camel@laptop>
	 <1267636046.10871.74.camel@gandalf.stny.rr.com>
	 <1267636595.25158.93.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Mar 2010 12:45:55 -0500
Message-ID: <1267638355.10871.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 18:16 +0100, Peter Zijlstra wrote:

> > This is what I actually was wondering about. Why is it a "perf only"
> > trace point instead of a TRACE_EVENT()?
> 
> Because I wanted to make perf usable without having to rely on funny
> tracepoints. That is, I am less worried about committing software
> counters to ABI than I am about TRACE_EVENT(), which still gives me a
> terribly uncomfortable feeling.
> 
> Also, building with all CONFIG_TRACE_*=n will still yield a usable perf,
> which is something the embedded people might fancy, all that TRACE stuff
> adds lots of code.

We could make TRACE_EVENT() into a perf only trace point with
CONFIG_TRACE_*=n. 

Just saying that it would be nice if ftrace could also see page faults
and such.

-- Steve



