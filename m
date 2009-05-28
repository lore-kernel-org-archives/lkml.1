Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZE1KUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZE1KUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZE1KUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:20:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45595 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZE1KUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:20:33 -0400
Date: Thu, 28 May 2009 12:20:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: damien.wyart@free.fr, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090528102034.GY11363@kernel.dk>
References: <20090526164117.GJ11363@kernel.dk> <20090526170845.GA3226@localhost.localdomain> <20090526204703.GM11363@kernel.dk> <20090526211119.GO11363@kernel.dk> <20090527052101.GA28517@localhost.localdomain> <20090527054921.GA4127@localhost.localdomain> <20090527092052.GV11363@kernel.dk> <20090527131555.GA3277@localhost.localdomain> <20090527150546.GM11363@kernel.dk> <20090527140641.71ecaf8c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527140641.71ecaf8c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Andrew Morton wrote:
> On Wed, 27 May 2009 17:05:47 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > I ran testing with artificial
> > bdi_work allocation failures to verify the oom path
> 
> I bet you didn't use lib/fault-inject.c :(

I didn't, it was a 2-second hack to add a

        static int i;

        if (!(i++ % 4))
                return NULL;

so I didn't look further...

> For tricky pieces of core kernel like this, there's a good case for
> including and permanently maintaining fault injection testing
> capabilities.

I agree.

-- 
Jens Axboe

