Return-Path: <linux-kernel-owner+w=401wt.eu-S1767629AbXCIXSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767629AbXCIXSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767635AbXCIXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:18:44 -0500
Received: from waste.org ([66.93.16.53]:54822 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767629AbXCIXSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:18:43 -0500
Date: Fri, 9 Mar 2007 17:06:13 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309230612.GL10394@waste.org>
References: <20070309053931.GA10459@waste.org> <200703100918.05547.kernel@kolivas.org> <20070309222923.GK10394@waste.org> <200703101002.37920.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703101002.37920.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 10:02:37AM +1100, Con Kolivas wrote:
> On Saturday 10 March 2007 09:29, Matt Mackall wrote:
> > On Sat, Mar 10, 2007 at 09:18:05AM +1100, Con Kolivas wrote:
> > > On Saturday 10 March 2007 08:57, Con Kolivas wrote:
> > > > On Saturday 10 March 2007 08:39, Matt Mackall wrote:
> > > > > So what's different between makes in parallel and make -j 5? Make's
> > > > > job server uses pipe I/O to control how many jobs are running.
> > > >
> > > > Hmm it must be those deep pipes again then. I removed any quirks
> > > > testing for those from mainline as I suspected it would be ok. Guess
> > > > I"m wrong.
> > >
> > > I shouldn't blame this straight up though if NO_HZ makes it better.
> > > Something else is going wrong... wtf though?
> >
> > Just so we're clear, dynticks has only 'fixed' the single non-parallel
> > make load so far.
> 
> Ok, back to the pipe idea. Without needing a kernel recompile, can you try 
> running the make -j5 as a SCHED_BATCH task?

Seems the same.

Oddly, nice make -j 5 is better than batch (but not quite up to stock).

-- 
Mathematics is the supreme nostalgia of our time.
