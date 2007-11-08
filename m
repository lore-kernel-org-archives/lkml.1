Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbXKHFXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbXKHFXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 00:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXKHFXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 00:23:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:54223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbXKHFXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 00:23:12 -0500
Date: Wed, 7 Nov 2007 21:24:18 -0800
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Peter Osterlund <petero2@telia.com>, Thomas Maier <balagi@justmail.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pktcdvd: fix BUG caused by sysfs module reference
	semantics change
Message-ID: <20071108052418.GA5670@suse.de>
References: <20071105092018.GD5359@kernel.dk> <Pine.LNX.4.64.0711052312410.5445@quad.localdomain> <47302E9F.6020708@gmail.com> <op.t1d2aurziudtyh@master> <Pine.LNX.4.64.0711062229490.5800@quad.localdomain> <4731269B.6010509@gmail.com> <Pine.LNX.4.64.0711072303080.6991@quad.localdomain> <47327404.9010008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47327404.9010008@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 11:27:16AM +0900, Tejun Heo wrote:
> pkt_setup_dev() expects module reference to be held on invocation.
> This used to be true for sysfs callbacks but not anymore.  Test and
> grab module reference around pkt_setup_dev() in
> class_pktcdvd_store_add().
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Acked-by: Peter Osterlund <petero2@telia.com>
> ---
> Greg, can you please push this patch through your tree? 
> Thanks a lot.
> 
>  drivers/block/pktcdvd.c |    9 +++++++++
>  1 file changed, 9 insertions(+)

Why through my tree?  I don't do block devices :)

Shouldn't Jens or at least Andrew take it?

thanks,

greg k-h
