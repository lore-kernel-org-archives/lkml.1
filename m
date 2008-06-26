Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbYFZR7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbYFZR7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYFZR7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:59:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26886 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYFZR7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:59:24 -0400
Date: Thu, 26 Jun 2008 19:37:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What's in linux-2.6-block.git for 2.6.27
Message-ID: <20080626173754.GC20851@kernel.dk>
References: <20080626115404.GS20851@kernel.dk> <20080626233440K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626233440K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26 2008, FUJITA Tomonori wrote:
> On Thu, 26 Jun 2008 13:54:04 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Hi,
> > 
> > So this time it's a little beyond just block stuff, since the
> > generic-ipi branch is included (in preparation for block parts actually
> > using that code).
> > 
> > - xen block bits
> > 
> > - Write starvation fix for 'AS', a very long standing bug
> > 
> > - CFQ using the message trace for debugging.
> > 
> > - Ability to inject messages into the blktrace stream from user space,
> >   which helps annotate a longer running trace where you make changes
> >   meanwhile.
> > 
> > - Finally kill off request_queue_t typedef.
> > 
> > - The data integrity block parts.
> > 
> > - Export of the disk read-only attribute in sysfs
> > 
> > - The generic-ipi smp helpers and a slew of arch conversions.
> > 
> > All of the above can be viewed/tested in the for-next branch, which is
> > what Stephen is pulling as well. For manual code browsing, go to gitweb
> > here:
> 
> Can you add a patch to add bounce support to blk_rq_map_user_iov?
> 
> http://marc.info/?l=linux-scsi&m=121299573730764&w=2

Yep, done.

-- 
Jens Axboe

