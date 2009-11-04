Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZKDEdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZKDEdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZKDEdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:33:37 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41724 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZKDEdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:33:36 -0500
Date: Tue, 3 Nov 2009 22:33:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 02/13] sysfs: Rename sysfs_d_iput to sysfs_dentry_iput
Message-ID: <20091104043339.GH27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-2-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-2-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Using dentry instead of d in the function name is what
> several other filesystems are doing and it seems to be
> a more readable convention.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/dir.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index e020183..130dfc3 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -298,7 +298,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
>  		goto repeat;
>  }
> 
> -static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
> +static void sysfs_dentry_iput(struct dentry * dentry, struct inode * inode)
>  {
>  	struct sysfs_dirent * sd = dentry->d_fsdata;
> 
> @@ -307,7 +307,7 @@ static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
>  }
> 
>  static const struct dentry_operations sysfs_dentry_ops = {
> -	.d_iput		= sysfs_d_iput,
> +	.d_iput		= sysfs_dentry_iput,
>  };
> 
>  struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
