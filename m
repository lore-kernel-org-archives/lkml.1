Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbYBHRi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbYBHRi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbYBHRiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:38:15 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52716 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbYBHRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:38:14 -0500
Date: Fri, 8 Feb 2008 18:38:10 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unifdef linux/vt.h
Message-ID: <20080208173810.GA22895@aepfle.de>
References: <20080125180215.GA30039@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080125180215.GA30039@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, Olaf Hering wrote:

> remove the newly added __KERNEL__ block from linux/vt.h

Can you pick this up? The patch cant get any better.

> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -157,7 +157,6 @@ header-y += veth.h
>  header-y += video_decoder.h
>  header-y += video_encoder.h
>  header-y += videotext.h
> -header-y += vt.h
>  header-y += x25.h
>  
>  unifdef-y += acct.h
> @@ -348,6 +347,7 @@ unifdef-y += videodev.h
>  unifdef-y += virtio_config.h
>  unifdef-y += virtio_blk.h
>  unifdef-y += virtio_net.h
> +unifdef-y += vt.h
>  unifdef-y += wait.h
>  unifdef-y += wanrouter.h
>  unifdef-y += watchdog.h
