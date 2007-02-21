Return-Path: <linux-kernel-owner+w=401wt.eu-S1423187AbXBUWQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423187AbXBUWQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423188AbXBUWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:16:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423187AbXBUWQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:16:19 -0500
Subject: Re: [PATCH 2.6.20] gfs2: add newline to printk message
From: Steven Whitehouse <swhiteho@redhat.com>
To: Richard Fearn <richardfearn@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <45D73B6B.1030406@gmail.com>
References: <45D73B6B.1030406@gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 21 Feb 2007 22:45:47 +0000
Message-Id: <1172097947.3203.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay, patch now added to the gfs2 git tree. Thanks,

Steve.

On Sat, 2007-02-17 at 17:29 +0000, Richard Fearn wrote:
> Patch for the 2.6.20 stable tree that adds a missing newline to one of
> the printk messages in fs/gfs2/ops_fstype.c.
> 
> Signed-off-by: Richard Fearn <richardfearn@gmail.com>
> 
> diff -uprN 2.6.20/fs/gfs2/ops_fstype.c new/fs/gfs2/ops_fstype.c
> --- 2.6.20/fs/gfs2/ops_fstype.c	2007-02-04 18:44:54.000000000 +0000
> +++ new/fs/gfs2/ops_fstype.c	2007-02-17 15:36:45.000000000 +0000
> @@ -840,7 +840,7 @@ static struct super_block* get_gfs2_sb(c
>  	}
> 
>  	printk(KERN_WARNING "GFS2: Unrecognized block device or "
> -	       "mount point %s", dev_name);
> +	       "mount point %s\n", dev_name);
> 
>  free_nd:
>  	path_release(&nd);
> 
> 

