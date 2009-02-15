Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZBOUlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZBOUlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZBOUlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:41:02 -0500
Received: from xenotime.net ([72.52.64.118]:49406 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752577AbZBOUlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:41:00 -0500
Date: Sun, 15 Feb 2009 12:41:39 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security/smack/smack_lsm.c: cleanup kernel-doc
Message-Id: <20090215124139.ecbacba4.rdunlap@xenotime.net>
In-Reply-To: <49900c55.0e1b6e0a.5174.3e17@mx.google.com>
References: <49900c55.0e1b6e0a.5174.3e17@mx.google.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 18:58:25 +0800 Qinghuang Feng wrote:

> Remove comments which refer to nonexistent arguments.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 0278bc0..02c48ea 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -538,7 +538,6 @@ static int smack_inode_rename(struct inode *old_inode,
>   * smack_inode_permission - Smack version of permission()
>   * @inode: the inode in question
>   * @mask: the access requested
> - * @nd: unused
>   *
>   * This is the important Smack hook.
>   *
> @@ -701,8 +700,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
>   * @inode: the object
>   * @name: attribute name
>   * @buffer: where to put the result
> - * @size: size of the buffer
> - * @err: unused
> + * @alloc: unused
>   *
>   * Returns the size of the attribute or an error code
>   */
> 
> --

ACK, but there are lots of other kernel-doc problems in security/smack/
that could stand to be fixed...

Thanks,
---
~Randy
