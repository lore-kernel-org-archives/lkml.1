Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbYGWTB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbYGWTB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYGWTBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:01:12 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1190 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYGWTBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:01:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make pnp_build_option() static
Date: Wed, 23 Jul 2008 13:00:42 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: ambx1@neo.rr.com, Rene Herman <rene.herman@gmail.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Len Brown <lenb@kernel.org>
References: <20080722172021.GN14846@cs181140183.pp.htv.fi>
In-Reply-To: <20080722172021.GN14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807231300.42905.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 11:20:21 am Adrian Bunk wrote:
> pnp_build_optionq() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

PNP patches have been going through the ACPI tree lately.
I copied Andi and Len.

> ---
> 87ec46ea755fc5349371bf2208b30264da355699 
> diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
> index 4cfe3a1..2e5b7eb 100644
> --- a/drivers/pnp/resource.c
> +++ b/drivers/pnp/resource.c
> @@ -30,8 +30,9 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
>   * option registration
>   */
>  
> -struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
> -				    unsigned int option_flags)
> +static struct pnp_option *pnp_build_option(struct pnp_dev *dev,
> +					   unsigned long type,
> +					   unsigned int option_flags)
>  {
>  	struct pnp_option *option;
>  
> 
> 


