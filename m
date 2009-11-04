Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZKDEdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZKDEdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZKDEdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:33:51 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41761 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbZKDEdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:33:50 -0500
Date: Tue, 3 Nov 2009 22:33:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 08/13] sysfs: Nicely indent
	sysfs_symlink_inode_operations
Message-ID: <20091104043352.GI27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-8-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-8-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Lining up the functions in sysfs_symlink_inode_operations
> follows the pattern in the rest of sysfs and makes things
> slightly more readable.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/symlink.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
> index c5081ad..1137418 100644
> --- a/fs/sysfs/symlink.c
> +++ b/fs/sysfs/symlink.c
> @@ -210,10 +210,10 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd, void *co
>  }
> 
>  const struct inode_operations sysfs_symlink_inode_operations = {
> -	.setxattr = sysfs_setxattr,
> -	.readlink = generic_readlink,
> -	.follow_link = sysfs_follow_link,
> -	.put_link = sysfs_put_link,
> +	.setxattr	= sysfs_setxattr,
> +	.readlink	= generic_readlink,
> +	.follow_link	= sysfs_follow_link,
> +	.put_link	= sysfs_put_link,
>  };
> 
> 
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
