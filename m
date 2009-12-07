Return-Path: <linux-kernel-owner+w=401wt.eu-S935146AbZLGODS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146AbZLGODS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935126AbZLGODR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:03:17 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:53673 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114AbZLGODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:03:17 -0500
Date: Mon, 7 Dec 2009 15:03:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: PTR_ERR return of wrong pointer in
 fallback_init_cip()
Message-ID: <20091207150326.631e564d@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4B1D0399.2070307@gmail.com>
References: <4B1D0399.2070307@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 14:31:05 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/s390/crypto/aes_s390.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index 6118890..6be4503 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -174,7 +174,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
>  	if (IS_ERR(sctx->fallback.cip)) {
>  		pr_err("Allocating AES fallback algorithm %s failed\n",
>  		       name);
> -		return PTR_ERR(sctx->fallback.blk);
> +		return PTR_ERR(sctx->fallback.cip);
>  	}
> 
>  	return 0;

Added to my queue, thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

