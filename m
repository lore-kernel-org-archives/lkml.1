Return-Path: <linux-kernel-owner+w=401wt.eu-S1030565AbXDMVeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565AbXDMVeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030587AbXDMVeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:34:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030505AbXDMVeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:34:22 -0400
Date: Fri, 13 Apr 2007 14:34:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: steve.cameron@hp.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       jens.axboe@oracle.com, mike.miller@hp.com, james.bottomley@steeleye.com
Subject: Re: [PATCH 1/1] cciss: include scsi/scsi.h unconditionally
Message-Id: <20070413143413.6b9ac0e7.akpm@linux-foundation.org>
In-Reply-To: <20070413142312.GA24021@quandary.cca.cpqcorp.net>
References: <20070413142312.GA24021@quandary.cca.cpqcorp.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 09:23:12 -0500
Stephen Cameron <steve.cameron@hp.com> wrote:

> Make cciss unconditionally include scsi/scsi.h

For what reason?

> 
> From: Stephen M. Cameron <steve.cameron@hp.com>
> Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
> 
> ---
> 
>  drivers/block/cciss.c      |    1 +
>  drivers/block/cciss_scsi.c |    1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/block/cciss.c~include_scsi_h_unconditionally drivers/block/cciss.c
> --- linux-2.6.21-rc6/drivers/block/cciss.c~include_scsi_h_unconditionally	2007-04-13 08:23:07.000000000 -0500
> +++ linux-2.6.21-rc6-scameron/drivers/block/cciss.c	2007-04-13 08:25:05.000000000 -0500
> @@ -45,6 +45,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/genhd.h>
>  #include <linux/completion.h>
> +#include <scsi/scsi.h>
>  #include <scsi/sg.h>
>  #include <scsi/scsi_ioctl.h>
>  #include <linux/cdrom.h>
> diff -puN drivers/block/cciss_scsi.c~include_scsi_h_unconditionally drivers/block/cciss_scsi.c
> --- linux-2.6.21-rc6/drivers/block/cciss_scsi.c~include_scsi_h_unconditionally	2007-04-13 08:23:53.000000000 -0500
> +++ linux-2.6.21-rc6-scameron/drivers/block/cciss_scsi.c	2007-04-13 08:24:34.000000000 -0500
> @@ -35,7 +35,6 @@
>  
>  #include <asm/atomic.h>
>  
> -#include <scsi/scsi.h> 
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h> 
