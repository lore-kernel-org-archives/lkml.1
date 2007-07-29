Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbXG2KyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbXG2KyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 06:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbXG2Kx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 06:53:58 -0400
Received: from brick.kernel.dk ([80.160.20.94]:16080 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760300AbXG2Kx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 06:53:57 -0400
Date: Sun, 29 Jul 2007 12:54:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bsg: Fix warning with CONFIG_BLK_DEV_BSG=n
Message-ID: <20070729105458.GH32258@kernel.dk>
References: <ada6443vphh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada6443vphh.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28 2007, Roland Dreier wrote:
> The current stub definitions of bsg_register_queue() and
> bsg_unregister_queue() as macros leads to
> 
>     drivers/scsi/scsi_sysfs.c: In function 'scsi_sysfs_add_sdev':
>     drivers/scsi/scsi_sysfs.c:718: warning: unused variable 'rq'
> 
> because the first parameter of bsg_register_queue() is completely
> discarded.  As akpm says, "program in C, not in cpp."  We might as
> well get a little bit better type-checking when we fix this by
> converting the stubs to empty inline functions.

James should already have that patch queued for inclusion since last
week.

-- 
Jens Axboe

