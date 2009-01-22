Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZAVSZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZAVSZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 13:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZAVSZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 13:25:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:35933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbZAVSZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:25:07 -0500
Date: Thu, 22 Jan 2009 10:23:01 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Rapoport <mike@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: fix Android binder compilation
Message-ID: <20090122182300.GB11328@suse.de>
References: <497817C1.2020200@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497817C1.2020200@compulab.co.il>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 08:52:49AM +0200, Mike Rapoport wrote:
> Building kernel with ARCH=arm and xm_x2xx_defconfig and Android binder driver
> enabled gives the following error:
> 
>   CC      drivers/staging/android/binder.o
> /mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c: In function
> 'binder_vma_open':
> /mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c:2652: error:
> request for member 'pgprot' in something not a structure or union
> /mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c: In function
> 'binder_vma_close':
> /mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c:2659: error:
> request for member 'pgprot' in something not a structure or union
> /mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c: In function
> 'binder_mmap':
> /mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c:2680: error:
> request for member 'pgprot' in something not a structure or union
> 
> Fix it.

Thanks, but this is already fixed in the -next tree and will be sent to
Linus when he returns from linux.conf.au next week or so.

greg k-h
