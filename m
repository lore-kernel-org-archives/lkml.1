Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYIAAiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYIAAiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 20:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYIAAiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 20:38:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:36168 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYIAAiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 20:38:12 -0400
Subject: Re: [PATCH] ibm_newemac: MAL[12]_IER_EVENTS definition: 2x *_OTE
	-> *_DE
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: roel kluin <roel.kluin@gmail.com>
Cc: david@gibson.dropbear.id.au, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48B9B218.6060506@gmail.com>
References: <48B9B218.6060506@gmail.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 10:30:47 +1000
Message-Id: <1220229047.13162.405.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-30 at 22:48 +0200, roel kluin wrote:
> MAL[12]_IER_EVENTS definitions have MAL_IER_OTE twice
> but lack MAL_IER_DE
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Thanks.

> ---
>  drivers/net/ibm_newemac/mal.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ibm_newemac/mal.h b/drivers/net/ibm_newemac/mal.h
> index eaa7262..717dc38 100644
> --- a/drivers/net/ibm_newemac/mal.h
> +++ b/drivers/net/ibm_newemac/mal.h
> @@ -102,7 +102,7 @@
>  /* MAL V1 IER bits */
>  #define   MAL1_IER_NWE		0x00000008
>  #define   MAL1_IER_SOC_EVENTS	MAL1_IER_NWE
> -#define   MAL1_IER_EVENTS	(MAL1_IER_SOC_EVENTS | MAL_IER_OTE | \
> +#define   MAL1_IER_EVENTS	(MAL1_IER_SOC_EVENTS | MAL_IER_DE | \
>  				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
>  
>  /* MAL V2 IER bits */
> @@ -110,7 +110,7 @@
>  #define   MAL2_IER_PRE		0x00000040
>  #define   MAL2_IER_PWE		0x00000020
>  #define   MAL2_IER_SOC_EVENTS	(MAL2_IER_PT | MAL2_IER_PRE | MAL2_IER_PWE)
> -#define   MAL2_IER_EVENTS	(MAL2_IER_SOC_EVENTS | MAL_IER_OTE | \
> +#define   MAL2_IER_EVENTS	(MAL2_IER_SOC_EVENTS | MAL_IER_DE | \
>  				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
>  
> 

