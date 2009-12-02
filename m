Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZLBOnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZLBOnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZLBOnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:43:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZLBOnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:43:51 -0500
Date: Wed, 2 Dec 2009 15:43:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
 DEFINE_SINGLE_EVENT() support to docbook
Message-ID: <20091202144334.GA30359@elte.hu>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
 <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
 <1259761934.12870.12.camel@gandalf.stny.rr.com>
 <20091202140128.GA2611@elte.hu>
 <1259764109.12870.37.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259764109.12870.37.camel@gandalf.stny.rr.com>
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

> On Wed, 2009-12-02 at 15:01 +0100, Ingo Molnar wrote:
> 
> > >  DECLARE_CLASS_AND_DEFINE_EVENT()
> > 
> > Hm, that's a bit too long. How about 'DEFINE_CLASS_EVENT()' as a 
> > compromise? It's similarly short-ish to TRACE_EVENT(), and it also 
> > conveys the fact that we create both a class and an event there.
> > 
> > The full series would thus be:
> > 
> > 	DECLARE_EVENT_CLASS
> > 	DEFINE_EVENT
> > 	DEFINE_CLASS_EVENT
> > 
> > hm?
> 
> I thought about that too, but it actually makes it more confusing. 
> Because, looking at this with a fresh POV, I would think that after I 
> declare a class, I would use DEFINE_CLASS_EVENT with that class.

yeah. Hence was my second-best choice 'DEFINE_STANDALONE_EVENT' or 
'DEFINE_SINGLE_EVENT' - to stress the special nature it, and to actually 
nudge people towards creating classes of events instead of doing 
separate, standalone points. (which are a waste in the majority of 
cases)

	Ingo
