Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZBYJMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZBYJMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZBYJMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:12:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZBYJMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:12:19 -0500
Date: Wed, 25 Feb 2009 10:10:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225091041.GB30940@elte.hu>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> On Wed, Feb 25, 2009 at 10:28 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > A better approach would be to design simple, robust kernel interfaces
> > which make sense and which aren't made all complex by putting the user
> > interface in kernel space.  And to maintain corresponding userspace
> > tools which manipulate and present the IO from those kernel interfaces.
> 
> We did this for kmemtrace and quite frankly, I usually end up 
> spending more time figuring out how to export the data from a 
> virtual machine than actually analyzing the results. What 
> makes ftrace so cool is the fact that it has almost 
> zero-overhead for setup and that the text-based data format 
> plays well with simple scripting tools available everywhere.

I just tried to write a similar reply - and ended up with a long 
5 page mail which was just repeating points others and me made 
before.

Instead i'll now print out your reply and will hang it on the 
wall ... ;-)

	Ingo
