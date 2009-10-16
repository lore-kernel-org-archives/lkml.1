Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZJPNXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZJPNXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbZJPNXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:23:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:37070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZJPNXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:23:04 -0400
Date: Fri, 16 Oct 2009 15:22:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: lethal@linux-sh.org, damm@igel.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] trivial: fix typo s/complied-in/compiled-in/
In-Reply-To: <1255635925-5738-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0910161522180.8582@wotan.suse.de>
References: <1255635925-5738-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/video/fb_defio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
> index c27ab1e..e59c083 100644
> --- a/drivers/video/fb_defio.c
> +++ b/drivers/video/fb_defio.c
> @@ -71,7 +71,7 @@ int fb_deferred_io_fsync(struct file *file, struct dentry *dentry, int datasync)
>  {
>  	struct fb_info *info = file->private_data;
>  
> -	/* Skip if deferred io is complied-in but disabled on this fbdev */
> +	/* Skip if deferred io is compiled-in but disabled on this fbdev */
>  	if (!info->fbdefio)
>  		return 0;

Hi,

as patches 2-8 from your series only fix typos/grammar in code comments, I 
have merged them together into one patch and applied to trivial queue. 
Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
