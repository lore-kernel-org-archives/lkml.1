Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbXKTI1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbXKTI1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXKTI1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:27:47 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:50534 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbXKTI1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:27:46 -0500
Date: Tue, 20 Nov 2007 09:27:15 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-s390@vger.kernel.org, linux390@de.ibm.com
Subject: Re: [PATCH 05/59] arch/s390: Add missing "space"
Message-ID: <20071120082715.GA7992@osiris.boeblingen.de.ibm.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <ebeb1446c117c71636bb6f2308645a85f81edac5.1195454434.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebeb1446c117c71636bb6f2308645a85f81edac5.1195454434.git.joe@perches.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 05:47:57PM -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/s390/crypto/aes_s390.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index 5126696..e2f6216 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -341,7 +341,7 @@ static int __init aes_init(void)
>  		ecb_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
>  		cbc_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
>  		printk(KERN_INFO
> -		       "aes_s390: hardware acceleration only available for"
> +		       "aes_s390: hardware acceleration only available for "
>  		       "128 bit keys\n");

Applied. Thanks!
