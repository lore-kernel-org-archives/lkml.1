Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZBTHOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZBTHOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZBTHOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:14:47 -0500
Received: from brick.kernel.dk ([93.163.65.50]:10560 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZBTHOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:14:46 -0500
Date: Fri, 20 Feb 2009 08:12:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>, ltp-list@lists.sourceforge.net
Subject: Re: [PATCH] block: add documentation for register_blkdev()
Message-ID: <20090220071217.GP29783@kernel.dk>
References: <499E4804.3030703@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <499E4804.3030703@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20 2009, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Add documentation for register_blkdev() function and for the parameters.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Thanks Márton, applied.

> 
> ---
> --- linux-2.6.29-rc5/block/genhd.c.orig	2009-02-14 18:36:39.000000000 +0100
> +++ linux-2.6.29-rc5/block/genhd.c	2009-02-20 06:53:56.000000000 +0100
> @@ -256,6 +256,22 @@ void blkdev_show(struct seq_file *seqf,
>  }
>  #endif /* CONFIG_PROC_FS */
> 
> +/**
> + * register_blkdev - register a new block device
> + *
> + * @major: the requested major device number [1..255]. If @major=0, try to
> + *         allocate any unused major number.
> + * @name: the name of the new block device as a zero terminated string
> + *
> + * The @name must be unique within the system.
> + *
> + * The return value depends on the @major input parameter.
> + *  - if a major device number was requested in range [1..255] then the
> + *    function returns zero on success, or a negative error code
> + *  - if any unused major number was requested with @major=0 parameter
> + *    then the return value is the allocated major number in range
> + *    [1..255] or a negative error code otherwise
> + */
>  int register_blkdev(unsigned int major, const char *name)
>  {
>  	struct blk_major_name **n, *p;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jens Axboe

