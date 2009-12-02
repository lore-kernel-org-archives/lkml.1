Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZLBQRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZLBQRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZLBQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:17:06 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:29084 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZLBQRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:17:05 -0500
Date: Wed, 2 Dec 2009 08:15:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
 DEFINE_SINGLE_EVENT() support to docbook
Message-Id: <20091202081537.6ce846b5.randy.dunlap@oracle.com>
In-Reply-To: <1259765735.12870.42.camel@gandalf.stny.rr.com>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
	<tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	<1259761934.12870.12.camel@gandalf.stny.rr.com>
	<20091202140128.GA2611@elte.hu>
	<1259764109.12870.37.camel@gandalf.stny.rr.com>
	<20091202144334.GA30359@elte.hu>
	<1259765735.12870.42.camel@gandalf.stny.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B1692C8.00DB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Dec 2009 09:55:35 -0500 Steven Rostedt wrote:

> On Wed, 2009-12-02 at 15:43 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Wed, 2009-12-02 at 15:01 +0100, Ingo Molnar wrote:
> > > 
> > > > >  DECLARE_CLASS_AND_DEFINE_EVENT()
> > > > 
> > > > Hm, that's a bit too long. How about 'DEFINE_CLASS_EVENT()' as a 
> > > > compromise? It's similarly short-ish to TRACE_EVENT(), and it also 
> > > > conveys the fact that we create both a class and an event there.
> > > > 
> > > > The full series would thus be:
> > > > 
> > > > 	DECLARE_EVENT_CLASS
> > > > 	DEFINE_EVENT
> > > > 	DEFINE_CLASS_EVENT
> > > > 
> > > > hm?
> > > 
> > > I thought about that too, but it actually makes it more confusing. 
> > > Because, looking at this with a fresh POV, I would think that after I 
> > > declare a class, I would use DEFINE_CLASS_EVENT with that class.
> > 
> > yeah. Hence was my second-best choice 'DEFINE_STANDALONE_EVENT' or 
> > 'DEFINE_SINGLE_EVENT' - to stress the special nature it, and to actually 
> > nudge people towards creating classes of events instead of doing 
> > separate, standalone points. (which are a waste in the majority of 
> > cases)
> 
> But the current TRACE_EVENT is still defining a class. Thus, you could
> create a TRACE_EVENT (or whatever it is called) and then create
> DEFINE_EVENTs based on the TRACE_EVENT.
> 
> That's why I want a name that describes this.
> 
> DEFINE_EVENT_CLASS?
> 
> Perhaps that's the best.
> 
> DECLARE_EVENT_CLASS - only creates a class
> DEFINE_EVENT - defines an event based off of a class
> DEFINE_EVENT_CLASS - creates a class and defines an event by the same name
> 
> Perhaps this is best in keeping with linux kernel naming conventions?

Yes, that seems fairly typical.

I didn't care for the
DEFINE_x_y()
and
DEFINE_y_x()
suggestion.  That just opens the door for confusion IMO.

thanks,
---
~Randy
