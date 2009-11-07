Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZKGCHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZKGCHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZKGCHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:07:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:37683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbZKGCHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:07:04 -0500
Message-ID: <4AF4D640.7030101@kernel.org>
Date: Sat, 07 Nov 2009 11:06:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 09/13] sysfs: Implement sysfs_getattr & sysfs_permission
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-9-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1257249429-12384-9-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
> index 1137418..c5eff49 100644
> --- a/fs/sysfs/symlink.c
> +++ b/fs/sysfs/symlink.c
> @@ -214,6 +214,9 @@ const struct inode_operations sysfs_symlink_inode_operations = {
>  	.readlink	= generic_readlink,
>  	.follow_link	= sysfs_follow_link,
>  	.put_link	= sysfs_put_link,
> +	.setattr	= sysfs_setattr,

It would be nice either to separate addition of setattr to symlinks
into a separate patch or note it in the description.

Thanks.

-- 
tejun
