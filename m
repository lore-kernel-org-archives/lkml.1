Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXDCGLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXDCGLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXDCGLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:11:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:38177 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753188AbXDCGLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:11:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Y/fM7J1SYoXgFWKcDfBZE2kKmmDWAUaL2CXIH5Y
	RPXEMSQgYHT8Tb
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <20070403060109.GA6708@elte.hu>
References: <200703290237.38777.kernel@kolivas.org>
	 <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <200704031237.21946.kernel@kolivas.org>
	 <1175578270.6342.12.camel@Homer.simpson.net>
	 <20070403060109.GA6708@elte.hu>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 08:11:50 +0200
Message-Id: <1175580710.6751.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 08:01 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > Try two instances of chew.c at _differing_ nice levels on one cpu on 
> > > mainline, and then SD. This is why you can't renice X on mainline.
> > 
> > How about something more challenging instead :)
> > 
> > The numbers below are from my scheduler tree with massive_intr running 
> > at nice 0, and chew at nice 5.  Below these numbers are 100 lines from 
> > the exact center of chew's output.
> > 
> > (interactivity remains intact with this rather heavy load)
> 
> looks interesting - could you send the patch?

Sorry, that tree is not _even_ ready for viewing yet.
(and it's got an occasional oops bug i have to kill)

	-Mike

