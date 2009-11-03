Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZKCR3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZKCR3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZKCR3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:29:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbZKCR3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:29:37 -0500
Date: Tue, 3 Nov 2009 18:29:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking
	subcommand to perf.
Message-ID: <20091103172926.GC11535@elte.hu>
References: <20091103.195535.789626513029853730.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.195535.789626513029853730.mitake@dcl.info.waseda.ac.jp>
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


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> 
> Adding general performance benchmarking subcommand to perf.
> This patch adds bench/sched-pipe.c.
> 
> bench/sched-pipe.c is a benchmark program
> to measure performance of pipe() system call.
> This benchmark is based on pipe-test-1m.c by Ingo Molnar.
> http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
> 
> Example of use:
> % perf bench sched pipe               # Use default options
> 4.575  	     	   		      # Result is time
> % perf bench sched pipe -l 2000	      # This option means "loop 2000 counts"
> 0.024

ok, -l makes sense.

Shouldnt we output the unit of measurement, i.e. '4.575 usecs'? Also, we 
should perhaps print something like:

  % perf bench sched pipe

  (executing 1000000 pipe operations between two tasks)

     4.575 usecs per op
    218579 ops/sec   

?

	Ingo
