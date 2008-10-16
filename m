Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbYJPNLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbYJPNLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYJPNKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:10:52 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:45581 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYJPNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:10:51 -0400
Date: Thu, 16 Oct 2008 15:10:49 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bodo Eggert <7eggert@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use tmpfs for rootfs
In-Reply-To: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
Message-ID: <Pine.LNX.4.64.0810161507130.25933@anakin>
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Bodo Eggert wrote:
> +config TMPFS_ROOT
> +	bool "Use tmpfs instrad of ramfs for initramfs"
> +	depends on TMPFS && SHMEM
> +	default n
> +	help
> +	  This replaces the ramfs used for unpacking the cpio images
> +	  with tmpfs.
> +	  
> +	  If unsure, say N
> +
> +config RAMFS
> + 	bool "Ramfs file system support" if TMPFS_ROOT
> +  	default y
> +  	---help---
> +  	  Ramfs is a file system which keeps all files in RAM. Unlike tmpfs,
> +  	  it cannot be swapped to disk, and it has the risk of deadlocking
> +  	  the system by using all memory.
> +
> +  	  Ramfs is used for booting the system and unpacking the cpio if
> +  	  TMPFS_ROOT is not set.

Something seems to be missing, as you add CONFIG_RAMFS, but it's nowhere used?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
