Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXKZFae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXKZFae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 00:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbXKZFa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 00:30:26 -0500
Received: from [212.12.190.241] ([212.12.190.241]:39205 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750827AbXKZFaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 00:30:25 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Date: Mon, 26 Nov 2007 08:28:41 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20071125172237.GC6658@kernel.dk> <200711260757.00386.a1426z@gawab.com> <20071125211259.c69040fa.akpm@linux-foundation.org>
In-Reply-To: <20071125211259.c69040fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711260828.41021.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc's lovingly restored.  Please do not do that)

Thanks!  I'm replying off list.

> On Mon, 26 Nov 2007 07:57:00 +0300 Al Boldi <a1426z@gawab.com> wrote:
> > Jens Axboe wrote:
> > > On Sun, Nov 25 2007, Adrian Bunk wrote:
> > > > Is there any technical reason why we need 4 different schedulers at
> > > > all?
> > >
> > > Until we have the perfect scheduler :-)
> > >
> > > With some hard work and testing, we should be able to get rid of 'as'.
> > > It still beats cfq for some of the workloads that deadline is good at,
> > > so not quite yet.
> > >
> > > > I have the gut feeling that the usual thing happens and people e.g.
> > > > not report some cfq problems because as works for them...
> > >
> > > There's always a risk with "duplicate", like several drivers for the
> > > same hardware. I'm not disputing that.
> >
> > Actually, both 'cfq' and 'as' are broken, and have been repeatedly
> > reported as such.  Deadline is the only one that currently looks sane,
> > and seems like a good starting point for a more involved iosched.  But
> > keep in mind, the fact that 'cfq' and 'as' are broken may also point to
> > a lower-level block-io problem.  So, incrementally improving deadline
> > may help discovering the problems both 'cfq' and 'as' are plagued with.
>
> Sorry, but these are vague and unuseful assertions.
>
> Please send bug reports, preferably with testcases which developers can
> use when fixing the bugs.

http://bugzilla.kernel.org/show_bug.cgi?id=5900


Thanks again!

--
Al

