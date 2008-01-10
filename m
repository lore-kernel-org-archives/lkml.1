Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYAJOqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYAJOqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYAJOqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:46:00 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:58686 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYAJOp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:45:59 -0500
Date: Thu, 10 Jan 2008 09:45:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 22/22 -v2] Trace irq disabled critical timings
In-Reply-To: <1199937502.18203.22.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0801100945390.6420@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org>  <20080109233045.768464295@goodmis.org>
 <1199937502.18203.22.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Daniel Walker wrote:
>
> On Wed, 2008-01-09 at 18:29 -0500, Steven Rostedt wrote:
> > +                       /* Don't trace irqs off for idle */
> > +                       stop_critical_timings();
> >                         idle();
> > +                       start_critical_timings();
>
>
> Is there another way to hook into the idle routine? Right above these
> lines there is a call to "enter_idle()" which I'm wondering about ..
> Would be nice to have some sort of generic hook or method for this ..

enter_idle isn't generic.

-- Steve

