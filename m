Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZEEHwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZEEHwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZEEHvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:51:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:35145 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754636AbZEEHvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:51:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18rFPB7HUQrIILTMte85+HSRqiUim/lvy0eGaorsH
	OiE4JEZtuB0tLf
Subject: Re: CFS not suitable for desktop computers
From: Mike Galbraith <efault@gmx.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Nico =?ISO-8859-1?Q?Sch=FCmann?= <spam@nico22.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1241502128.5505.62.camel@marge.simson.net>
References: <49FDEFD1.8020608@nico22.de>
	 <1241424835.26855.102.camel@marge.simson.net> <49FF06D0.80109@nico22.de>
	 <49FF57AC.7070104@nortel.com>  <1241502128.5505.62.camel@marge.simson.net>
Content-Type: text/plain; charset=utf-8
Date: Tue, 05 May 2009 09:51:32 +0200
Message-Id: <1241509892.5531.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 07:42 +0200, Mike Galbraith wrote:
> On Mon, 2009-05-04 at 15:01 -0600, Chris Friesen wrote:
> > Nico Schümann wrote:
> > > Thank you Ray Lee and Mike Galbraith for your responses, I ran the 
> > > script and attached its gathered information.
> > > 
> > > Mike Galbraith wrote:
> > >> How hard is hard?  Can you describe the loads you're having trouble
> > >> with, and the hardware you're running them on?
> > >>
> > >>   
> > > I could reproduce "hard" load by just compiling the linux kernel, make 
> > > -j3 while reading mails with Thunderbird, which is not that hard 
> > > foreground load. Thunderbird starts reacting really slowly while compiling.
> > 
> > I wonder if this could be related to I/O rather than the task scheduler 
> > proper.
> 
> That's something I was wondering as well, particularly when I noticed
> he's using data=journal and anticipatory io-scheduler.

Well, I offlined 3 of 4 cores, set data=journal, and throttled down to
1.6GHz to load test a bit, and it didn't make any difference with
_Evolution_ and a make -j3 running.  Evolution remained responsive.

I can feel the load though. X here is unaccelerated (damn nvidia), so
despite heftier core (Q6600), CPU usage while browsing mail is pretty
similar to Nico's data, often heavier.  Behavior I see here isn't bad at
all.. unless I move a window that is, X then becomes a major oinker, so
I feel every bit of load.  That's unpleasant, but expected.

I have an old P4 lying about (has X candy).  I'll update it and try some
UP testing.  Can't test Thunderbird though.

	-Mike

