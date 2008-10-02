Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYJBSoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYJBSoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYJBSoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:44:04 -0400
Received: from www.tglx.de ([62.245.132.106]:44652 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYJBSoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:44:02 -0400
Date: Thu, 2 Oct 2008 20:42:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
 handlers
In-Reply-To: <1222962525.2995.100.camel@laptop-eth>
Message-ID: <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
References: <20081001223213.078984344@linutronix.de>  <1222912413.2995.80.camel@laptop-eth.lan>  <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com> <1222962525.2995.100.camel@laptop-eth>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Daniel Walker wrote:
> On Thu, 2008-10-02 at 11:02 -0400, Steven Rostedt wrote:
> > On Wed, 1 Oct 2008, Daniel Walker wrote:
> > > > 
> > > > Converting an interrupt to threaded makes only sense when the handler
> > > > code takes advantage of it by integrating tasklet/softirq
> > > > functionality and simplifying the locking.
> > > 
> > > I'm not clear on your direction here.. I don't have a problem with a
> > > mass driver audit, which I think is what your suggesting with this patch
> > > set .. However, a mass audit like that would push a fully real time
> > > system out for quite some time..
> > 
> > This has nothing to do with real time, although it helps.
> 
> Clearly threading irq handlers does have something to do with real time,
> unless this patch isn't actually threading anything ..

Clearly you have neither clue about real time nor about operating
systems in general. 

Solaris, some BSDs and MacOSX use interrupt threads. Where exactly is
the relation to realtime?

The concept of interrupt threads is nothing which is in any way
related to real time. It is a well known and pretty old concept in
operating system design.

The fact that real time operating systems benefit from interrupt
threads is a totally different topic.

	tglx
	
