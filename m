Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbYDUQbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbYDUQbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYDUQbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:31:33 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:42875 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431AbYDUQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:31:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] scheduler changes for v2.6.26
Date: Mon, 21 Apr 2008 18:31:28 +0200
User-Agent: KMail/1.9.9
References: <20080419181304.GB21353@elte.hu> <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu>
In-Reply-To: <20080421123903.GE9554@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211831.29976.elendil@planet.nl>
X-OriginalArrivalTime: 21 Apr 2008 16:31:30.0370 (UTC) FILETIME=[27571220:01C8A3CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008, you wrote:
> * Frans Pop <elendil@planet.nl> wrote:
> > Ingo Molnar wrote:
> > > Ingo Molnar (12):
> > >       sched: re-do "sched: fix fair sleepers"
> >
> > Has the regression [1] that was traced to this change been fixed now?
> >
> > The regression was confirmed to be also present in sched-devel.git at
> > the time of -rc8, so I'd expect it still to be valid unless of course
> > the cause was found since then.
>
> Peter reported a similar interactivity problem to be gone, so lets
> re-try this again - the change makes sense and if you see problems it's
> hiding something we really want to fix.

IIRC he mentioned seeing something himself during 2.6.25, but we'd already 
established that was unrelated to what I was seeing as his workaround 
(booting with nohz) did not work for me.

I can again reproduce the issue with sched-devel/latest :-(
latencytop regularly reports 500-700 msec latencies for amarokapp again 
while compiling glibc.

I expect that means it's also back in mainline?
What would be preferred for bugzilla: reopening the existing report (#10428) 
or opening a new one?

> It would be nice if you could 
> try sched-devel/latest because it has an improved ftrace "sched_switch"
> tracer where you can generate much longer traces of this incident. Try
> the new /debug/trace_entries runtime tunable.

I'll try to get the trace and will reply on the private thread we had.
I may need additional instructions though.

Cheers,
FJP
