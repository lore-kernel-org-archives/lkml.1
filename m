Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZKLR3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZKLR3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZKLR3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:29:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZKLR3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:29:37 -0500
Date: Thu, 12 Nov 2009 18:29:41 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Subject: Re: Performance regression in IO scheduler still there
Message-ID: <20091112172941.GK14528@duck.suse.cz>
References: <20091026172012.GC7233@duck.suse.cz> <x49zl7020mr.fsf@segfault.boston.devel.redhat.com> <20091111141031.GA21511@duck.suse.cz> <x493a4lot31.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x493a4lot31.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-11-09 12:43:30, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >   Sadly, I don't see the improvement you can see :(. The numbers are the
> > same regardless low_latency set to 0:
> > 2.6.32-rc5 low_latency = 0:
> > 37.39 36.43 36.51 -> 36.776667 0.434920
> >   But my testing environment is a plain SATA drive so that probably
> > explains the difference...
> 
> I just retested (10 runs for each kernel) on a SATA disk with no NCQ
> support and I could not see a difference.  I'll try to dig up a disk
> that support NCQ.  Is that what you're using for testing?
  I don't think I am. How do I find out?

>               2.6.29    2.6.32-rc6,low_latency=0
> ----------------------------------
> Average:      34.6648   34.4475
> Pop.Std.Dev.: 0.55523   0.21981
  Hmm, strange. Miklos Szeredi tried tiobench on his machine and he also
saw the regression. I'll try to think what could make the difference.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
