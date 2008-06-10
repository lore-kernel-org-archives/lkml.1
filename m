Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYFJUwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYFJUwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbYFJUuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:50:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757474AbYFJUuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:50:44 -0400
Date: Tue, 10 Jun 2008 13:50:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, andrew.patterson@hp.com, justin.chen@hp.com
Subject: Re: [PATCH 2/2] cciss: bump version to .20 to reflect new HW
 support
Message-Id: <20080610135026.f17a2d3a.akpm@linux-foundation.org>
In-Reply-To: <20080610161404.GB6808@roadking.ldev.net>
References: <20080610161404.GB6808@roadking.ldev.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 11:14:04 -0500
Mike Miller <mike.miller@hp.com> wrote:

> PATCH 2/2
> This patch bumps the driver version to 3.6.20 to reflect the new hardware
> support from patch 1 of this set. Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index ced904d..c21a5a9 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -53,16 +53,16 @@
>  #include <linux/scatterlist.h>
>  
>  #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
> -#define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
> -#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
> +#define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
> +#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
>  
>  /* Embedded module documentation macros - see modules.h */
>  MODULE_AUTHOR("Hewlett-Packard Company");
> -MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.14");
> +MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
>  MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
>  			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m"
>  			" Smart Array G2 Series SAS/SATA Controllers");
> -MODULE_VERSION("3.6.14");
> +MODULE_VERSION("3.6.20");
>  MODULE_LICENSE("GPL");
>  
>  #include "cciss_cmd.h"

I think it would be more logical to fold these two patches together.

I believe we should include this new device support in 2.6.25.x, yes?
