Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZDOGzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZDOGzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZDOGzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:55:23 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45309 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZDOGzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:55:22 -0400
Date: Wed, 15 Apr 2009 08:55:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, adilger@sun.com, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/7] Cleanup code that think bio_alloc with __GFP_WAIT
	can fail
Message-ID: <20090415065520.GR5178@kernel.dk>
References: <200904151034.52750.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904151034.52750.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15 2009, Nikanth Karthikesan wrote:
> bio_alloc will not fail when __GFP_WAIT is specified in the gfp_flags.
> See http://lkml.org/lkml/2009/4/14/198 for the discussion. But this
> not documented and there are places where there is unwanted code to
> handle bio_alloc failure even when __GFP_WAIT is specified. This patch
> set documents this and cleans up various callers who assume bio_alloc
> can fail even with __GFP_WAIT.

I added your patches 2-7, I substituted 1/7 with one I did myself that
uses proper kerneldoc annotation. Thanks!

-- 
Jens Axboe

