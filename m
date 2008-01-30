Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYA3UQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYA3UQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765000AbYA3UKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:10:11 -0500
Received: from waste.org ([66.93.16.53]:50854 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbYA3UKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:10:09 -0500
Subject: Re: [2.6 patch] unexport add_disk_randomness
From: Matt Mackall <mpm@selenic.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080130200227.GS29368@does.not.exist>
References: <20080130200227.GS29368@does.not.exist>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 14:09:22 -0600
Message-Id: <1201723762.4037.40.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 22:02 +0200, Adrian Bunk wrote:
> This patch removes the no longer used EXPORT_SYMBOL(add_disk_randomness).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Matt Mackall <mpm@selenic.com>

> ---
> f1a195a30248eae541ba006633aa70385d1eb785 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 5fee056..c511a83 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -667,8 +667,6 @@ void add_disk_randomness(struct gendisk *disk)
>  	add_timer_randomness(disk->random,
>  			     0x100 + MKDEV(disk->major, disk->first_minor));
>  }
> -
> -EXPORT_SYMBOL(add_disk_randomness);
>  #endif
>  
>  #define EXTRACT_SIZE 10
-- 
Mathematics is the supreme nostalgia of our time.

