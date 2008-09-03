Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYICOJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYICOJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYICOIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:08:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43715 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbYICOIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:08:53 -0400
Message-ID: <48BE9A6D.1000109@garzik.org>
Date: Wed, 03 Sep 2008 10:08:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: david@gibson.dropbear.id.au, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibm_newemac: MAL[12]_IER_EVENTS definition: 2x *_OTE
 -> *_DE
References: <48B9B218.6060506@gmail.com>
In-Reply-To: <48B9B218.6060506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin wrote:
> MAL[12]_IER_EVENTS definitions have MAL_IER_OTE twice
> but lack MAL_IER_DE
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
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

applied


