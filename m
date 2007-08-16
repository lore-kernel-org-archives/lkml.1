Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbXHPGhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbXHPGhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXHPGha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:37:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3094 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbXHPGh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:37:29 -0400
Date: Thu, 16 Aug 2007 08:37:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 000 of 5] Introductory patches for bio refactor.
Message-ID: <20070816063725.GD23758@kernel.dk>
References: <20070816150445.30843.patches@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816150445.30843.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16 2007, NeilBrown wrote:
> 
> Hi Jens,
>  I wonder if you would accept these patches the block layer.
>  They are, as far as I can tell, quite uncontroversial and provide
>  good cleanups.
> 
>  The first is a minor bug-fix.
>  The next to replace helper function that take a bio (always the first
>  bio of a request), to instead take a request.
> 
>  The last two combine to replace rq_for_each_bio with
>  rq_for_each_segment which makes blk_recalc_rq_segments a lot
>  cleaner, and improves (to a lesser degree) every other place that
>  used rq_for_each_bio.
> 
>  The net result is a decrease in object code size (for my x86-64 compile)
>  for block/built-in.o of 96 bytes, though there is some growth out in
>  drivers making and over-all decrease of only 48 bytes.

Thanks for seperating these out Neil, will go over them this morning!

-- 
Jens Axboe

