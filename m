Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZKLVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZKLVGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZKLVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:06:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbZKLVGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:06:36 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Subject: Re: Performance regression in IO scheduler still there
References: <20091026172012.GC7233@duck.suse.cz>
	<x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
	<20091111141031.GA21511@duck.suse.cz>
	<x493a4lot31.fsf@segfault.boston.devel.redhat.com>
	<20091112172941.GK14528@duck.suse.cz>
	<x49pr7npj71.fsf@segfault.boston.devel.redhat.com>
	<20091112210000.GO8742@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Nov 2009 16:05:17 -0500
In-Reply-To: <20091112210000.GO8742@kernel.dk> (Jens Axboe's message of "Thu,
	12 Nov 2009 22:00:01 +0100")
Message-ID: <x49hbszpi7m.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Thu, Nov 12 2009, Jeff Moyer wrote:
>> Good question.  ;-)  I grep for NCQ in dmesg output and make sure it's
>> greater than 0/32.  There may be a better way, though.
>
> cat /sys/block/<dev>/device/queue_depth
>
> :-)

OK, your comment about only working for SCSI disks threw me off.
Perhaps you meant only works for devices that use the sd driver?

Cheers,
Jeff
