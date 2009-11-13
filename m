Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZKMHpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZKMHpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZKMHpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:45:13 -0500
Received: from [95.166.99.235] ([95.166.99.235]:52306 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZKMHpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:45:12 -0500
Date: Fri, 13 Nov 2009 08:45:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Subject: Re: Performance regression in IO scheduler still there
Message-ID: <20091113074516.GR8742@kernel.dk>
References: <20091026172012.GC7233@duck.suse.cz> <x49zl7020mr.fsf@segfault.boston.devel.redhat.com> <20091111141031.GA21511@duck.suse.cz> <x493a4lot31.fsf@segfault.boston.devel.redhat.com> <20091112172941.GK14528@duck.suse.cz> <x49pr7npj71.fsf@segfault.boston.devel.redhat.com> <20091112210000.GO8742@kernel.dk> <x49hbszpi7m.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49hbszpi7m.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Thu, Nov 12 2009, Jeff Moyer wrote:
> >> Good question.  ;-)  I grep for NCQ in dmesg output and make sure it's
> >> greater than 0/32.  There may be a better way, though.
> >
> > cat /sys/block/<dev>/device/queue_depth
> >
> > :-)
> 
> OK, your comment about only working for SCSI disks threw me off.
> Perhaps you meant only works for devices that use the sd driver?

Yeah, only works for storage that plugs into the SCSI stack.

-- 
Jens Axboe

