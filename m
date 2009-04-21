Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZDUHcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZDUHcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZDUHca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:32:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48026 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbZDUHc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:32:29 -0400
Date: Tue, 21 Apr 2009 09:32:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pktcdvd.h should include mempool.h
Message-ID: <20090421073228.GA4593@kernel.dk>
References: <1240215444-8137-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240215444-8137-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20 2009, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com> 
> 
> Fix this build error:
> In file included from fs/compat_ioctl.c:104:
> include/linux/pktcdvd.h:285: error: expected specifier-qualifier-list before 'mempool_t'

Applied

> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>  include/linux/pktcdvd.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
> index 04b4d73..d745f5b 100644
> --- a/include/linux/pktcdvd.h
> +++ b/include/linux/pktcdvd.h
> @@ -113,6 +113,7 @@ struct pkt_ctrl_command {
>  #include <linux/cdrom.h>
>  #include <linux/kobject.h>
>  #include <linux/sysfs.h>
> +#include <linux/mempool.h>
>  
>  /* default bio write queue congestion marks */
>  #define PKT_WRITE_CONGESTION_ON    10000
> -- 
> 1.6.2.3
> 

-- 
Jens Axboe

