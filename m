Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbXCMQJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbXCMQJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbXCMQJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:09:47 -0400
Received: from mail12.syd.optusnet.com.au ([211.29.132.193]:59452 "EHLO
	mail12.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbXCMQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:09:47 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [PATCH] [RSDL-0.30] sched: rsdl improve latencies with  differential nice -1
Date: Wed, 14 Mar 2007 03:08:39 +1100
User-Agent: KMail/1.9.5
Cc: Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703140231.28314.kernel@kolivas.org> <200703140303.36456.kernel@kolivas.org>
In-Reply-To: <200703140303.36456.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703140308.40038.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 03:03, Con Kolivas wrote:
> On Wednesday 14 March 2007 02:31, Con Kolivas wrote:
> > On Monday 12 March 2007 22:26, Al Boldi wrote:
> > > I think, it should be possible to spread this max expiration latency
> > > across the rotation, should it not?
> >
> > Can you try the attached patch please Al and Mike? It "dithers" the
> > priority bitmap which tends to fluctuate the latency a lot more but in a
> > cyclical fashion. This tends to make the max latency bound to a smaller
> > value and should make it possible to run -nice tasks without killing the
> > latency of the non niced tasks. Eg you could possibly run X nice -10 at a
> > guess like we used to in 2.4 days. It's not essential of course, but is a
> > workaround for Mike's testcase.
>
> Oops, one tiny fix. This is a respin of the patch, sorry.

A few other minor things would need to be updated before this patch is in a 
good enough shape to join the rsdl patches. This one will be good for testing 
though.

-- 
-ck
