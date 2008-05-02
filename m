Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbYEBPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbYEBPCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbYEBPCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:02:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:60744 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753406AbYEBPCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:02:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/xCgB5cPfxBovC5QeVFU66pKjYCZgowZ9ywBJKTK
	evurhNh7hRZshs
Subject: Re: Horrendous Audio Stutter - current git
From: Mike Galbraith <efault@gmx.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
In-Reply-To: <1209731822.25271.4.camel@marge.simson.net>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209717278.13978.136.camel@twins>
	 <82e4877d0805020410u78c6f03fr8e8e53d5a19f6846@mail.gmail.com>
	 <1209730185.18055.21.camel@marge.simson.net>
	 <82e4877d0805020521t696cc4fbu6ffd182f84ae1a2e@mail.gmail.com>
	 <1209731822.25271.4.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 02 May 2008 17:02:03 +0200
Message-Id: <1209740523.4776.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 14:37 +0200, Mike Galbraith wrote:
> On Fri, 2008-05-02 at 08:21 -0400, Parag Warudkar wrote:
> > On Fri, May 2, 2008 at 8:09 AM, Mike Galbraith <efault@gmx.de> wrote:
> > >  Hm.  I've stumbled across a regression that may be related.  Can you
> > >  please try the attached with group scheduling enabled in current git?
> > 
> > In file included from kernel/sched.c:1902:
> > kernel/sched_fair.c: In function 'print_cfs_rq_tasks':
> > kernel/sched_fair.c:1602: error: implicit declaration of function
> > 'calc_delta_weight'
> > kernel/sched_fair.c:1603: warning: format '%lu' expects type 'long
> > unsigned int', but argument 5 has type 'int'
> > make[1]: *** [kernel/sched.o] Error 1
> > make: *** [kernel] Error 2
> > 
> > 'calc_delta_weight' or a replacement not found easily to fix it up!
> 
> Oops, I have an unrelated patch in my tree which you also need.

I see that Peter has a fix, so don't bother.

	-Mike

