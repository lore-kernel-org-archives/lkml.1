Return-Path: <linux-kernel-owner+w=401wt.eu-S932254Ab0A2Jw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0A2Jw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717Ab0A2JwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:52:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab0A2JwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:52:24 -0500
Date: Fri, 29 Jan 2010 10:51:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
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
Message-ID: <20100129095152.GA360@elte.hu>
References: <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
 <1264575134.4283.1983.camel@laptop>
 <20100127085442.GA28422@elte.hu>
 <1264643539.5068.62.camel@localhost.localdomain>
 <20100128085502.GA7713@elte.hu>
 <1264726768.4933.50.camel@localhost.localdomain>
 <20100129073907.GF14636@elte.hu>
 <20100129075240.GF16920@in.ibm.com>
 <20100129091116.GB10878@elte.hu>
 <20100129093136.GH16920@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129093136.GH16920@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> On Fri, Jan 29, 2010 at 10:11:16AM +0100, Ingo Molnar wrote:
> > 
> > * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > 
> > > On Fri, Jan 29, 2010 at 08:39:07AM +0100, Ingo Molnar wrote:
> > > 
> > > ...
> > > 
> > > > When we merged kprobes ~10 years ago we made the (rather bad) mistake of 
> > > > merging a raw, opaque facility and leaving 'the rest' up to some other entity. 
> > > > IBM kprobes hackers vanished the day the original kprobes code went upstream 
> > > > and the high level entity never truly materialized in-kernel, for nearly a 
> > > > decade!
> > > 
> > > I don't know what you are referring to here... Kprobes was merged in 2.6.9 
> > > (~August 2004 -- less than 6 years ago). [...]
> > 
> > Ok, 6 years then :-)
> >
> > > [...] Since then, we did work on ports to powerpc and s390. We implemented 
> > > kretprobes. We made it much scalable using RCU; we did the powerpc booster 
> > > to skip single-step when possible, not to mention various bug fixes over the 
> > > years.
> > 
> > Except it had no real in-kernel user.
> 
> Not that I want to rebut you Ingo, but there were in-kernel users since 2006
> (net/ipv4/tcp_probe.c) :-)

i said 'real' users. That usage in tcp_probe.c was (and is) really minimal and 
never expanded really.

> Aside, I am also glad that we have more flexibility with the perf 
> integration.

ok, good :)

	Ingo
