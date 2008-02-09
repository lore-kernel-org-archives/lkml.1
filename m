Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYBIHXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYBIHXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYBIHXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:23:30 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44569 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYBIHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:23:29 -0500
Date: Sat, 9 Feb 2008 02:19:27 -0500
Message-Id: <200802090719.m197JRan023715@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, ezk@cs.sunysb.edu, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up kerneldoc in fs/ioctl.c a little bit 
In-reply-to: Your message of "Sat, 09 Feb 2008 08:15:59 +0100."
             <20080209071559.GA30903@lst.de> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080209071559.GA30903@lst.de>, Christoph Hellwig writes:
>  - remove non-standard in/out markers
>  - use tabs for formatting
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/ioctl.c
> ===================================================================
> --- linux-2.6.orig/fs/ioctl.c	2008-02-09 07:49:02.000000000 +0100
> +++ linux-2.6/fs/ioctl.c	2008-02-09 07:49:20.000000000 +0100
> @@ -18,9 +18,9 @@
>  
>  /**
>   * vfs_ioctl - call filesystem specific ioctl methods
> - * @filp: [in]     open file to invoke ioctl method on
> - * @cmd:  [in]     ioctl command to execute
> - * @arg:  [in/out] command-specific argument for ioctl
> + * @filp:	open file to invoke ioctl method on
> + * @cmd:	ioctl command to execute
> + * @arg:	command-specific argument for ioctl
>   *
>   * Invokes filesystem specific ->unlocked_ioctl, if one exists; otherwise
>   * invokes * filesystem specific ->ioctl method.  If neither method exists,
              ^

I also think this extra '*' in the last comment line above is spurious,
perhaps the result of a paragraph reformatting command that mixed comment
*'s with text.

Erez.
