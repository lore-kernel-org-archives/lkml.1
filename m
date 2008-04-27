Return-Path: <linux-kernel-owner+w=401wt.eu-S1759710AbYD0A3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710AbYD0A3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYD0A3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:29:14 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:51390 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbYD0A3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:29:13 -0400
Date: Sat, 26 Apr 2008 17:29:12 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Erik Bosman <ejbosman@cs.vu.nl>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
In-Reply-To: <4813BED5.7070000@zytor.com>
Message-ID: <alpine.DEB.1.10.0804261725480.6108@twinlark.arctic.org>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <517f3f820804140357k62b3bff4p555ba6a5b9438c35@mail.gmail.com> <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl> <alpine.DEB.1.10.0804261546140.6108@twinlark.arctic.org> <4813B1EF.5090806@zytor.com>
 <alpine.DEB.1.10.0804261612430.6108@twinlark.arctic.org> <4813BED5.7070000@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008, H. Peter Anvin wrote:

> dean gaudet wrote:
> > On Sat, 26 Apr 2008, H. Peter Anvin wrote:
> > 
> > > dean gaudet wrote:
> > > > i might be too late... but shouldn't these #defines be PR_SET_RDTSC and
> > > > PR_GET_RDTSC or something like that?
> > > > 
> > > > to me calling them PR_SET_TSC/PR_GET_TSC just seem like alternative ways
> > > > to
> > > > change/get the TSC (and could even reduce to portable TSC
> > > > implementations...
> > > > since such registers do exist on other architectures).
> > > > 
> > > I would argue no, the flag is "is the TSC available".  RDTSC is an
> > > x86-specific name and would map poorly onto other architectures.
> > 
> > yeah but "SET TSC" to me reads as "set the TSC".... i read nothing about
> > making some instruction available or not.
> > 
> > although clock_gettime/clock_settime could more natural APIs for such
> > things.
> > 
> 
> PR_SET/PR_GET are the common prefixes, though.

that's not what's at issue... "PR_SET_TSC" reads "set the TSC" ... it 
doesn't read "set the ability to use the rdtsc instruction". 
PR_SET_RDTSC_ENABLE would seem to be more accurate... or even 
PR_SET_CR4_TSD which is what it really does :)

-dean
