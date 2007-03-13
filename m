Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXCMTvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXCMTvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXCMTvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:51:41 -0400
Received: from [212.12.190.65] ([212.12.190.65]:33045 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752145AbXCMTvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:51:40 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RSDL-0.30] sched: rsdl improve latencies with differential nice -1
Date: Tue, 13 Mar 2007 22:54:28 +0300
User-Agent: KMail/1.5
Cc: ck@vds.kolivas.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703132254.28281.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Wednesday 14 March 2007 03:03, Con Kolivas wrote:
> > On Wednesday 14 March 2007 02:31, Con Kolivas wrote:
> > > On Monday 12 March 2007 22:26, Al Boldi wrote:
> > > > I think, it should be possible to spread this max expiration latency
> > > > across the rotation, should it not?
> > >
> > > Can you try the attached patch please Al and Mike? It "dithers" the
> > > priority bitmap which tends to fluctuate the latency a lot more but in
> > > a cyclical fashion. This tends to make the max latency bound to a
> > > smaller value and should make it possible to run -nice tasks without
> > > killing the latency of the non niced tasks. Eg you could possibly run
> > > X nice -10 at a guess like we used to in 2.4 days. It's not essential
> > > of course, but is a workaround for Mike's testcase.
> >
> > Oops, one tiny fix. This is a respin of the patch, sorry.
>
> A few other minor things would need to be updated before this patch is in
> a good enough shape to join the rsdl patches. This one will be good for
> testing though.

Applied against v0.30 mainline.  It only works on prio +16 to +19.


Thanks!

--
Al

