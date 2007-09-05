Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbXIENzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbXIENzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbXIENz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:55:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbXIENzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:55:25 -0400
Date: Wed, 05 Sep 2007 09:54:15 -0400 (EDT)
Message-Id: <20070905.095415.74754238.k-ueda@ct.jp.nec.com>
To: bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com,
       grant.likely@secretlab.ca, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 3/7] blk_end_request: changing "normal" drivers
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <46DE5EB2.4050505@panasas.com>
References: <20070831.184219.95065632.k-ueda@ct.jp.nec.com>
	<46DE5EB2.4050505@panasas.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benny,

Thank you for the comments.

On Wed, 05 Sep 2007 10:45:54 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Sat, Sep 01 2007 at 1:42 +0300, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> >  arch/arm/plat-omap/mailbox.c    |    9 ++++++---
> >  arch/um/drivers/ubd_kern.c      |   10 +---------
> >  block/elevator.c                |    4 ++--
> >  block/ll_rw_blk.c               |   15 +++++----------
> >  drivers/block/DAC960.c          |    6 ++----
> >  drivers/block/floppy.c          |    8 +++-----
> >  drivers/block/lguest_blk.c      |    5 +----
> >  drivers/block/nbd.c             |    4 +---
> >  drivers/block/ps3disk.c         |    6 +-----
> >  drivers/block/sunvdc.c          |    5 +----
> >  drivers/block/sx8.c             |    4 +---
> >  drivers/block/ub.c              |    4 ++--
> >  drivers/block/viodasd.c         |    5 +----
> >  drivers/block/xen-blkfront.c    |    5 ++---
> >  drivers/cdrom/viocd.c           |    5 +----
> >  drivers/ide/ide-cd.c            |    6 +++---
> >  drivers/ide/ide-io.c            |   22 +++++++---------------
> >  drivers/message/i2o/i2o_block.c |    8 ++------
> >  drivers/mmc/card/block.c        |   24 +++++-------------------
> >  drivers/mmc/card/queue.c        |    4 ++--
> >  drivers/s390/block/dasd.c       |    4 +---
> >  drivers/s390/char/tape_block.c  |    3 +--
> >  drivers/scsi/ide-scsi.c         |    8 ++++----
> >  drivers/scsi/scsi_lib.c         |   13 ++-----------
> >  24 files changed, 57 insertions(+), 130 deletions(-)
> 
> Please Separate this patch to at least three patches.
> 1. Block layer - block/elevator.c block/ll_rw_blk.c
> 2. SCSI-ML - drivers/scsi/scsi_lib.c
> 3. Normal drivers, can also be separated into logical
>    groups like scsi/block etc..
> 
> This is because these patches introduce conflicts
> to lots of queued work I have, and if you separate
> them it will help me with my giting. Also I think
> that this is logical. Block-layer and scsi_lib are
> not drivers, the Subject of the patch does not match.

I see.
OK, I will separate this patch for each driver so that
driver maintainers and developers can apply them easily.

Thanks,
Kiyoshi Ueda
