Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZBNK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZBNK1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 05:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZBNK1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 05:27:08 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:49359 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZBNK1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 05:27:07 -0500
Date: Sat, 14 Feb 2009 13:27:04 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] Staging: pohmelfs should depend on CRYPTO
Message-ID: <20090214102704.GB29771@ioremap.net>
References: <20090213150654.GA7390@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213150654.GA7390@orion>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 06:06:54PM +0300, Alexander Beregalov (a.beregalov@gmail.com) wrote:
> 
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Doesn't subsystem selection also forces higher level selection, i.e.
selecing CRYPTO_BLKCIPHER also forces CRYPTO selection? If it is not the
case, then your patch is definitely valid.

> ---
> 
>  drivers/staging/pohmelfs/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/pohmelfs/Kconfig b/drivers/staging/pohmelfs/Kconfig
> index f150ecb..4c6276b 100644
> --- a/drivers/staging/pohmelfs/Kconfig
> +++ b/drivers/staging/pohmelfs/Kconfig
> @@ -1,6 +1,7 @@
>  config POHMELFS
>  	tristate "POHMELFS filesystem support"
>  	select CONNECTOR
> +	select CRYPTO
>  	select CRYPTO_BLKCIPHER
>  	select CRYPTO_HMAC
>  	help

-- 
	Evgeniy Polyakov
