Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZCIFxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZCIFxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 01:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZCIFuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 01:50:05 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36344 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZCIFuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 01:50:03 -0400
Date: Mon, 9 Mar 2009 06:51:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Aufs 03/25] aufs module global
Message-ID: <20090309055159.GC14122@uranus.ravnborg.org>
References: <1236569118-3750-1-git-send-email-hooanon05@yahoo.co.jp> <1236569118-3750-4-git-send-email-hooanon05@yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236569118-3750-4-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/aufs/Makefile b/fs/aufs/Makefile
> new file mode 100644
> index 0000000..9952a46
> --- /dev/null
> +++ b/fs/aufs/Makefile
> @@ -0,0 +1,20 @@
> +
> +include ${srctree}/${src}/magic.mk
> +-include ${srctree}/${src}/priv_def.mk

Some internal stuff that should have been deleted?

> +
> +obj-$(CONFIG_AUFS_FS) += aufs.o
> +aufs-y := module.o sbinfo.o super.o branch.o xino.o sysaufs.o opts.o \
> +	wkq.o vfsub.o dcsub.o \
> +	cpup.o whout.o plink.o wbr_policy.o \
> +	dinfo.o dentry.o \
> +	finfo.o file.o f_op.o \
> +	dir.o vdir.o \
> +	iinfo.o inode.o i_op.o i_op_add.o i_op_del.o i_op_ren.o \
> +	ioctl.o
> +
> +# all are boolean
> +aufs-$(CONFIG_SYSFS) += sysfs.o
> +aufs-$(CONFIG_AUFS_BDEV_LOOP) += loop.o
> +aufs-$(CONFIG_AUFS_HINOTIFY) += hinotify.o
> +aufs-$(CONFIG_AUFS_DEBUG) += debug.o
> +aufs-$(CONFIG_AUFS_MAGIC_SYSRQ) += sysrq.o

	Sam
