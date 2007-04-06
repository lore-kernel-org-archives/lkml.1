Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXDFKsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXDFKsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXDFKsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:48:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:40691 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752599AbXDFKsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:48:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18i3DB9vE0iTN0UlU0BzD+mn6jKjJdyQJeOt18d+O
	aG3UZsiplvgL36
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704061928.39155.kernel@kolivas.org>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704061103.34489.kernel@kolivas.org>
	 <1175850471.22272.8.camel@Homer.simpson.net>
	 <200704061928.39155.kernel@kolivas.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 12:48:39 +0200
Message-Id: <1175856519.7546.12.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 19:28 +1000, Con Kolivas wrote:
> On Friday 06 April 2007 19:07, Mike Galbraith wrote:
> > On Fri, 2007-04-06 at 11:03 +1000, Con Kolivas wrote:
> > > On Thursday 05 April 2007 21:54, Ingo Molnar wrote:
> > > >  - fiftyp.c:  noticeable, but alot better than previously!
> > >
> > > fiftyp.c seems to have been stumbled across by accident as having an
> > > effect when Xenofon was trying to recreate Mike's 50% x 3 test case. I
> > > suggest a ten percent version like the following would be more useful as
> > > a test for the harmful effect discovered in fiftyp.c. (/me throws in
> > > obligatory code style change).
> > >
> > > Starts 15 processes that sleep ten times longer than they run. Change
> > > forks to 15 times the number of cpus you have and it should work on any
> > > size hardware.
> >
> > I was more focused on the general case, but all I should have to do to
> > de-claw all of these sleep exploits is account rr time (only a couple of
> > lines, done and building now).  It's only a couple of lines.
> 
> The more you try to "de-claw" these sleep exploits the less effective you make 
> your precious interactive estimator. Feel free to keep adding endless tweaks 
> to undo the other tweaks in order to try and achieve what SD has by design.

I haven't seen SD achieve what it's design docs claim yet, so yup, I'm
going to keep right on trying to fix the corner cases in what we have
that _does_ give me the interactivity I want.

	-Mike

