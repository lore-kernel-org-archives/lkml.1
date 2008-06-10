Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYFJJIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYFJJIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFJJIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:08:07 -0400
Received: from www.tglx.de ([62.245.132.106]:53471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbYFJJIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:08:04 -0400
Date: Tue, 10 Jun 2008 11:07:56 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] UIO: minor style and comment fixes
Message-ID: <20080610090755.GD4611@local>
References: <20080610071032.GB22814@digi.com> <1213082088-24294-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213082088-24294-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:14:48AM +0200, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  include/linux/uio_driver.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index cf65e96..cdf338d 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -36,7 +36,7 @@ struct uio_mem {
>  	struct uio_map		*map;
>  };
>  
> -#define MAX_UIO_MAPS 	5
> +#define MAX_UIO_MAPS	5
>  
>  struct uio_device;
>  
> @@ -82,11 +82,11 @@ static inline int __must_check
>  extern void uio_unregister_device(struct uio_info *info);
>  extern void uio_event_notify(struct uio_info *info);
>  
> -/* defines for uio_device->irq */
> +/* defines for uio_info->irq */
>  #define UIO_IRQ_CUSTOM	-1
>  #define UIO_IRQ_NONE	-2
>  
> -/* defines for uio_device->memtype */
> +/* defines for uio_mem->memtype */
>  #define UIO_MEM_NONE	0
>  #define UIO_MEM_PHYS	1
>  #define UIO_MEM_LOGICAL	2
> -- 
> 1.5.5.3
