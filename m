Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0BCQH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:07:59 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:53838 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab0BCQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dcikurpO60OHIERHFpPvUsnMZ2j9elnFlIPZXCP9wYO3Vgt36PJGMPbYrkLpNvPjyz
         D2W9WJsDfZqIaEtm572FeuDILr7QypPnOvhw2aZHW5wqkwB4xNEM7kDj0RPh+taHTHwg
         tySgN+WULYMx7N19BSl9k1c72KYWWIere5slQ=
Date: Wed, 3 Feb 2010 21:38:36 +0530
From: Rabin Vincent <rabin@rab.in>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCHv2 05/11] mxc: Core support for i.MX5 series of
 processors from Freescale
Message-ID: <20100203160835.GA1928@debian>
References: <cover.1265173480.git.amit.kucheria@canonical.com>
 <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:16:27PM -0800, Amit Kucheria wrote:
> diff --git a/arch/arm/mach-mx5/clock.c b/arch/arm/mach-mx5/clock.c
[...]
> +static struct clk_lookup lookups[] __initdata = {
> +	_REGISTER_CLOCK("imx-uart.0", NULL, uart1_clk)
> +	_REGISTER_CLOCK("imx-uart.1", NULL, uart2_clk)
> +	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
> +	_REGISTER_CLOCK(NULL, "gpt", gpt_clk)
> +	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
> +};

This shouldn't be __initdata.  clk_get() uses this, and modules may use
clk_get().

Rabin
