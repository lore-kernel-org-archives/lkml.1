Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXIUShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXIUShq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXIUShb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:37:31 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:51613 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbXIUSh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:37:29 -0400
Date: Fri, 21 Sep 2007 12:37:54 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 2/5] VFS: pass open file to ->getattr()
Message-ID: <20070921183754.GO32520@schatzie.adilger.int>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	akpm@linux-foundation.org, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123331.655294226@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921123331.655294226@szeredi.hu>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2007  14:23 +0200, Miklos Szeredi wrote:
> @@ -1212,7 +1212,8 @@ struct inode_operations {
> -	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
> +	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *,
> +			struct file *file);

It's not much of an inode operation anymore if you need to pass a file
to it...  Since the attributes are really part of the inode and not
the file, this seems like a bit of a hack.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

