Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbXCQEYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbXCQEYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 00:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbXCQEYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 00:24:08 -0400
Received: from rwcrmhc11.comcast.net ([216.148.227.151]:63105 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbXCQEYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 00:24:06 -0400
Subject: Re: RSDL v0.31
From: Nicholas Miell <nmiell@comcast.net>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1174084207.7009.9.camel@Homer.simpson.net>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 21:24:03 -0700
Message-Id: <1174105443.3144.4.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 23:30 +0100, Mike Galbraith wrote:
> On Sat, 2007-03-17 at 08:13 +1100, Con Kolivas wrote:
> > On Saturday 17 March 2007 02:34, Mike Galbraith wrote:
> > > On Sat, 2007-03-17 at 00:40 +1100, Con Kolivas wrote:
> > > > Here are full patches for rsdl 0.31 for various base kernels. A full
> > > > announce with a fresh -mm series will follow...
> > > >
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3-rsdl-0.31.patch
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> > > >31.patch
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.31
> > > >.patch
> > >
> > > It still has trouble with the x/gforce vs two niced encoders scenario.
> > > The previously reported choppiness is still present.
> > >
> > > I suspect that x/gforce landing in the expired array is the trouble, and
> > > that this will never be smooth without some kind of exemption.  I added
> > > some targeted unfairness to .30, and it didn't help much at all.
> > >
> > > Priorities going all the way to 1 were a surprise.
> > 
> > It wasn't going to change that case without renicing X.
> 
> Con.  You are trying to wedge a fair scheduler into an environment where
> totally fair simply can not possibly function.
> 
> If this is your final answer to the problem space, I am done testing,
> and as far as _I_ am concerned, your scheduler is an utter failure.
> 

Sorry, I haven't really been following this thread and now I'm confused.

You're saying that it's somehow the scheduler's fault that X isn't
running with a high enough priority?

-- 
Nicholas Miell <nmiell@comcast.net>

