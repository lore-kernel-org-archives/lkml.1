Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbZCMQhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbZCMQhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbZCMQhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:37:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980AbZCMQhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:37:24 -0400
Date: Fri, 13 Mar 2009 17:37:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 2/2] tracing/x86: basic implementation of syscall
	tracing for x86-64
Message-ID: <20090313163702.GA9082@elte.hu>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-3-git-send-email-fweisbec@gmail.com> <20090313163207.GA3354@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313163207.GA3354@Krystal>
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

> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
>
> > Provide the ptrace hooks and arch specific syscall numbers 
> > to ftrace arch indepedant syscall numbers. For now it only 
> > supports 4 syscalls to provide an example.
> > 
> 
> Hi Frederic,
> 
> I already have the equivalent TIF_KERNEL_TRACE flag in my 
> LTTng tree added to every Linux architecture. You might want 
> to re-use this work rather than re-doing this. I don't mind 
> changing the flag name.

Yeah. Note that the TIF bits are just one part - there are other 
bits needed for HAVE_FTRACE_SYSCALLS arch support.

Also, i'd eventually expect the TIF bits to be converted to a 
tracehook callback, not spread it to other architectures.

	Ingo
