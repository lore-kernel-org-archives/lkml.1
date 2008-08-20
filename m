Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYHTThK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYHTThK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYHTTg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:36:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYHTTg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:36:57 -0400
Date: Wed, 20 Aug 2008 15:36:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 0/6] ftrace: to kill a daemon (small updates)
In-Reply-To: <20080820192849.GA5888@joi>
Message-ID: <alpine.DEB.1.10.0808201536260.11714@gandalf.stny.rr.com>
References: <20080814194506.233473381@goodmis.org> <20080815123624.GC5285@joi> <alpine.DEB.1.10.0808150840410.1065@gandalf.stny.rr.com> <20080815133517.GA5292@joi> <20080820192849.GA5888@joi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2008, Marcin Slusarz wrote:

> On Fri, Aug 15, 2008 at 03:35:22PM +0200, Marcin Slusarz wrote:
> > On Fri, Aug 15, 2008 at 08:50:57AM -0400, Steven Rostedt wrote:
> > > 
> > > On Fri, 15 Aug 2008, Marcin Slusarz wrote:
> > > 
> > > > On Thu, Aug 14, 2008 at 03:45:06PM -0400, Steven Rostedt wrote:
> > > > >   Note 2: I have found that the changes here are more stable than
> > > > >     the current daemon method, and these patches should be used.
> > > > >     It also solves the resume from suspend to ram bug that was
> > > > >     reported:
> > > > > 
> > > > >       http://lkml.org/lkml/2008/8/12/234
> > > > >        and
> > > > >       http://lkml.org/lkml/2008/8/12/451
> > > > 
> > > > I don't remember testing any patch for my bug... ;)
> > > > 
> > > > For which tree this patchset is?
> > > > I tried to apply it on rc3, rc3+tip/tip and rc3+tip/master and all failed.
> > > > 
> > > 
> > > Ah, Bruce reported the same error, and said this patch series fixed it. 
> > > I assumed that this would fix your bug too. But if it does not, then I
> > > need to look deeper into what you are reporting.
> > > 
> > > Could you recheck-out the latest tip/master and see if it works for you.
> > 
> > Ok, I tried tip/master and resume from suspend to ram works again.
> > Thanks!
> 
> I assume this patchset won't go into .27. So is there any plan to fix
> it in .27?

I'm hoping that this does go into 27, since it is more reliable than the 
current daemon approach.

-- Steve

