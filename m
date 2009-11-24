Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbZKXPW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbZKXPW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZKXPW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:22:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53570 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077AbZKXPWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:22:55 -0500
Date: Tue, 24 Nov 2009 16:22:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] ring-buffer benchmark: Run producer/consumer
 threads at nice +19
Message-ID: <20091124152245.GB21821@elte.hu>
References: <new-submission>
 <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
 <1259072207.22249.1066.camel@gandalf.stny.rr.com>
 <20091124143923.GA17934@elte.hu>
 <1259074860.22249.1071.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259074860.22249.1071.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2009-11-24 at 15:39 +0100, Ingo Molnar wrote:
> 
> > > This module is not made to be run all the time. I know you do it 
> > > for testing. But running it at lowest priority kills the reason 
> > > this module was made in the first place!
> > 
> > Well, it also found quite a few bugs in the ring-buffer code, beyond 
> > benchmarking so i'd like to use it even without looking at the 
> > numbers.
> 
> OK, then lets make a module option (and command line) that will allow 
> the setting of the priority of the threads. Either nice or even fifo 
> (use at your own risk ;-)

Yeah, that's fine to me - as long as the default is unintrusive. (i.e. 
like the rcutorture threads, which run at nice +19 too - and kmemcheck 
which runs at +19 as well.)

We still have the perl overhead in function-tracing kernel builds btw
:-/

	Ingo
