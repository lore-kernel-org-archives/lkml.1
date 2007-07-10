Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbXGJXc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbXGJXc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762622AbXGJXa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:30:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762311AbXGJXav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:30:51 -0400
Date: Tue, 10 Jul 2007 16:30:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-Id: <20070710163038.ceb2ae94.akpm@linux-foundation.org>
In-Reply-To: <1183275424.4010.126.camel@localhost.localdomain>
References: <1183275424.4010.126.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:37:04 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch converts the 32-bit i_version in the generic inode to a 64-bit
> i_version field.
> 

That's obvious from the patch.  But what was the reason for making this
(unrelated to ext4) change?

Please update the changelog for this.

> Index: linux-2.6.21/include/linux/fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/fs.h
> +++ linux-2.6.21/include/linux/fs.h
> @@ -549,7 +549,7 @@ struct inode {
>  	uid_t			i_uid;
>  	gid_t			i_gid;
>  	dev_t			i_rdev;
> -	unsigned long		i_version;
> +	u64			i_version;
>  	loff_t			i_size;
>  #ifdef __NEED_I_SIZE_ORDERED
>  	seqcount_t		i_size_seqcount;

