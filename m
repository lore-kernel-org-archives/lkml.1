Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYL1P4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYL1P4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 10:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYL1P4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 10:56:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50196 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbYL1P4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 10:56:31 -0500
Date: Sun, 28 Dec 2008 13:56:08 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: 2.6.24.7-rt25 and 2.6.26.8-rt12
Message-ID: <20081228155608.GD28520@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <srostedt@redhat.com>
References: <1229752520.974.37.camel@localhost.localdomain> <20081228151026.GB28520@ghostprotocols.net> <20081228154007.GC28520@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228154007.GC28520@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Dec 28, 2008 at 01:40:07PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Sun, Dec 28, 2008 at 01:10:26PM -0200, Arnaldo Carvalho de Melo escreveu:
> > Em Sat, Dec 20, 2008 at 12:55:20AM -0500, Steven Rostedt escreveu:
> > > We are pleased to announce the 2.6.24.7-rt25 and 2.6.26.8-rt12 trees,
> > > which can be downloaded from the location:
> > > 
> > >   http://rt.et.redhat.com/download/
> > > 
> > > Information on the RT patch can be found at:
> > > 
> > >   http://rt.wiki.kernel.org/index.php/Main_Page
> > > 
> > > Changes since 2.6.26.6-rt11
> > 
> > I managed to boot 2.6.26.8-rt12 once, but it oopsed when I started a
> > market data workload while generating load with a make -j 64 kernel
> > compile, couldn't get the proper backtrace because I was swamped with
> > /proc/sys/kernel/hung_task_timeout_secs related messages.
> > 
> > When I tried to reboot to try again after setting
> > /proc/sys/kernel/hung_task_timeout_secs to zero I got the backtrace
> > below, will try again and report.

After disabling hung tasks reporting I get no oops but all tasks seem to
be hung :-\

Giving up for now, please advise on what other info you may need.

- Arnaldo
