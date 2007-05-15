Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXEOOpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXEOOpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 10:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXEOOpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 10:45:35 -0400
Received: from wasp.net.au ([203.190.192.17]:57665 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbXEOOpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 10:45:34 -0400
Message-ID: <4649C789.6050305@wasp.net.au>
Date: Tue, 15 May 2007 18:45:29 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: Standalone swap prefetch patch for mainline
References: <200705141210.43614.kernel@kolivas.org>
In-Reply-To: <200705141210.43614.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> I've had a few requests for a standalone patch implementing swap prefetch for 
> mainline.
> 
> Here is a patch that is a current rollup that should apply and work for 
> vanilla 2.6.21 (ie not a -ck kernel):
> 
> http://ck.kolivas.org/patches/swap-prefetch/2.6.21-swap_prefetch-38.patch
> 

Heh.. 20 mins after I finished scraping the relevant bits from -ck1 and patching my kernel this arrives!

<WARNING - Fanboy rant ahead>

I don't normally get/take the time to pass personal comment, but I have to say Con I've just taken a 
2.6.21 kernel, applied your 0.48 SD scheduler and swap-prefetch from -ck1 (needed to separate them 
out so I could also apply suspend2) and it's like I've bought a new machine.

I'm running on a tiny Vaio with a 4800RPM 1.8" drive, so it's not fast by any stretch of the 
imagination. But the combination of SD and swap-prefetch has given it a new lease on life completely.

Really, you have done a great job with SD. I was so impressed I built a new kernel for my Core Duo 
Mac Mini with the full 2.6.21-ck1 patchset. I wish I'd tried it years ago!

This also prompted me to have a play with CFS, but for my desktop workload on either machine, SD 
just "felt" better (for whatever that may be worth).

+1 for SD
+1 for swap-prefetch

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
