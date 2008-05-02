Return-Path: <linux-kernel-owner+w=401wt.eu-S935353AbYEBTi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353AbYEBTi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762285AbYEBTiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:38:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:40169 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762051AbYEBTit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:38:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4s3QLc7O4X1UltnHcQSFd716qvq3+k7R2mL3g1y
	grjcOBTuA5OMuj
Subject: Re: Horrendous Audio Stutter - current git
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805021749.10205.elendil@planet.nl>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209731822.25271.4.camel@marge.simson.net>
	 <1209740523.4776.1.camel@marge.simson.net>
	 <200805021749.10205.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 02 May 2008 21:38:43 +0200
Message-Id: <1209757123.4693.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 17:49 +0200, Frans Pop wrote:
> On Friday 02 May 2008, Mike Galbraith wrote:
> > On Fri, 2008-05-02 at 14:37 +0200, Mike Galbraith wrote:
> > > On Fri, 2008-05-02 at 08:21 -0400, Parag Warudkar wrote:
> > > > On Fri, May 2, 2008 at 8:09 AM, Mike Galbraith <efault@gmx.de> wrote:
> > > > >  Hm.  I've stumbled across a regression that may be related.  Can
> > > > > you please try the attached with group scheduling enabled in
> > > > > current git?
> > > >
> > > > In file included from kernel/sched.c:1902:
> > > > kernel/sched_fair.c: In function 'print_cfs_rq_tasks':
> > > > kernel/sched_fair.c:1602: error: implicit declaration of function
> > > > 'calc_delta_weight'
> > > > kernel/sched_fair.c:1603: warning: format '%lu' expects type 'long
> > > > unsigned int', but argument 5 has type 'int'
> > > > make[1]: *** [kernel/sched.o] Error 1
> > > > make: *** [kernel] Error 2
> > > >
> > > > 'calc_delta_weight' or a replacement not found easily to fix it up!
> > >
> > > Oops, I have an unrelated patch in my tree which you also need.
> >
> > I see that Peter has a fix, so don't bother.
> 
> Maybe not. It looks like Parag may have been seeing a combination of two 
> different issues: the one that Peter fixed and one related to group 
> scheduling.

There are definitely issues with that commit, but I'm not at all sure
they manifest themselves with this workload in any heavy-weight way.  My
thought was only that it's negative effects could be compounded by group
scheduling.

	-Mike

