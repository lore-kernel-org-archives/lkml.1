Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZKCHsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZKCHsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZKCHsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:48:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbZKCHsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:48:07 -0500
Date: Tue, 3 Nov 2009 08:47:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 2/7] Adding general performance benchmarking
	subsystem to perf.
Message-ID: <20091103074749.GH19928@elte.hu>
References: <20091103.133645.1116588942663460777.mitake@dcl.info.waseda.ac.jp> <20091103073453.GD19928@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103073453.GD19928@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > 
> > Adding general performance benchmarking subsystem to perf.
> > This patch add new file: bench-suite.h
> > 
> > bench-suite.h contains prototypes of benchmark suite functions.
> > 
> > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Mike Galbraith <efault@gmx.de>
> > ---
> >  tools/perf/bench-suite.h |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >  create mode 100644 tools/perf/bench-suite.h
> > 
> > diff --git a/tools/perf/bench-suite.h b/tools/perf/bench-suite.h
> > new file mode 100644
> > index 0000000..65f6f55
> > --- /dev/null
> > +++ b/tools/perf/bench-suite.h
> > @@ -0,0 +1,7 @@
> > +#ifndef BENCH_SUITE_H
> > +#define BENCH_SUITE_H
> > +
> > +extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
> > +extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
> > +
> > +#endif
> 
> Please put new headers into tools/*.h.
> 
> Also, could we name it bench.h? It's a bit shorter :)

As per my later mail, maybe the better place for this header would be 
tools/perf/bench/bench.h. That makes the addition of new benchmark 
modules rather self-sufficient.

	Ingo
