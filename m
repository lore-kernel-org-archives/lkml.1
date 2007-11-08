Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbXKHG7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbXKHG7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXKHG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:59:31 -0500
Received: from brick.kernel.dk ([87.55.233.238]:12832 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbXKHG7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:59:31 -0500
Date: Thu, 8 Nov 2007 07:59:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Peter Osterlund <petero2@telia.com>,
       Thomas Maier <balagi@justmail.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pktcdvd: fix BUG caused by sysfs module reference
	semantics  change
Message-ID: <20071108065926.GB5011@kernel.dk>
References: <20071105092018.GD5359@kernel.dk> <Pine.LNX.4.64.0711052312410.5445@quad.localdomain> <47302E9F.6020708@gmail.com> <op.t1d2aurziudtyh@master> <Pine.LNX.4.64.0711062229490.5800@quad.localdomain> <4731269B.6010509@gmail.com> <Pine.LNX.4.64.0711072303080.6991@quad.localdomain> <47327404.9010008@gmail.com> <20071108052418.GA5670@suse.de> <4732B2FB.6000007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4732B2FB.6000007@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08 2007, Tejun Heo wrote:
> Greg KH wrote:
> > On Thu, Nov 08, 2007 at 11:27:16AM +0900, Tejun Heo wrote:
> >> pkt_setup_dev() expects module reference to be held on invocation.
> >> This used to be true for sysfs callbacks but not anymore.  Test and
> >> grab module reference around pkt_setup_dev() in
> >> class_pktcdvd_store_add().
> >>
> >> Signed-off-by: Tejun Heo <htejun@gmail.com>
> >> Acked-by: Peter Osterlund <petero2@telia.com>
> >> ---
> >> Greg, can you please push this patch through your tree? 
> >> Thanks a lot.
> >>
> >>  drivers/block/pktcdvd.c |    9 +++++++++
> >>  1 file changed, 9 insertions(+)
> > 
> > Why through my tree?  I don't do block devices :)
> 
> Because it's a regression introduced by changes in sysfs?
> 
> > Shouldn't Jens or at least Andrew take it?
> 
> That's fine too.  Jens?

Sure, I'm pushing some stuff off today anyway.

-- 
Jens Axboe

