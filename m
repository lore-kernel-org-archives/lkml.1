Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbYCGIsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbYCGIsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbYCGIsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:48:23 -0500
Received: from brick.kernel.dk ([87.55.233.238]:17313 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761495AbYCGIsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:48:22 -0500
Date: Fri, 7 Mar 2008 09:48:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080307084818.GK17940@kernel.dk>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu> <200803061506.19449.bzolnier@gmail.com> <20080306135532.GG17940@kernel.dk> <20080306211726.2DA8C93C881@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306211726.2DA8C93C881@tippex.mynet.homeunix.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06 2008, Anders Eriksson wrote:
> 
> jens.axboe@oracle.com said:
> >> I was a bit unclear on this, the problem is easily reproducible but _only_
> >> on Anders' system (I couldn't reproduce it with smartd here either).
> 
> > What IO scheduler is Anders using (and does it have an impact, eg does it
> > hang with deadline as well)? 
> 
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_IOSCHED="cfq"
> 
> On request here's a sysrq-t from smartd on -rc3, you also see exactly where 
> smartd gives up (using the gentoo default smasrtd.conf).

Can you try with noop or deadline as the default, to see if it
reproduces with them?

> Might a strace of smartd help?

Nope, looking at the trace it'll be stuck waiting for the ioctl to
finish.

-- 
Jens Axboe

