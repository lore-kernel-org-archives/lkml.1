Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678Ab0ALRo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0ALRo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637Ab0ALRoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:44:25 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39180 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0ALRoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:44:24 -0500
Date: Tue, 12 Jan 2010 11:43:58 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 7/7] sysfs: Kill unused sysfs_sb variable.
Message-ID: <20100112174358.GD13506@us.ibm.com>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
 <1263241315-19499-7-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263241315-19499-7-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that there are no more users we can remove
> the sysfs_sb variable.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/mount.c |    2 --
>  fs/sysfs/sysfs.h |    1 -
>  2 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 77bce54..50cf41c 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -23,7 +23,6 @@
> 
> 
>  static struct vfsmount *sysfs_mount;
> -struct super_block * sysfs_sb = NULL;
>  struct kmem_cache *sysfs_dir_cachep;
> 
>  static const struct super_operations sysfs_ops = {
> @@ -51,7 +50,6 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_magic = SYSFS_MAGIC;
>  	sb->s_op = &sysfs_ops;
>  	sb->s_time_gran = 1;
> -	sysfs_sb = sb;
> 
>  	/* get root inode, initialize and unlock it */
>  	mutex_lock(&sysfs_mutex);
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 1ae6009..0ea96af 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -112,7 +112,6 @@ struct sysfs_addrm_cxt {
>   * mount.c
>   */
>  extern struct sysfs_dirent sysfs_root;
> -extern struct super_block *sysfs_sb;
>  extern struct kmem_cache *sysfs_dir_cachep;
> 
>  /*
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
