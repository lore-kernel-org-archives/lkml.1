Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZGTXEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZGTXEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZGTXEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:04:00 -0400
Received: from www.tglx.de ([62.245.132.106]:40533 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZGTXD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:03:59 -0400
Date: Tue, 21 Jul 2009 01:02:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: s2r badness
In-Reply-To: <alpine.DEB.2.00.0907201700010.14242@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0907210101110.2813@localhost.localdomain>
References: <1247947383.4872.3.camel@laptop> <alpine.LFD.2.00.0907182223450.11571@localhost.localdomain> <alpine.DEB.2.00.0907201700010.14242@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009, Steven Rostedt wrote:
> >  
> > Just to make the list more complete. If tracing is enabled across
> > suspend/resume you'll hit that one as well:
> > 
> > WARNING: at /home/tglx/work/kernel/git/linux-2.6/kernel/trace/ring_buffer.c:1392 rb_reserve_next_event+0x133/0x27c()
> > 
> > Negative timestamp delta which is probably due to sched_clock not yet
> > adjusted to the TSC which got reset.
> 
> Perhaps we need to prevent tracing during a "blackout period" of suspend 
> to ram?

Perhaps we need to figure out why this is happening and how we best
deal with it. Disabling functionality just because we can not deal
with it right now is not a solution.

Thanks,

	tglx
