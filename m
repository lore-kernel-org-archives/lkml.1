Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYG0P7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYG0P7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYG0P73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:59:29 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55529 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYG0P72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:59:28 -0400
Date: Sun, 27 Jul 2008 18:58:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Niels de Vos <niels@nixpanic.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] linux/fs.h should include linux/path.h
Message-ID: <20080727155852.GO9301@cs181140183.pp.htv.fi>
References: <488C6B4E.8040205@nixpanic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <488C6B4E.8040205@nixpanic.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 02:34:22PM +0200, Niels de Vos wrote:
> <linux/fs.h> defines 'struct file' which uses 'struct path'. However
> <linux/path.h> is not being included.
> 
> Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
> 
> ---
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d8e2762..a14f1c4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -289,6 +289,7 @@ extern int dir_notify_enable;
>  #include <linux/mutex.h>
>  #include <linux/capability.h>
>  #include <linux/semaphore.h>
> +#include <linux/path.h>
>...

This #include was recently added a few lines above.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

