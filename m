Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbXCEL6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbXCEL6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933194AbXCEL6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:58:13 -0500
Received: from [212.12.190.39] ([212.12.190.39]:32882 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933190AbXCEL6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:58:12 -0500
From: Al Boldi <a1426z@gawab.com>
To: mjt@nysv.org (Markus =?iso-8859-1?q?T=F6rnqvist?=)
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 5 Mar 2007 14:59:44 +0300
User-Agent: KMail/1.5
Cc: Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703050834.45712.a1426z@gawab.com> <20070305060732.GQ30401@nysv.org>
In-Reply-To: <20070305060732.GQ30401@nysv.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200703051459.44206.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Törnqvist wrote:
> On Mon, Mar 05, 2007 at 08:34:45AM +0300, Al Boldi wrote:
> >Ok, gears is smooth when you run "make -j4", but with "nice make -j4",
> > gears becomes bursty.  This looks like a problem with nice-levels.  In
> > general, looking subjectively at top d.1, procs appear to show jerkiness
> > when nice'd.
>
> Don't use glxgears, please. Ever. Unless you want meaningless gears.
>
> It displays totally erratic behaviour anyway, and does sched_yield (strace
> tells us this) which means IT GIVES UP ITS TIME TO RUN, ie yields the
> cpu to someone else.

I just strace'd it here.  It doesn't show any yield in the mesa-5.0 version.  
Which version are you using?

> >Do you have an objective test-case that can show the even-ness of RSDL in
> >both nice'd and normal scenarios?
>
> A big movie, like DVD-quality, full resolution should do the trick.
> That's what I used ;)

The problem with audio/video is that they usually do buffering, which hides 
scheduler anomalies.

> Debian and Ubuntu at least ship "stress" which I also used and reniced
> in-flight with excellent results, but do note to start off with small
> settings and work up or you might overcommit your box, in a way which
> no scheduler can handle.

Can you give a link?


Thanks!

--
Al

