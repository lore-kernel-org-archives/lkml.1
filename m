Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXFAP3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXFAP3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbXFAP3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:29:39 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32052 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbXFAP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:29:38 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070601131249.GA17059@elte.hu>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
	 <1180544796.32594.184.camel@imap.mvista.com>
	 <1180545380.2958.1.camel@lappy>
	 <1180545913.32594.194.camel@imap.mvista.com>
	 <20070601131249.GA17059@elte.hu>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 08:26:46 -0700
Message-Id: <1180711606.15884.32.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 15:12 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Wed, 2007-05-30 at 19:16 +0200, Peter Zijlstra wrote:
> 
> > > I think you are mistaken here; the two are similar but not 
> > > identical.
> > > 
> > > I see sched_clock() as fast first, accurate second. Whereas the 
> > > clocksource thing is accurate first, fast second.
> > 
> > This is true .. However, if there is a speed different it's small.
> 
> Ugh. Have you ever compared pmtimer (or even hpet) against TSC based 
> sched_clock()? What you write is so wrong that it's not even funny. You 
> keep repeating this nonsense despite having been told multiple times 
> that you are dead wrong.

Yes I have, and your right there is a difference, and a big
difference .. Above I was referring only to the TSC clocksource, since
that's an apples to apples comparison .. I would never compare the TSC
to the acpi_pm, that's no contest ..

The acpi_pm as sched_clock() with hackbench was about %25 slower, the
pit was 10x slower approximately. (I did this months ago.)

Daniel

