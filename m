Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbXJEKk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbXJEKk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXJEKkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:40:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15923 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXJEKkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:40:18 -0400
Date: Fri, 5 Oct 2007 12:41:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Message-ID: <20071005104142.GO5711@kernel.dk>
References: <20071002073943.GC5236@kernel.dk> <200710040048.20676.arnd@arndb.de> <20071004181606.GH5711@kernel.dk> <200710042044.14698.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710042044.14698.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04 2007, Arnd Bergmann wrote:
> On Thursday 04 October 2007, you wrote:
> > This looks a lot better! I don't mind seperating the block bits, when we
> > get the whole bunch in there. Just seemed overly silly and complicated
> > to do it for just one ioctl command. When you are happy with this patch,
> > I'll add it to the pending block stuff for 2.6.24. The blktrace fix
> > isn't a regression so need not go into 2.6.23.
> 
> ok.
> 
> > It seems some bits are missing though (like BLKTRACESETUP32), did you
> > send the whole thing?
> 
> I did the large patch on top of the blktrace patch I sent earlier,
> so it doesn't apply cleanly. When doing the final version, I'll use
> a more sensible patch order.

Ah I see, can you generate one against current git?

-- 
Jens Axboe

