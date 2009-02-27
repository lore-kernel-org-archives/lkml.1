Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZB0BKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZB0BKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZB0BKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:10:18 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:51718 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZB0BKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:10:17 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000459.17557.20005.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000459.17557.20005.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:10:14 +0100
Message-ID: <154e089b0902261710ybebe696p2c87334b29bf08a0@mail.gmail.com>
Subject: Re: [PATCH 11/16] fs/super.c: fix sparse warning: Using plain integer 
	as NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Feb 22, 2009 at 1:05 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warning:
>  fs/super.c:849:26: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  fs/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/super.c b/fs/super.c
> index c38eef4..c6ad02d 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -846,7 +846,7 @@ void kill_block_super(struct super_block *sb)
>        struct block_device *bdev = sb->s_bdev;
>        fmode_t mode = sb->s_mode;
>
> -       bdev->bd_super = 0;
> +       bdev->bd_super = NULL;
>        generic_shutdown_super(sb);
>        sync_blockdev(bdev);
>        close_bdev_exclusive(bdev, mode);
>
>
