Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZGDOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZGDOS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGDOSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 10:18:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:47058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZGDOSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 10:18:18 -0400
Subject: Re: [PATCH 4/6 -tip] perf_counter: Add Generalized Hardware
 interrupt support for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090704102230.GE2139@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam>
	 <1246441094.3403.10.camel@hpdv5.satnam> <20090701112406.GE15958@elte.hu>
	 <1246622515.2322.30.camel@jaswinder.satnam> <20090704102230.GE2139@elte.hu>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 19:47:19 +0530
Message-Id: <1246717039.2329.26.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-04 at 12:22 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Wed, 2009-07-01 at 13:24 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > 
> > > > $ ./perf stat -e interrupts -e masked -e int-pending-mask-cycles -- ls -lR /usr/include/ > /dev/null
> > > > 
> > > >  Performance counter stats for 'ls -lR /usr/include/':
> > > > 
> > > >             377  interrupts
> > > >        53429936  int-mask-cycles
> > > >            1119  int-pending-mask-cycles
> > > > 
> > > >     0.371457539  seconds time elapsed
> > > 
> > > Agreed, this is another useful generalization - and the 'cycles 
> > > pending' metrics are not retrievable via any software means.
> > > 
> > > We could and should probably add a software counter for hardirqs 
> > > as wel. That would allow the vector/irqnr information to be 
> > > passed in, and it would allow architectures without irq metrics 
> > > in the PMU to have this counter too.
> > > 
> > 
> > Please let me know that addition of software counter will be in 
> > this patch or we can do it incrementally after this patch.
> 
> It should be in this series. That way we can cross-check whether the 
> soft counts and the hard counts match up and find potential bugs 
> that way, etc.
> 

You want to cross check performance counter events ?

Why you choose interrupt events, why do not you raise this point when
cache events was added ?

I do not understand why you keep going on tangents.

If you want to cross-check then it should be in different patch and
there should be no requirement to have this on this series and no point
of blocking this patch on irrelevant argument.

Only thing I can do is to fix the patch, if you point any problem in
this.

Thanks,
--
JSR

