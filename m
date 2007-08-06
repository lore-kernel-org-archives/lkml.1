Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbXHFW7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbXHFW7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764766AbXHFW7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:59:11 -0400
Received: from smtp1.Stanford.EDU ([171.67.22.28]:53007 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764593AbXHFW7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:59:10 -0400
X-Greylist: delayed 1725 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 18:59:10 EDT
Date: Mon, 6 Aug 2007 17:26:33 -0500
From: Gautam Iyer <gautam@math.stanford.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Increased CPU usage after upgrading to 2.6.21
Message-ID: <20070806222632.GI24652@math.stanford.edu>
References: <20070718164347.GE9506@math.stanford.edu> <20070806183207.GB5761@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806183207.GB5761@ucw.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Spam-Score: -101.1
X-Scan-Signature: d3e02c565cd5ac634b2ff74b6ba3e13d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 06:32:08PM +0000, Pavel Machek wrote:

> > PS: I'm using the kernel with Gentoo patchset. But I confirmed the above
> >     persists with the vanilla kernels.
> > 
> > PPS: I also played around with the timer frequency, and premption model.
> >      Would those make a difference to CPU usage?
> 
> Yes. Or rather, it will make accounting more accurate, so that you see
> that 1% cpu usage, unlike previous kernels where something still ate
> cpu but kernel did not know it.

Hi,

Thanks for your response.

Well, I now recompiled all the kernels I used with all possible
permutations of these options (yes, that did take the better part of
last week).

I can confirm that under identical option for the preemption model, and
timer frequency, the following happen:

    1. With 2.6.19 (gentoo-r5), the system claims to use 0% CPU when
       idle.

    2. With 2.6.21 (gentoo-r4), 2.6.22 (gentoo-r1) and the unmodified
       2.6.22.1 kernel, the system claims to use between 1% and 3% CPU
       when idle.

When I run "top", I see that all non-idle processes running claim to
take 0% CPU (except occasionally the terminal I'm running top in, and
top itself). The CPU line in the top output consistently claims
something like

    CPU(s): .3%us, 1.0%sy, ...

I'm not sure if this is something I should be worried about or not,

Thanks again,

Gautam

-- 
'Budget' -- A method for going broke methodically.
