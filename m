Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZGVQqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZGVQqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZGVQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:46:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:51852 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751848AbZGVQqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:46:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+/EV1SQ72/eRdTMC5VsuXONBdO6sOFz3bbiPRyLw
	RwWtIsivDaWJ2u
Subject: Re: [patch] perf_counter tools: resurrect perf top annotation in a
 simple interactive form
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1248274190.27058.1530.camel@twins>
References: <1248090981.18702.14.camel@marge.simson.net>
	 <1248274190.27058.1530.camel@twins>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 18:46:11 +0200
Message-Id: <1248281171.5738.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 16:49 +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-20 at 13:56 +0200, Mike Galbraith wrote:
> > Comments/suggestions/clue_bats welcome.
> > 
> > perf_counter tools: resurrect perf top annotation in a simple interactive form.
> > 
> > This patch allows the user to select any symbol in kernel space for source level
> > annotation on the fly, switch between event counters and alter display variables.
> > When symbol details are being displayed, stopping annotation reverts to normal.
> > 
> > This doesn't make top _fully_ interactive, you can only select among the events
> > you started top with, ie it doesn't stop/start event counters etc.
> > 
> > known keys:
> >         [d]     select display delay.
> >         [e]     select display entries (lines).
> >         [E]     select annotation event counter.
> >         [f]     select normal display count filter.
> >         [F]     select annotation display count filter (percentage).
> >         [qQ]    quit.
> >         [s]     select annotation symbol and start annotation.
> >         [S]     stop annotation, revert to normal display.
> >         [z]     toggle event count zeroing.
> 
> ok, so I tried this, but the screen updates overwrite this input
> screen before I can read it ;-)

That's not an input screen, it's a legend shown if you poke an unknown
key.  Poking a known key prompts for input.

	-Mike

