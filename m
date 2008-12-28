Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYL1SZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYL1SZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 13:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYL1SZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 13:25:50 -0500
Received: from brick.kernel.dk ([93.163.65.50]:15444 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbYL1SZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 13:25:50 -0500
Date: Sun, 28 Dec 2008 19:25:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: oops in __bounce_end_io_read under kvm
Message-ID: <20081228182459.GX32491@kernel.dk>
References: <20081226173606.GA14933@lst.de> <20081228181057.GV32491@kernel.dk> <20081228181948.GA23568@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228181948.GA23568@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28 2008, Christoph Hellwig wrote:
> On Sun, Dec 28, 2008 at 07:10:59PM +0100, Jens Axboe wrote:
> > Is this -rc9 stock + xfs patches, or does it include -mm or -next
> > patches (or the block patches)?
> 
> Just -rc9 and xfs updates.  The only change outside of fs/xfs/ is a new
> define in fs.h and a couple new helpers in inode.c

OK, then it's surely a new bug. Could you do a gdb l *0xbla on that
address to check where it's faulting?

-- 
Jens Axboe

