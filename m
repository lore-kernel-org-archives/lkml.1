Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZLDJiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZLDJiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZLDJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:38:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38336 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZLDJiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:38:18 -0500
Date: Fri, 4 Dec 2009 10:38:24 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 04/10] arm: mxc: Fix Drive Strength Field in the
	IOMUX controller
Message-ID: <20091204093824.GB10910@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <a079a0627e77f2df590840e4798fc067f4436160.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a079a0627e77f2df590840e4798fc067f4436160.1259893118.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 04, 2009 at 04:47:04AM +0200, Amit Kucheria wrote:
> i.MX51 defines 4 values:
> 
> 00: Low Drive Strength
> 01: Medium Drive Strength
> 10: High Drive Strength
> 11: Max Drive Strength
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/include/mach/iomux-v3.h |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> index a0fa402..8c351d6 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> @@ -81,11 +81,13 @@ struct pad_desc {
>  
>  #define PAD_CTL_ODE			(1 << 3)
>  
> -#define PAD_CTL_DSE_STANDARD		(0 << 1)
> -#define PAD_CTL_DSE_HIGH		(1 << 1)
> -#define PAD_CTL_DSE_MAX			(2 << 1)
> +#define PAD_CTL_DSE_LOW			(0 << 1)
> +#define PAD_CTL_DSE_MED			(1 << 1)
> +#define PAD_CTL_DSE_HIGH		(2 << 1)
> +#define PAD_CTL_DSE_MAX			(3 << 1)
Does the new values work on other SOCs having iomux-v3, too?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
