Return-Path: <linux-kernel-owner+w=401wt.eu-S1762580AbXJEMki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580AbXJEMki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXJEMkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:40:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28364 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXJEMka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:40:30 -0400
Date: Fri, 5 Oct 2007 14:41:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] block: move ioctl conversion to compat_blkdev_ioctl
Message-ID: <20071005124153.GT5711@kernel.dk>
References: <20071002073943.GC5236@kernel.dk> <200710042044.14698.arnd@arndb.de> <20071005104142.GO5711@kernel.dk> <200710051430.39792.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710051430.39792.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05 2007, Arnd Bergmann wrote:
> fs/compat_ioctl.c is still a mess and I'd prefer to get rid of it
> over time, by moving everything to the respective drivers.
> 
> A significant portion of our ioctl numbers are common to a number
> of block drivers, so should not handle them in each driver separately,
> but rather in the block layer.
> 
> In the process, we remove a few indirections from the call graph
> for compat block ioctls. This patch is still an entirely untested
> preview and should be split into smaller chunks.

As before, this looks pretty good. I'll toss it in the tester and see if
things still work.

-- 
Jens Axboe

