Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0BCQ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:28:17 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38360 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab0BCQ2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:28:16 -0500
MIME-Version: 1.0
In-Reply-To: <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com> 
	<0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> 
	<cover.1265173480.git.amit.kucheria@canonical.com> <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com> 
	<ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Feb 2010 09:27:55 -0700
X-Google-Sender-Auth: 0b6425e13bed02a2
Message-ID: <fa686aa41002030827m16efb947uc798cd538a6f786c@mail.gmail.com>
Subject: Re: [PATCHv2 03/11] mxc: Fix Drive Strength Field in the IOMUX 
	controller
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 10:16 PM, Amit Kucheria
<amit.kucheria@canonical.com> wrote:
> i.MX51 defines 4 values:
>
> 00: Low Drive Strength
> 01: Medium Drive Strength
> 10: High Drive Strength
> 11: Max Drive Strength
>
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/include/mach/iomux-v3.h |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> index 1deda01..f2f73d3 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> @@ -81,11 +81,13 @@ struct pad_desc {
>
>  #define PAD_CTL_ODE                    (1 << 3)
>
> -#define PAD_CTL_DSE_STANDARD           (0 << 1)
> -#define PAD_CTL_DSE_HIGH               (1 << 1)
> -#define PAD_CTL_DSE_MAX                        (2 << 1)
> +#define PAD_CTL_DSE_LOW                        (0 << 1)
> +#define PAD_CTL_DSE_MED                        (1 << 1)
> +#define PAD_CTL_DSE_HIGH               (2 << 1)
> +#define PAD_CTL_DSE_MAX                        (3 << 1)
>
>  #define PAD_CTL_SRE_FAST               (1 << 0)
> +#define PAD_CTL_SRE_SLOW               (0 << 0)

Shouldn't the addition/change of #defines be done in patches that
actually use them?

It would also help to include in the commit description what the
impact of the change in values is.  The description as written doesn't
really give any indication on why the patch is important, which makes
it hard to review.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
