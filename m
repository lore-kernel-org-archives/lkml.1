Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXEPL1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXEPL1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXEPL13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:27:29 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13862 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbXEPL12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:27:28 -0400
Date: Wed, 16 May 2007 13:25:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/19] scsi: convert to using sg helpers
Message-ID: <20070516112558.GQ23798@kernel.dk>
References: <11793043533744-git-send-email-jens.axboe@oracle.com> <11793043541476-git-send-email-jens.axboe@oracle.com> <20070516131720.4f9ed32a@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516131720.4f9ed32a@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16 2007, Cornelia Huck wrote:
> On Wed, 16 May 2007 10:32:19 +0200,
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > This converts the SCSI mid layer to using the sg helpers for looking up
> > sg elements, instead of doing it manually.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  drivers/scsi/scsi_lib.c |   20 +++++++++++---------
> >  1 files changed, 11 insertions(+), 9 deletions(-)
> 
> This needs to include linux/scatterlist.h (other architectures seem to
> pull this header in via other routes, but e.g. s390 doesn't).
> 
> ---
>  drivers/scsi/scsi_lib.c |    1 +
>  1 files changed, 1 insertion(+)
> 
> --- linux.orig/drivers/scsi/scsi_lib.c
> +++ linux/drivers/scsi/scsi_lib.c
> @@ -17,6 +17,7 @@
>  #include <linux/pci.h>
>  #include <linux/delay.h>
>  #include <linux/hardirq.h>
> +#include <linux/scatterlist.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>

Patch 17 does that, so the end result should work. But I'll move it to
patch 5, that is the correct spot to do it. Thanks!

-- 
Jens Axboe

