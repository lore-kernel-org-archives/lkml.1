Return-Path: <linux-kernel-owner+w=401wt.eu-S1766965AbXDEMYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766965AbXDEMYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766967AbXDEMYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:24:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:45173 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1766965AbXDEMYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:24:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/0z3scUh30kx2FLafulzE9tFnD25veYZ9nkG9aTi
	0qT6GIYPz0mlW8
Subject: Re: [test] sched: SD-latest versus Mike's latest
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <20070405121234.GA30314@elte.hu>
References: <200703290237.38777.kernel@kolivas.org>
	 <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <200704031237.21946.kernel@kolivas.org>
	 <1175578270.6342.12.camel@Homer.simpson.net>
	 <20070403060109.GA6708@elte.hu>
	 <1175770950.6609.16.camel@Homer.simpson.net>
	 <20070405115447.GA24138@elte.hu>
	 <1175775012.6609.31.camel@Homer.simpson.net>
	 <20070405121234.GA30314@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 14:24:37 +0200
Message-Id: <1175775877.7144.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 14:12 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > re-testing the weak points of the vanilla scheduler + Mike's:
> > > 
> > >  - thud.c:    this workload has almost unnoticeable effect
> > >  - fiftyp.c:  noticeable, but alot better than previously!
> > 
> > Hmm.  Here fiftyp.c is utterly harmless.  If you have a second, can 
> > you send me a top snapshot?  If you're running many of them, it can 
> > take a bit for the throttle to catch them all.
> 
> ah, indeed - i ran 10 of them and letting them run for a bit smoothes 
> things out.

Ok, I didn't try 10 of them.  It can still get a bit ragged here, so I
may have to latch the throttle for a bit to make sure they have to
maintain improved behavior to get unleashed.  5 of them get instantly
nailed, and stay nailed.

	-Mike

