Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbZKXOjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbZKXOjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933119AbZKXOje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:39:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933060AbZKXOjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:39:31 -0500
Date: Tue, 24 Nov 2009 15:39:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] ring-buffer benchmark: Run producer/consumer
 threads at nice +19
Message-ID: <20091124143923.GA17934@elte.hu>
References: <new-submission>
 <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
 <1259072207.22249.1066.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259072207.22249.1066.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2009-11-23 at 07:15 +0000, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  98e4833ba3c314c99dc364012fba6ac894230ad0
> > Gitweb:     http://git.kernel.org/tip/98e4833ba3c314c99dc364012fba6ac894230ad0
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Mon, 23 Nov 2009 08:03:09 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 23 Nov 2009 08:03:09 +0100
> > 
> > ring-buffer benchmark: Run producer/consumer threads at nice +19
> > 
> > The ring-buffer benchmark threads run on nice 0 by default, using
> > up a lot of CPU time and slowing down the system:
> > 
> >    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >   1024 root      20   0     0    0    0 D 95.3  0.0   4:01.67 rb_producer
> >   1023 root      20   0     0    0    0 R 93.5  0.0   2:54.33 rb_consumer
> >  21569 mingo     40   0 14852 1048  772 R  3.6  0.1   0:00.05 top
> >      1 root      40   0  4080  928  668 S  0.0  0.0   0:23.98 init
> > 
> > Renice them to +19 to make them less intrusive.
> 
> Ingo, that is the point of a benchmark!
> 
> This module is not made to be run all the time. I know you do it for 
> testing. But running it at lowest priority kills the reason this 
> module was made in the first place!

Well, it also found quite a few bugs in the ring-buffer code, beyond 
benchmarking so i'd like to use it even without looking at the numbers.

	Ingo
