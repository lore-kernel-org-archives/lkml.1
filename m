Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXDIT4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXDIT4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXDIT4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:56:11 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:42594 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965034AbXDIT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:56:10 -0400
Message-ID: <461A9A03.9070602@gmail.com>
Date: Mon, 09 Apr 2007 21:54:43 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
CC: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com> <1176092598.6355.22.camel@Homer.simpson.net> <461A2E39.8060106@gmail.com> <20070409132717.GA10489@rhlx01.hs-esslingen.de>
In-Reply-To: <20070409132717.GA10489@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2007 03:27 PM, Andreas Mohr wrote:

> And I really don't see much difference whatsoever to the I/O scheduler
> area: some people want predictable latency, while others want maximum
> throughput or fastest operation for seek-less flash devices (noop).
> Hardware varies similarly greatly has well:
> Some people have huge disk arrays or NAS, others have a single flash disk.
> Some people have a decaying UP machine, others have huge SMP farms.

I do agree, and yes, I/O scheduling seems to not have suffered from the 
choice although I must say I'm not sure how much use each I/O scheduler 
individualy sees.

If one CPU scheduler can be good enough then it would better to just 
have that one, but well, yes, maybe it can't. I certainly believe any 
one scheduler can't avoid breaking down onder some condition. Demand is 
just too varied.

I find it interesting that you see SD as a server scheduler and I guess 
deterministic behaviour does point in that direction somewhat. I would 
be enabling it on the desktop though, which probably is _some_ argument 
on having multiple schedulers.

Rene.

