Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbYDVM0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbYDVM0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYDVMZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:25:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:57782 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752328AbYDVMZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:25:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19sulURQ4Bs4qUrZEPRwb7GjPJ6rueazmvb0Ea5/2
	rSu26aceGxcCm5
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080422085905.GA9939@elte.hu>
References: <20080419181304.GB21353@elte.hu>
	 <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu>
	 <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu>
	 <1208854300.4695.7.camel@marge.simson.net>  <20080422085905.GA9939@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 14:25:54 +0200
Message-Id: <1208867154.4873.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 10:59 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > the 700-800 msecs of delays you see are very "brutal" so there must 
> > > be something fundamentally wrong going on here.
> > 
> > I'm seeing latency hits with 26.git, whereas 25 is hit free.
> 
> ok. I think what happens is that your broken sched-clock hid the real 
> breakage. Lets try fix the real breakage now.
> 
> I've uploaded a new sched-devel.git that is against very latest -git, 
> could you try ftrace (with a sufficiently large 
> /debug/tracing/tracing_max_entries value) - perhaps the 
> worst-case-wakeup-latency tracer shows large latencies? If not, then 
> maybe the sched_switch tracer gives a better insight into what's 
> happening?

Well, looks like this is going to have to wait.  sched-devel is locking
hard on me, both sched-devel and .git are losing my darn keyboard right
in the middle of things, and my serial ports are (still) so screwed up I
can't get minicom working right.  Arg.

	-Mike

