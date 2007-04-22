Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbXDVVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbXDVVWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXDVVWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:22:18 -0400
Received: from mail37.syd.optusnet.com.au ([211.29.133.221]:49294 "EHLO
	mail37.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009AbXDVVWR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:22:17 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Thomas Backlund <tmb@mandriva.org>
Subject: Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.46
Date: Mon, 23 Apr 2007 07:21:08 +1000
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
References: <200704230103.15265.kernel@kolivas.org> <1177264715.4729.2.camel@turion34.supernet.tld>
In-Reply-To: <1177264715.4729.2.camel@turion34.supernet.tld>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704230721.09218.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 03:58, Thomas Backlund wrote:
> mån 2007-04-23 klockan 01:03 +1000 skrev Con Kolivas:
> > Yet another significant bugfix for SMP balancing was just posted for the
> > staircase deadline cpu scheduler which improves behaviour dramatically on
> > any SMP machine.
> >
> > Thanks to Willy Tarreau for noticing more bugs.
> >
> > As requested was a version in the Makefile so this version of the patch
> > adds -sd046 to the kernel version.
> >
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.46.patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.46.patch
> >
> > Renicing X to -10, while not essential, may be desirable on the desktop.
> > Unlike the CFS scheduler which renices X without your intervention to
> > nice -19, the SD patches do not alter nice level on their own.
> >
> > See the patch just posted called 'sched: implement staircase deadline
> > scheduler load  weight fix' for details of the fixes.
> >
> > Thanks to all testing and giving feedback.
> >
> > Well I'm exhausted...
>
> This one broke 2.6.20.7 build...
>
> kernel/sched.c: In function ‘dependent_sleeper’:
> kernel/sched.c:3319: error: ‘DEF_TIMESLICE’ undeclared (first use in
> this function)
> kernel/sched.c:3319: error: (Each undeclared identifier is reported only
> once
> kernel/sched.c:3319: error: for each function it appears in.)

Apologies it was a blind merge.

Use this instead
http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.46-1.patch

-- 
-ck
