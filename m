Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbZB0BMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbZB0BMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZB0BMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:12:23 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:44837 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZB0BMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:12:22 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000511.17557.96434.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000511.17557.96434.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:12:18 +0100
Message-ID: <154e089b0902261712q3dad68d7s567d0b6d9c7ee031@mail.gmail.com>
Subject: Re: [PATCH 12/16] reiserfs: fix sparse warning: Using plain integer 
	as NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To, Cc]

On Sun, Feb 22, 2009 at 1:05 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warning:
>  fs/reiserfs/inode.c:2555:19: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  fs/reiserfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index 823227a..e69d63a 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -2552,7 +2552,7 @@ static int reiserfs_write_begin(struct file *file,
>        int old_ref = 0;
>
>        inode = mapping->host;
> -       *fsdata = 0;
> +       *fsdata = NULL;
>        if (flags & AOP_FLAG_CONT_EXPAND &&
>            (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
>                pos ++;
>
>
