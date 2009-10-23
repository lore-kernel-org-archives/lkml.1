Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZJWKaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZJWKaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZJWKaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:30:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZJWKaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:30:01 -0400
Date: Fri, 23 Oct 2009 12:29:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Greg KH <greg@kroah.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] tracefs
Message-ID: <20091023102939.GE19169@elte.hu>
References: <20091023004937.GA24035@kroah.com> <20091023053237.GA24359@elte.hu> <20091023093838.GA4939@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023093838.GA4939@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Oct 23, 2009 at 07:32:37AM +0200, Ingo Molnar wrote:
> > 
> > * Greg KH <greg@kroah.com> wrote:
> > 
> > > Hi all,
> > > 
> > > At LinuxCon this year, Steven and I talked about moving the 
> > > debugfs usage in the tracing core to a stand-alone filesystem to 
> > > give the ability to start to lock down the api so that people an 
> > > count on what is going on in the tracing userspace interface.
> > 
> > What we want to move out initially (and i talked to Steve and 
> > Frederic about that a few weeks ago) is the event description bits - 
> > the format stuff in /debug/tracing/events/ - but definitely not all 
> > the other, rather messy and ad-hoc APIs.
> > 
> > _No way_ do we want to tie down the pretty-printing ftrace details 
> > as an ABI. We promised that when ftrace went upstream and all the 
> > details are way too messy to be exposed in an ABI alike matter (and 
> > yes, consider this a NAK Steve ;-).
> > 
> > We want a _very_ careful exporting of certain pieces of information 
> > that helps syscall-exposed perf events bits, and to improve the 
> > quality of interfaces while we do that.
> > 
> > 	Ingo
> 
> 
> I guess the first bits that need to be exported are the 
> TRACE_EVENT_ABI. But even before that, we need to ensure we have a 
> final version of the trace events description.

Yeah, exactly. Once we pin them down they'll be with us for a very long 
time.

	Ingo
