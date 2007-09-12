Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbXILFqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbXILFqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXILFqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:46:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16087 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXILFqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:46:07 -0400
Date: Wed, 12 Sep 2007 07:54:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [-mm patch] remove ide_get_error_location()
Message-ID: <20070912055445.GF25592@kernel.dk>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202455.GM3563@stusta.de> <200709112327.20764.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709112327.20764.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11 2007, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 09 September 2007, Adrian Bunk wrote:
> > On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> > >...
> > > Changes since 2.6.23-rc3-mm1:
> > >...
> > >  git-block.patch
> > >...
> > >  git trees
> > >...
> > 
> > ide_get_error_location() is no longer used.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Since git-block contains the patch which removes the only user of
> ide_get_error_location() I think that this patch should be also merged
> through block tree.  Jens?

Yeah, I'll add it there.

> PS none of the blkdev_issue_flush() users uses *error_sector argument
> so it can be probably removed as well

I had hoped that the existance was enough incentive, but it didn't
happen. I'll make a note to kill that again.

-- 
Jens Axboe

