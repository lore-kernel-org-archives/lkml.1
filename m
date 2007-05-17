Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbXEQJU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbXEQJU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbXEQJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:20:20 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:46931 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbXEQJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:20:19 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Brad Campbell <brad@wasp.net.au>
Subject: Re: Standalone swap prefetch patch for mainline
Date: Thu, 17 May 2007 19:20:13 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <200705141210.43614.kernel@kolivas.org> <4649C789.6050305@wasp.net.au>
In-Reply-To: <4649C789.6050305@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171920.13333.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 00:45, Brad Campbell wrote:
> Con Kolivas wrote:
> > I've had a few requests for a standalone patch implementing swap prefetch
> > for mainline.
> >
> > Here is a patch that is a current rollup that should apply and work for
> > vanilla 2.6.21 (ie not a -ck kernel):
> >
> > http://ck.kolivas.org/patches/swap-prefetch/2.6.21-swap_prefetch-38.patch
>
> Heh.. 20 mins after I finished scraping the relevant bits from -ck1 and
> patching my kernel this arrives!
>
> <WARNING - Fanboy rant ahead>
>
> I don't normally get/take the time to pass personal comment, but I have to
> say Con I've just taken a 2.6.21 kernel, applied your 0.48 SD scheduler and
> swap-prefetch from -ck1 (needed to separate them out so I could also apply
> suspend2) and it's like I've bought a new machine.
>
> I'm running on a tiny Vaio with a 4800RPM 1.8" drive, so it's not fast by
> any stretch of the imagination. But the combination of SD and swap-prefetch
> has given it a new lease on life completely.
>
> Really, you have done a great job with SD. I was so impressed I built a new
> kernel for my Core Duo Mac Mini with the full 2.6.21-ck1 patchset. I wish
> I'd tried it years ago!
>
> This also prompted me to have a play with CFS, but for my desktop workload
> on either machine, SD just "felt" better (for whatever that may be worth).
>
> +1 for SD
> +1 for swap-prefetch

Great! Thanks for the feedback. I'm pleased that people don't just naturally 
assume CFS will be better and are still willing to test SD. I'm even more 
pleased that you're finding it better than CFS too :)

-- 
-ck
