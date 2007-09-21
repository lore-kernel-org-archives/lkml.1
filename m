Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbXIUSi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbXIUSi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbXIUSit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:38:49 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:43007 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbXIUSis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:38:48 -0400
Date: Fri, 21 Sep 2007 12:39:15 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
Message-ID: <20070921183915.GP32520@schatzie.adilger.int>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	akpm@linux-foundation.org, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921123333.247493758@szeredi.hu>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2007  14:23 +0200, Miklos Szeredi wrote:
> @@ -1214,10 +1214,12 @@ struct inode_operations {
> +	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int,
> +			 struct file *);
> +	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t,
> +			     struct file *);
> +	ssize_t (*listxattr) (struct dentry *, char *, size_t, struct file *);
> +	int (*removexattr) (struct dentry *, const char *, struct file *);

Likewise - these are no longer inode operations if you need a file.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

