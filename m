Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZBKNli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZBKNli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZBKNl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:41:28 -0500
Received: from mail.suse.de ([195.135.220.2]:37579 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZBKNl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:41:27 -0500
Date: Wed, 11 Feb 2009 14:41:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Bill Nottingham <notting@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
In-Reply-To: <1234279525-25143-1-git-send-email-notting@redhat.com>
Message-ID: <alpine.LNX.1.10.0902111438280.31014@jikos.suse.cz>
References: <1234279525-25143-1-git-send-email-notting@redhat.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009, Bill Nottingham wrote:

> Otherwise, these don't work when called from 32-bit userspace on 64-bit kernels.
> ---
>  fs/compat_ioctl.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 5235c67..9ee71a0 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1937,6 +1937,8 @@ ULONG_IOCTL(SET_BITMAP_FILE)
>  /* Big K */
>  COMPATIBLE_IOCTL(PIO_FONT)
>  COMPATIBLE_IOCTL(GIO_FONT)
> +COMPATIBLE_IOCTL(PIO_CMAP)
> +COMPATIBLE_IOCTL(GIO_CMAP)
>  ULONG_IOCTL(KDSIGACCEPT)
>  COMPATIBLE_IOCTL(KDGETKEYCODE)
>  COMPATIBLE_IOCTL(KDSETKEYCODE)
> -- 
> 1.6.1.2

Alan, I am hesitant to consider this material implicitly applicable for 
trivial tree. Could you please give your Acked-by for it so that I can 
merge, or take it through your tree completely?

Thanks,

-- 
Jiri Kosina
SUSE Labs
