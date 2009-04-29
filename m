Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZD2MF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZD2MF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZD2MFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:05:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZD2MFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:05:13 -0400
Date: Wed, 29 Apr 2009 14:04:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Sachin Sant <sachinp@in.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-s390@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Next April 24: [S390] allmodconfig build failure (trace/events)
Message-ID: <20090429120454.GF11586@elte.hu>
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au> <49F16654.8040208@in.ibm.com> <20090424072533.GE24912@elte.hu> <20090424104108.0f2c0f05@osiris.boeblingen.de.ibm.com> <49F8232B.4090007@in.ibm.com> <20090429135139.5fac79b8@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429135139.5fac79b8@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Wed, 29 Apr 2009 15:21:39 +0530
> Sachin Sant <sachinp@in.ibm.com> wrote:
> > Heiko Carstens wrote:
> > > On Fri, 24 Apr 2009 09:25:33 +0200
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > >> * Sachin Sant <sachinp@in.ibm.com> wrote:
> > >>> Today's next tree build(s390 allmodconfig) failed with
> > >>>
> > >>> kernel/built-in.o: In function `trace_softirq_entry'
> > >>> include/trace/events/irq.h:42: undefined reference to  
> > >>> `'
> > >>> include/trace/events/irq.h:42: undefined reference to  
> > >>> `__tracepoint_softirq_entry'
> > >>> kernel/built-in.o: In function `trace_softirq_exit':
> > >>> include/trace/events/irq.h:48: undefined reference to  
> > >>> `__tracepoint_softirq_exit'
> > >>> include/trace/events/irq.h:48: undefined reference to  
> > >>> `__tracepoint_softirq_exit'
> > >>>       
> > >> Hm, that's weird - s390 does not build kernel/softirq.o? Hm, it does 
> > >> - softirq.o is an obj-y object.
> > >
> > > s390 does build kernel/softirq.o. However it's anything but obvious to
> > > me how the tracepoint infrastructure works. Too many #ifdefs, #define's
> > > and #undefine's...
> > >
> > > I would expect that struct __tracepoint_softirq_entry somehow gets
> > > defined via one of the TRACE_FORMAT macros, no?
> > Today's next tree also has this failure. Any solution for this problem ?
> 
> Ingo, could you pick up the patch below please?

applied, thanks Heiko!

	Ingo
