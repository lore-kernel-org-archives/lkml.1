Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYAYRfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYAYRfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYAYRf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:35:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37519 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbYAYRf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:35:27 -0500
Subject: Re: [patch 12/26] mount options: fix ext4
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>
In-Reply-To: <20080124193432.492168716@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
	 <20080124193432.492168716@szeredi.hu>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 25 Jan 2008 09:35:02 -0800
Message-Id: <1201282502.4068.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-24 at 20:33 +0100, Miklos Szeredi wrote:
> plain text document attachment (ext4_opts.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add stripe= option to /proc/mounts for ext4 filesystems.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/ext4/super.c
> ===================================================================
> --- linux.orig/fs/ext4/super.c	2008-01-23 12:57:07.000000000 +0100
> +++ linux/fs/ext4/super.c	2008-01-23 21:43:51.000000000 +0100
> @@ -742,7 +742,8 @@ static int ext4_show_options(struct seq_
>  		seq_puts(seq, ",nomballoc");
>  	if (!test_opt(sb, DELALLOC))
>  		seq_puts(seq, ",nodelalloc");
> -
> +	if (sbi->s_stripe)
> +		seq_printf(seq, ",stripe=%lu", sbi->s_stripe);
> 
>  	/*
>  	 * journal mode get enabled in different ways
> 

Added to ext4 patch queue. Thanks!
http://repo.or.cz/w/ext4-patch-queue.git

Mingming


