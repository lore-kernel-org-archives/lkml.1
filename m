Return-Path: <linux-kernel-owner+w=401wt.eu-S1763911AbZE0PGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763911AbZE0PGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763332AbZE0PFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:05:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47382 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763598AbZE0PFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:05:45 -0400
Date: Wed, 27 May 2009 17:05:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090527150546.GM11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com> <20090526152501.GA20968@localhost.localdomain> <20090526164117.GJ11363@kernel.dk> <20090526170845.GA3226@localhost.localdomain> <20090526204703.GM11363@kernel.dk> <20090526211119.GO11363@kernel.dk> <20090527052101.GA28517@localhost.localdomain> <20090527054921.GA4127@localhost.localdomain> <20090527092052.GV11363@kernel.dk> <20090527131555.GA3277@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527131555.GA3277@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Damien Wyart wrote:
> > Yeah, that patch was still buggy. I have it fixed now locally, I'll post
> > a v8 within the hour!
> 
> The two systems having problems with v7 now run v8 and everything seems
> smooth for now. Thanks for the bugfixes.

Good, so at least that one got fixed. I ran testing with artificial
bdi_work allocation failures to verify the oom path, so I pretty much
expected your case to be fixed now. But it's also nice to have
reassurance!

-- 
Jens Axboe

