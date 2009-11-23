Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbZKWRxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbZKWRxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZKWRxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:53:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZKWRxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:53:46 -0500
Date: Mon, 23 Nov 2009 18:53:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Li Zefan <lizf@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
Message-ID: <20091123175330.GA29396@elte.hu>
References: <20091120081440.GA19778@elte.hu>
 <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
 <20091120083053.GB19778@elte.hu>
 <4B0657A4.2040606@cs.helsinki.fi>
 <20091120090134.GD19778@elte.hu>
 <84144f020911200115g14cfa3b5k959f8751001b8b35@mail.gmail.com>
 <20091120101305.GA16781@elte.hu>
 <4B067007.8070607@cs.helsinki.fi>
 <20091120104920.GA12634@elte.hu>
 <1258987585.22249.1036.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258987585.22249.1036.camel@gandalf.stny.rr.com>
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

> On Fri, 2009-11-20 at 11:49 +0100, Ingo Molnar wrote:
> > > 
> > > You're right, of course. With kmemtrace-user, I just copied the raw 
> > > trace file from /sys/kernel. I wonder if that's a good enough reason 
> > > to keep kmemtrace bits around?
> > 
> > Not really. If then a light-weight recording app could be made but 
> > i'd rather wait for actual usecases to pop up.
> 
> Hmm, but isn't this an actual use case?

Not really - perf record is pretty lightweight and you'd want perf for 
hands-on stats anyway.

	Ingo
