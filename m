Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0BIXJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 18:09:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:38006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0BIXJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 18:09:44 -0500
Date: Tue, 9 Feb 2010 15:07:30 -0800
From: Greg KH <gregkh@suse.de>
To: Jochen Maes <jochen.maes@sejo.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: dream: Codestyle fix
Message-ID: <20100209230730.GD21484@suse.de>
References: <1265756347-14172-1-git-send-email-jochen.maes@sejo.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265756347-14172-1-git-send-email-jochen.maes@sejo.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 11:59:07PM +0100, Jochen Maes wrote:
> 	Fixed Codestyle issues
> 
> Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
> ---
>  drivers/staging/dream/pmem.c |   26 ++++++++++++--------------
>  1 files changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
> index def6468..ec4e7d1 100644
> --- a/drivers/staging/dream/pmem.c
> +++ b/drivers/staging/dream/pmem.c
> @@ -37,17 +37,17 @@
>   * the file should not be released until put_pmem_file is called */
>  #define PMEM_FLAGS_BUSY 0x1
>  /* indicates that this is a suballocation of a larger master range */
> -#define PMEM_FLAGS_CONNECTED 0x1 << 1
> +#define PMEM_FLAGS_CONNECTED { 0x1 << 1 }

Shouldn't this be using a ( ) and not { } ?

>  /* indicates this is a master and not a sub allocation and that it is mmaped */
> -#define PMEM_FLAGS_MASTERMAP 0x1 << 2
> +#define PMEM_FLAGS_MASTERMAP { 0x1 << 2 }
>  /* submap and unsubmap flags indicate:
>   * 00: subregion has never been mmaped
>   * 10: subregion has been mmaped, reference to the mm was taken
>   * 11: subretion has ben released, refernece to the mm still held
>   * 01: subretion has been released, reference to the mm has been released
>   */
> -#define PMEM_FLAGS_SUBMAP 0x1 << 3
> -#define PMEM_FLAGS_UNSUBMAP 0x1 << 4
> +#define PMEM_FLAGS_SUBMAP { 0x1 << 3 }
> +#define PMEM_FLAGS_UNSUBMAP { 0x1 << 4 }

Same for these.

> @@ -152,7 +152,7 @@ struct pmem_info {
>  static struct pmem_info pmem[PMEM_MAX_DEVICES];
>  static int id_count;
>  
> -#define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)
> +#define PMEM_IS_FREE(id, index) { !(pmem[id].bitmap[index].allocated) }

And this.

care to fix this up and resend the patch?

thanks,

greg k-h
