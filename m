Return-Path: <linux-kernel-owner+w=401wt.eu-S1030790AbXCNJ2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790AbXCNJ2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030799AbXCNJ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:28:13 -0400
Received: from mail18.syd.optusnet.com.au ([211.29.132.199]:47854 "EHLO
	mail18.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030790AbXCNJ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:28:12 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] [RSDL-0.30] sched: rsdl improve latencies with  differential nice
Date: Wed, 14 Mar 2007 20:25:58 +1100
User-Agent: KMail/1.9.5
Cc: Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703140231.28314.kernel@kolivas.org> <1173863615.7822.86.camel@Homer.simpson.net>
In-Reply-To: <1173863615.7822.86.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703142026.05016.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 20:13, Mike Galbraith wrote:
> On Wed, 2007-03-14 at 02:31 +1100, Con Kolivas wrote:
> > Can you try the attached patch please Al and Mike? It "dithers" the
> > priority bitmap which tends to fluctuate the latency a lot more but in a
> > cyclical fashion. This tends to make the max latency bound to a smaller
> > value and should make it possible to run -nice tasks without killing the
> > latency of the non niced tasks. Eg you could possibly run X nice -10 at a
> > guess like we used to in 2.4 days. It's not essential of course, but is a
> > workaround for Mike's testcase.
>
> Oh my.  I thought I was all done staring mindlessly at gforce (chinese
> water torture).  Oh well, a few more brain cells dying of boredom won't
> kill me I guess ;-)  Will give it a shot.

No don't. It's buggy and you missed the warning. Boy were you lucky I was 
looking right now.

-- 
-ck
