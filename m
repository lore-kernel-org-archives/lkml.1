Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712Ab0A2Hzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0A2Hzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540Ab0A2Hze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:55:34 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59268 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0A2Hzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:55:33 -0500
Date: Fri, 29 Jan 2010 13:25:29 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Tromey <tromey@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100129075529.GG16920@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu> <1264643539.5068.62.camel@localhost.localdomain> <20100128085502.GA7713@elte.hu> <1264726768.4933.50.camel@localhost.localdomain> <20100129073907.GF14636@elte.hu> <20100129075240.GF16920@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129075240.GF16920@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 01:22:40PM +0530, Ananth N Mavinakayanahalli wrote:
> On Fri, Jan 29, 2010 at 08:39:07AM +0100, Ingo Molnar wrote:
> 
> ...
> 
> > When we merged kprobes ~10 years ago we made the (rather bad) mistake of 
> > merging a raw, opaque facility and leaving 'the rest' up to some other entity. 
> > IBM kprobes hackers vanished the day the original kprobes code went upstream 
> > and the high level entity never truly materialized in-kernel, for nearly a 
> > decade!
> 
> I don't know what you are referring to here... Kprobes was merged in
> 2.6.9 (~August 2004 -- less than 6 years ago). Since then, we did work
> on ports to powerpc and s390. We implemented kretprobes. We made it much
> scalable using RCU; we did the powerpc booster to skip single-step when
> possible, not to mention various bug fixes over the years.
> 
> Yes, we did not do the perf integration, but perf did not exist then, either.
> 
> Its simply wrong to say people 'vanished'.

Oh, and the x86 instruction decoder was initially implemented by us.
Masami has done a great job making it more complete.

Ananth
