Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYIWCbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYIWCbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYIWCba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:31:30 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:56297 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbYIWCb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:31:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAFTt10hMQWq+/2dsb2JhbACBXbUcgWY
Date: Mon, 22 Sep 2008 22:31:15 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Darren Hart <darren@dvhart.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923023115.GE24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com> <20080923020216.GC24937@Krystal> <e17d46420809221926g1396fbb4id5b9c934bad1d96e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <e17d46420809221926g1396fbb4id5b9c934bad1d96e@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:30:50 up 110 days,  7:11,  7 users,  load average: 0.30, 0.24,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Darren Hart (darren@dvhart.com) wrote:
> On Mon, Sep 22, 2008 at 7:02 PM, Mathieu Desnoyers <compudj@krystal.dyndns.org>
> > So only in the specific case of instrumentation of things like locking,
> > where it is possible to insure that instrumentation is synchronized with
> > the instrumented operation, does it make a difference to choose the TSC
> > (which implies a slight delta between the TSCs due to cache line delays
> > at synchronization and delay due to TSCs drifts caused by temperature)
> > over an atomic increment.
> >
> 
> Hrm, i think that overlooks the other reason to use a time based counter over
> an atomic increment: you might care about time.  Perhaps one might be less
> concerned with actual order tightly grouped events and more concerned with the
> actual time delta between more temporally distant events.  In that case, using
> a clocksource would still be valuable. Although admitedtly the caller could
> embed that in their payload, but since we seem to agree we need some kind of
> counter, the time-based counter appears to be the most flexible.
> 
> Thanks,
> 

See my answer to Linus for a proposal on how to do both :)

Mathieu

> -- 
> Darren Hart
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
