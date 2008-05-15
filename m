Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbYEOWfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbYEOWfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759759AbYEOWfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:35:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16170 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYEOWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:35:29 -0400
Message-ID: <31763212.1210890834426.JavaMail.oracle@acsmt305.oracle.com>
Date: Thu, 15 May 2008 17:33:54 -0500 (CDT)
From: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] crypto: fix cryptd build fix due to missing ahash
Cc: linux-kernel@vger.kernel.org, Loc Ho <lho@amcc.com>,
       herbert@gondor.apana.org.au, linux-next@vger.kernel.org
In-Reply-To: <20080515212856.GB3081@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
References: <4694288.1210878773358.JavaMail.oracle@acsmt302.oracle.com> <20080515212856.GB3081@Chamillionaire.breakpoint.cc>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This was reported by Randy Dunlap:
> |crypto/built-in.o: In function `cryptd_alloc':
> |cryptd.c:(.text+0x9b5a): undefined reference to `crypto_ahash_type'
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  crypto/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 5963a95..ffcd467 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -66,6 +66,7 @@ config CRYPTO_CRYPTD
>  	tristate "Software async crypto daemon"
>  	select CRYPTO_BLKCIPHER
>  	select CRYPTO_MANAGER
> +	select CRYPTO_HASH
>  	help
>  	  This is a generic software asynchronous crypto daemon that
>  	  converts an arbitrary synchronous software crypto algorithm
> -- 
> 1.5.4.3
> 

