Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZCLLWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZCLLWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZCLLWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:22:35 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:58190 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZCLLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:22:34 -0400
Date: Thu, 12 Mar 2009 11:22:31 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: Linux-sh <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA
	of SuperH
Message-ID: <20090312112231.GE1475@console-pimps.org>
References: <49B8AF67.8080309@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8AF67.8080309@renesas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:44:55PM +0900, Nobuhiro Iwamatsu wrote:
> This supports DMA-Engine driver for DMA of SuperH.
> This supported all DMA channels, and it was tested in SH7722/SH7780.
> This can not use with SH DMA API and can control this in Kconfig.
> 

I was working on support for this, but fortunately for me you beat me
to a finished implementation ;-)

The code looks good to me. Just a few (very very) minor nits.

Reviewed-by: Matt Fleming <matt@console-pimps.org>

[...]

> 
> +/* for dma engine */
> +/* mode */
> +#define SHDMA_MIX_IRQ	(1 << 1)

The proper multi-line kernel comment style is

	/*
	 *
	 */

though this comment can all fit on one line.

> +
> +static void dmae_init(struct sh_dmae_chan *sh_chan)
> +{
> +	u32 chcr = RS_DEFAULT; /* default is DUAL mode */
> +	sh_dmae_writel(sh_chan, chcr, CHCR);
> +}
> +
> +/*
> + * Reset DMA controler

controler -> controller

Good work!
