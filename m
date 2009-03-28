Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZC1VEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZC1VEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZC1VD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:03:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58761 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbZC1VD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:03:59 -0400
Date: Sat, 28 Mar 2009 22:05:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Cc: git-commits-head@vger.kernel.org
Subject: Re: [SCSI] libosd: OSDv1 preliminary implementation
Message-ID: <20090328210559.GA30903@uranus.ravnborg.org>
References: <200903282059.n2SKxp6U030392@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903282059.n2SKxp6U030392@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 08:59:51PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/02941a530ef736210b4cf8b24dd34c238d5d5a40
> Commit:     02941a530ef736210b4cf8b24dd34c238d5d5a40
> Parent:     de258bf5e63863f42e0f9a7c5ffd29916a41e399
> Author:     Boaz Harrosh <bharrosh@panasas.com>
> AuthorDate: Sun Jan 25 16:55:30 2009 +0200
> Committer:  James Bottomley <James.Bottomley@HansenPartnership.com>
> CommitDate: Thu Mar 12 12:58:06 2009 -0500
> 
>     [SCSI] libosd: OSDv1 preliminary implementation
>     
>     Implementation of the most basic OSD functionality and
>     infrastructure. Mainly Format, Create/Remove Partition,
>     Create/Remove Object, and read/write.
>     
>     - Add Makefile and Kbuild to compile libosd.ko
>     - osd_initiator.c Implementation file for osd_initiator.h
>       and osd_sec.h APIs
>     - osd_debug.h - Some kprintf macro definitions
>     
>     Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>     Reviewed-by: Benny Halevy <bhalevy@panasas.com>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/osd/Kbuild          |   32 +++
>  drivers/scsi/osd/Makefile        |   37 +++
>  drivers/scsi/osd/osd_debug.h     |   30 +++
>  drivers/scsi/osd/osd_initiator.c |  448 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 547 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
> new file mode 100644
> index 0000000..a95e025
> --- /dev/null
> +++ b/drivers/scsi/osd/Kbuild
> @@ -0,0 +1,32 @@
> +#
> +# Kbuild for the OSD modules
> +#
> +# Copyright (C) 2008 Panasas Inc.  All rights reserved.
> +#
> +# Authors:
> +#   Boaz Harrosh <bharrosh@panasas.com>
> +#   Benny Halevy <bhalevy@panasas.com>
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License version 2
> +#
> +
> +ifneq ($(OSD_INC),)
> +# we are built out-of-tree Kconfigure everything as on

It is now included in mainline.
So can we please get rid of this crap?

	Sam
