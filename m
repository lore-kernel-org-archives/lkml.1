Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZLBOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZLBOzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZLBOzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:55:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZLBOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:55:31 -0500
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
 DEFINE_SINGLE_EVENT() support to docbook
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091202144334.GA30359@elte.hu>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
	 <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	 <1259761934.12870.12.camel@gandalf.stny.rr.com>
	 <20091202140128.GA2611@elte.hu>
	 <1259764109.12870.37.camel@gandalf.stny.rr.com>
	 <20091202144334.GA30359@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 09:55:35 -0500
Message-Id: <1259765735.12870.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 15:43 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 2009-12-02 at 15:01 +0100, Ingo Molnar wrote:
> > 
> > > >  DECLARE_CLASS_AND_DEFINE_EVENT()
> > > 
> > > Hm, that's a bit too long. How about 'DEFINE_CLASS_EVENT()' as a 
> > > compromise? It's similarly short-ish to TRACE_EVENT(), and it also 
> > > conveys the fact that we create both a class and an event there.
> > > 
> > > The full series would thus be:
> > > 
> > > 	DECLARE_EVENT_CLASS
> > > 	DEFINE_EVENT
> > > 	DEFINE_CLASS_EVENT
> > > 
> > > hm?
> > 
> > I thought about that too, but it actually makes it more confusing. 
> > Because, looking at this with a fresh POV, I would think that after I 
> > declare a class, I would use DEFINE_CLASS_EVENT with that class.
> 
> yeah. Hence was my second-best choice 'DEFINE_STANDALONE_EVENT' or 
> 'DEFINE_SINGLE_EVENT' - to stress the special nature it, and to actually 
> nudge people towards creating classes of events instead of doing 
> separate, standalone points. (which are a waste in the majority of 
> cases)

But the current TRACE_EVENT is still defining a class. Thus, you could
create a TRACE_EVENT (or whatever it is called) and then create
DEFINE_EVENTs based on the TRACE_EVENT.

That's why I want a name that describes this.

DEFINE_EVENT_CLASS?

Perhaps that's the best.

DECLARE_EVENT_CLASS - only creates a class
DEFINE_EVENT - defines an event based off of a class
DEFINE_EVENT_CLASS - creates a class and defines an event by the same name

Perhaps this is best in keeping with linux kernel naming conventions?

-- Steve


-- Steve


