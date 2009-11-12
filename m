Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZKLVAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZKLVAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZKLU74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:59:56 -0500
Received: from [95.166.99.235] ([95.166.99.235]:36366 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbZKLU74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:59:56 -0500
Date: Thu, 12 Nov 2009 22:00:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Subject: Re: Performance regression in IO scheduler still there
Message-ID: <20091112210000.GO8742@kernel.dk>
References: <20091026172012.GC7233@duck.suse.cz> <x49zl7020mr.fsf@segfault.boston.devel.redhat.com> <20091111141031.GA21511@duck.suse.cz> <x493a4lot31.fsf@segfault.boston.devel.redhat.com> <20091112172941.GK14528@duck.suse.cz> <x49pr7npj71.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49pr7npj71.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12 2009, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Wed 11-11-09 12:43:30, Jeff Moyer wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> >   Sadly, I don't see the improvement you can see :(. The numbers are the
> >> > same regardless low_latency set to 0:
> >> > 2.6.32-rc5 low_latency = 0:
> >> > 37.39 36.43 36.51 -> 36.776667 0.434920
> >> >   But my testing environment is a plain SATA drive so that probably
> >> > explains the difference...
> >> 
> >> I just retested (10 runs for each kernel) on a SATA disk with no NCQ
> >> support and I could not see a difference.  I'll try to dig up a disk
> >> that support NCQ.  Is that what you're using for testing?
> >   I don't think I am. How do I find out?
> 
> Good question.  ;-)  I grep for NCQ in dmesg output and make sure it's
> greater than 0/32.  There may be a better way, though.

cat /sys/block/<dev>/device/queue_depth

:-)

-- 
Jens Axboe

