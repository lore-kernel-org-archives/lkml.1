Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbXK2Uz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbXK2Uz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761871AbXK2UzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:55:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:54677 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761874AbXK2UzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:55:18 -0500
Subject: Re: [PATCH 5/5] PPC cleanup: powermac - do use for_each macro
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: PPCML <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20071129194654.GF12123@cvg>
References: <20071129194654.GF12123@cvg>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 07:54:59 +1100
Message-Id: <1196369699.13230.62.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-29 at 22:46 +0300, Cyrill Gorcunov wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---

Ack.

>  arch/powerpc/platforms/powermac/low_i2c.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
> index da2007e..864fbf4 100644
> --- a/arch/powerpc/platforms/powermac/low_i2c.c
> +++ b/arch/powerpc/platforms/powermac/low_i2c.c
> @@ -585,8 +585,7 @@ static void __init kw_i2c_probe(void)
>  	struct device_node *np, *child, *parent;
>  
>  	/* Probe keywest-i2c busses */
> -	for (np = NULL;
> -	     (np = of_find_compatible_node(np, "i2c","keywest-i2c")) != NULL;){
> +	for_each_compatible_node(np, "i2c","keywest-i2c") {
>  		struct pmac_i2c_host_kw *host;
>  		int multibus, chans, i;
>  

