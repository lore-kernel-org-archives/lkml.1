Return-Path: <linux-kernel-owner+w=401wt.eu-S1030731AbXCNJNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030731AbXCNJNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030705AbXCNJNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:13:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:34705 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030731AbXCNJNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:13:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18HmEhEVFgHuMmMVEV51pG9xOQEJLyD6lA44CbSd1
	pHgM4rUp3NMFMC
Subject: Re: [PATCH] [RSDL-0.30] sched: rsdl improve latencies with
	differential nice
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703140231.28314.kernel@kolivas.org>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703121553.30462.kernel@kolivas.org>
	 <200703121426.00854.a1426z@gawab.com>
	 <200703140231.28314.kernel@kolivas.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 10:13:35 +0100
Message-Id: <1173863615.7822.86.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 02:31 +1100, Con Kolivas wrote:

> Can you try the attached patch please Al and Mike? It "dithers" the priority
> bitmap which tends to fluctuate the latency a lot more but in a cyclical
> fashion. This tends to make the max latency bound to a smaller value and
> should make it possible to run -nice tasks without killing the latency of the
> non niced tasks. Eg you could possibly run X nice -10 at a guess like we used
> to in 2.4 days. It's not essential of course, but is a workaround for Mike's
> testcase.
> 

Oh my.  I thought I was all done staring mindlessly at gforce (chinese
water torture).  Oh well, a few more brain cells dying of boredom won't
kill me I guess ;-)  Will give it a shot.

	-Mike

