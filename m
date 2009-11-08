Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZKHLa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZKHLa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZKHLa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:30:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbZKHLaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:30:25 -0500
Date: Sun, 8 Nov 2009 12:30:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking
 subcommand to perf.
Message-ID: <20091108113013.GM11372@elte.hu>
References: <20091103.195535.789626513029853730.mitake@dcl.info.waseda.ac.jp>
 <20091103172926.GC11535@elte.hu>
 <20091104.194108.635980116686317754.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104.194108.635980116686317754.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking subcommand to perf.
> Date: Tue, 3 Nov 2009 18:29:26 +0100
> 
> > 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > 
> > > Adding general performance benchmarking subcommand to perf.
> > > This patch adds bench/sched-pipe.c.
> > > 
> > > bench/sched-pipe.c is a benchmark program
> > > to measure performance of pipe() system call.
> > > This benchmark is based on pipe-test-1m.c by Ingo Molnar.
> > > http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
> > > 
> > > Example of use:
> > > % perf bench sched pipe               # Use default options
> > > 4.575  	     	   		      # Result is time
> > > % perf bench sched pipe -l 2000	      # This option means "loop 2000 counts"
> > > 0.024
> > 
> > ok, -l makes sense.
> > 
> > Shouldnt we output the unit of measurement, i.e. '4.575 usecs'? Also, we 
> > should perhaps print something like:
> > 
> >   % perf bench sched pipe
> > 
> >   (executing 1000000 pipe operations between two tasks)
> > 
> >      4.575 usecs per op
> >     218579 ops/sec   
> > 
> > ?
> 
> I have to admit that single float value output is too simple.
> So I'll fix the default output.
> 
> But, I believe that simple form makes sense for
> processing by scripts or graph tools like gnuplot.
> I'll add the option (may be --simple) to switch
> friendliness of outputs.

Btw., could you make it Git-ish, i.e.:

 --format=short

or:

 --format=simple

Eventually more format options might be added.

	Ingo
