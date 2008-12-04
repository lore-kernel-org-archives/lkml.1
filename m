Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbYLDAww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbYLDAww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbYLDAwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:52:00 -0500
Received: from ns.suse.de ([195.135.220.2]:50557 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759514AbYLDAv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:51:59 -0500
Date: Wed, 3 Dec 2008 16:50:55 -0800
From: Greg KH <gregkh@suse.de>
To: edward_estabrook@agilent.com
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de,
       edward.estabrook@gmail.com, edward.estabrook.lkml@gmail.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Message-ID: <20081204005055.GE6981@suse.de>
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 02:39:44PM -0700, edward_estabrook@agilent.com wrote:
> @@ -82,6 +94,16 @@ static inline int __must_check  extern void uio_unregister_device(struct uio_info *info);  extern void uio_event_notify(struct uio_info *info);
>  
> +/* uio_dev_get_name - return the name associated with this uio device 
> +*/ extern char *uio_dev_get_name(struct uio_device *idev);
> +
> +/* Starting index assigned to dynamically allocated regions. */ #define 
> +UIO_DMA_MEM_BASE_INDEX 1000
> +
> +/* mmap dynamically allocates a DMA memory block if
> + * its offset parameter matches this value. */ #define 
> +UIO_DMA_MEM_ALLOCATE_VM_PGOFF_MAGIC 0xFFFFFUL

Something looks wrong with this patch, is it line wrapped somehow?

odd.

thanks,

greg k-h
