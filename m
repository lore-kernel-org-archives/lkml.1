Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYKSQBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYKSQBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYKSQBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:01:04 -0500
Received: from mail.suse.de ([195.135.220.2]:34910 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbYKSQBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:01:03 -0500
Date: Wed, 19 Nov 2008 07:57:36 -0800
From: Greg KH <gregkh@suse.de>
To: crquan@gmail.com
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_add: use constant strings directly as fmt
	strings
Message-ID: <20081119155736.GA5072@suse.de>
References: <1227110059-12529-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227110059-12529-1-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 11:54:19PM +0800, crquan@gmail.com wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> ---
>  block/blk-sysfs.c |    2 +-
>  block/elevator.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 21e275d..0b189e9 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -342,7 +342,7 @@ int blk_register_queue(struct gendisk *disk)
>  		return 0;
>  
>  	ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
> -			  "%s", "queue");
> +			  "queue");

Why?  What does this change buy us?

thanks,

greg k-h
