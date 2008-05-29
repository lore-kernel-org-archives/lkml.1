Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYE2ScE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYE2ScE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYE2Sbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:31:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58810 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYE2Sbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:31:51 -0400
Date: Thu, 29 May 2008 21:28:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] Werror: Remove iiEllisCleanup() as it's unused.
Message-ID: <20080529182853.GA32180@cs181133002.pp.htv.fi>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk> <20080529181736.5396.28119.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080529181736.5396.28119.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 07:17:36PM +0100, David Howells wrote:
> Remove iiEllisCleanup() as it's unused.


It is used with CONFIG_COMPUTONE=m - this empty function is kinda 
pointless but you also have to remove the caller from ip2main.c if
you want to remove it.


> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/char/ip2/i2ellis.c |   16 ----------------
>  1 files changed, 0 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/drivers/char/ip2/i2ellis.c b/drivers/char/ip2/i2ellis.c
> index 3601017..a7c89d8 100644
> --- a/drivers/char/ip2/i2ellis.c
> +++ b/drivers/char/ip2/i2ellis.c
> @@ -85,22 +85,6 @@ iiEllisInit(void)
>  }
>  
>  //******************************************************************************
> -// Function:   iiEllisCleanup()
> -// Parameters: None
> -//
> -// Returns:    Nothing
> -//
> -// Description:
> -//
> -// This routine performs any required cleanup of the iiEllis subsystem.
> -//
> -//******************************************************************************
> -static void
> -iiEllisCleanup(void)
> -{
> -}
> -
> -//******************************************************************************
>  // Function:   iiSetAddress(pB, address, delay)
>  // Parameters: pB      - pointer to the board structure
>  //             address - the purported I/O address of the board

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

