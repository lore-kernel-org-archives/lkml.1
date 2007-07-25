Return-Path: <linux-kernel-owner+w=401wt.eu-S1763991AbXGYLGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763991AbXGYLGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbXGYLGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:06:25 -0400
Received: from brick.kernel.dk ([80.160.20.94]:12590 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759529AbXGYLGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:06:25 -0400
Date: Wed, 25 Jul 2007 13:06:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070725110651.GQ3287@kernel.dk>
References: <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070725014912.35c7e325.akpm@linux-foundation.org> <20070725085204.GA22067@elte.hu> <20070725020003.63144fd6.akpm@linux-foundation.org> <20070725090439.GA26286@elte.hu> <20070725021730.a9a624b3.akpm@linux-foundation.org> <20070725092342.GA29814@elte.hu> <20070725095910.GL3287@kernel.dk> <20070725110402.GA19060@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725110402.GA19060@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > Subject: blktrace: use cpu_clock() instead of sched_clock()
> > > From: Ingo Molnar <mingo@elte.hu>
> > > 
> > > use cpu_clock() instead of sched_clock(). (the latter is not a proper
> > > clock-source)
> > > 
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > I tested it, seems to work fine for me.
> > 
> > Acked-by: Jens Axboe <jens.axboe@oracle.com>
> 
> great! Now that cpu_clock() is in Linus' tree, could you put this patch 
> into your block.git tree and merge it (once you think it should go 
> upstream) together with other IO related fixes?

Sure, I'll pull it into for-linus for merge for 2.6.23.

-- 
Jens Axboe

