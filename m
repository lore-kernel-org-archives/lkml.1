Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbYKSAWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbYKSAWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYKSAWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:22:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbYKSAWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:22:39 -0500
Date: Tue, 18 Nov 2008 16:22:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: implement mode and dmode mounting options
Message-Id: <20081118162205.bc61e2b4.akpm@linux-foundation.org>
In-Reply-To: <20081116195129.GA5920@joi>
References: <20081116195129.GA5920@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 20:52:19 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> "dmode" allows overriding permissions of directories and
> "mode" allows overriding permissions of files.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  Documentation/filesystems/udf.txt |    2 ++
>  fs/udf/inode.c                    |   11 +++++++++--
>  fs/udf/super.c                    |   31 ++++++++++++++++++++++++++++++-
>  fs/udf/udf_sb.h                   |    2 ++
>  4 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/udf.txt b/Documentation/filesystems/udf.txt
> index fde829a..902b95d 100644
> --- a/Documentation/filesystems/udf.txt
> +++ b/Documentation/filesystems/udf.txt
> @@ -24,6 +24,8 @@ The following mount options are supported:
>  
>  	gid=		Set the default group.
>  	umask=		Set the default umask.
> +	mode=		Set the default file permissions.
> +	dmode=		Set the default directory permissions.

Can we give these the same names and usage as their fatfs equivalents?
