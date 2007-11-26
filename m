Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbXKZFGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbXKZFGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 00:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXKZFGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 00:06:17 -0500
Received: from [82.147.213.242] ([82.147.213.242]:52067 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750827AbXKZFGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 00:06:16 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 00:06:15 EST
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Date: Mon, 26 Nov 2007 07:57:00 +0300
References: <20071125172237.GC6658@kernel.dk>
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200711260757.00386.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Sun, Nov 25 2007, Adrian Bunk wrote:
> > Is there any technical reason why we need 4 different schedulers at all?
>
> Until we have the perfect scheduler :-)
>
> With some hard work and testing, we should be able to get rid of 'as'.
> It still beats cfq for some of the workloads that deadline is good at,
> so not quite yet.
>
> > I have the gut feeling that the usual thing happens and people e.g. not
> > report some cfq problems because as works for them...
>
> There's always a risk with "duplicate", like several drivers for the
> same hardware. I'm not disputing that.

Actually, both 'cfq' and 'as' are broken, and have been repeatedly reported 
as such.  Deadline is the only one that currently looks sane, and seems like 
a good starting point for a more involved iosched.  But keep in mind, the 
fact that 'cfq' and 'as' are broken may also point to a lower-level block-io 
problem.  So, incrementally improving deadline may help discovering the 
problems both 'cfq' and 'as' are plagued with.


Thanks!

--
Al

