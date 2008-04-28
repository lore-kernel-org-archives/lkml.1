Return-Path: <linux-kernel-owner+w=401wt.eu-S937980AbYD1VSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937980AbYD1VSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935206AbYD1VS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:18:27 -0400
Received: from 1wt.eu ([62.212.114.60]:3482 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936090AbYD1VS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:18:26 -0400
Date: Mon, 28 Apr 2008 23:18:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4 usage statistics
Message-ID: <20080428211812.GA19093@1wt.eu>
References: <20080428202433.GA13417@hera.kernel.org> <20080428205631.GA2813@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428205631.GA2813@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon, Apr 28, 2008 at 11:56:31PM +0300, Adrian Bunk wrote:
> Just a note that some "how many" and "which version exactly" data is 
> available from [1] which is generated from data users send through a 
> cron job with data from nearly 5000 machines reported during the last 
> 60 days.

I've already seen this one sometime ago, but realized that you will never
get stats from sensible systems there. For instance, none of my customers
running linux in production would ever accept to permit an HTTP communication
between any of their servers with another one on the need, and especially
when it comes to reporting stats about *their* versions.

Also, I recently realized that several high-grade commercial products still
ship with 2.4 in it. I even know about one which never said it used Linux,
running on MVL 2.4.2 :-)

Of course those ones do not care a dime about recent versions. But it looks
like the falling curve has reached a stabilization point, because such
products would have had hundreds of opportunities to upgrade. Reason why
I'm wondering and asking them directly.

> When clicking on a version (e.g. "2.4.27") you can also see which of 
> them are distribution kernels.
> 
> Kinda shocking that 14% of these machines are not running kernel 2.6 ...
> 
> Considering how this data is generated it obviously shows only part of 
> the picture, and your survey will hopefully bring data what we could do 
> for making kernel 2.6 more attractive (not meant against your work, but 
> we should aim at bringing users to 2.6).

100% agreed, and it's the orientation of the survey. At least 2.6.16 could
be a first step for those who need high code stability.

Speaking for my case, at Exosec we still use 2.4 a lot. Main reason is that
we are used to apply a lot of patches. And maintaining a kernel which does
nearly not change in 6 months is really a joy. I have already thought about
moving to 2.6.16, but I would have had to port my patches, and was not
satisfied by the crapp^Wold scheduler which caused real performance issues
for my workload. Since I would have gained nothing in this operation, it
was easier to stick to 2.4.

I'm waiting for other people's excuses now :-)

I'm really tempted by making a new attempt with 2.6.25, but let's let it
settle down first.

> cu
> Adrian
> 
> [1] http://counter.li.org/reports/systemstats.php

Cheers,
Willy

