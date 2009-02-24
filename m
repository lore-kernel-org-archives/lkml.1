Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZBXORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZBXORR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZBXORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:17:00 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:30389 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbZBXOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:16:59 -0500
Message-ID: <49A40157.80806@turknet.net.tr>
Date: Tue, 24 Feb 2009 16:16:55 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: Miklos Szeredi <miklos@szeredi.hu>, tomas@slax.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl> <49A3FA10.4090801@turknet.net.tr> <12063.1235483860@jrobl>
In-Reply-To: <12063.1235483860@jrobl>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2009 14:16:56.0787 (UTC) FILETIME=[8CC0D230:01C9968A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote:
> Tarkan, thank you for your advise.
> Actually I broke functions and files into small pieces. Additionally I
> applied CONFIG_AUFS_* conditions in fs/aufs/Makefile. When you review
> aufs source files, I'd suggest you to read in this order.
>
> aufs-y := module.o sbinfo.o super.o branch.o xino.o sysaufs.o opts.o \
> 	wkq.o vfsub.o dcsub.o \
> 	cpup.o whout.o plink.o wbr_policy.o \
> 	dinfo.o dentry.o \
> 	finfo.o file.o f_op.o \
> 	dir.o vdir.o \
> 	iinfo.o inode.o i_op.o i_op_add.o i_op_del.o i_op_ren.o \
> 	ioctl.o
> aufs-$(CONFIG_SYSFS) += sysfs.o
> aufs-$(CONFIG_AUFS_BDEV_LOOP) += loop.o
> aufs-$(CONFIG_AUFS_HINOTIFY) += hinotify.o
> aufs-$(CONFIG_AUFS_DEBUG) += debug.o
> aufs-$(CONFIG_AUFS_MAGIC_SYSRQ) += sysrq.o
>
> If I am still misunderstanding, please let me know.
>   
Ok then. Good luck at your merging into mainline.
