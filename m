Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861Ab0A2Jb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0A2Jb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272Ab0A2Jb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:31:57 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:44999 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab0A2Jbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:31:53 -0500
Date: Fri, 29 Jan 2010 15:01:36 +0530
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
Message-ID: <20100129093136.GH16920@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu> <1264643539.5068.62.camel@localhost.localdomain> <20100128085502.GA7713@elte.hu> <1264726768.4933.50.camel@localhost.localdomain> <20100129073907.GF14636@elte.hu> <20100129075240.GF16920@in.ibm.com> <20100129091116.GB10878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129091116.GB10878@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:11:16AM +0100, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > On Fri, Jan 29, 2010 at 08:39:07AM +0100, Ingo Molnar wrote:
> > 
> > ...
> > 
> > > When we merged kprobes ~10 years ago we made the (rather bad) mistake of 
> > > merging a raw, opaque facility and leaving 'the rest' up to some other entity. 
> > > IBM kprobes hackers vanished the day the original kprobes code went upstream 
> > > and the high level entity never truly materialized in-kernel, for nearly a 
> > > decade!
> > 
> > I don't know what you are referring to here... Kprobes was merged in 2.6.9 
> > (~August 2004 -- less than 6 years ago). [...]
> 
> Ok, 6 years then :-)
>
> > [...] Since then, we did work on ports to powerpc and s390. We implemented 
> > kretprobes. We made it much scalable using RCU; we did the powerpc booster 
> > to skip single-step when possible, not to mention various bug fixes over the 
> > years.
> 
> Except it had no real in-kernel user.

Not that I want to rebut you Ingo, but there were in-kernel users since 2006
(net/ipv4/tcp_probe.c) :-)

Aside, I am also glad that we have more flexibility with the perf
integration.

Ananth
