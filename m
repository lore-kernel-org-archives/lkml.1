Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbYDZWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbYDZWhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYDZWhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:37:38 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:52080 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbYDZWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:37:38 -0400
Message-ID: <4813AEB6.9070901@keyaccess.nl>
Date: Sun, 27 Apr 2008 00:37:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 44/54] PNP: add pnp_new_resource() to find a new unset
 pnp_resource
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183933.066428168@ldl.fc.hp.com>
In-Reply-To: <20080425183933.066428168@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-04-08 20:38, Bjorn Helgaas wrote:

> +	switch (type) {
> +	case IORESOURCE_IO:
> +		for (i = 0; i < PNP_MAX_PORT; i++) {
> +			pnp_res = &dev->res->port[i];
> +			res = &pnp_res->res;
> +			if (res->flags & IORESOURCE_UNSET)
> +				return pnp_res;

Again possible users of pnp_resource_valid().

> +		}
> +		break;
> +	case IORESOURCE_MEM:
> +		for (i = 0; i < PNP_MAX_MEM; i++) {
> +			pnp_res = &dev->res->mem[i];
> +			res = &pnp_res->res;
> +			if (res->flags & IORESOURCE_UNSET)
> +				return pnp_res;
> +		}
> +		break;
> +	case IORESOURCE_IRQ:
> +		for (i = 0; i < PNP_MAX_IRQ; i++) {
> +			pnp_res = &dev->res->irq[i];
> +			res = &pnp_res->res;
> +			if (res->flags & IORESOURCE_UNSET)
> +				return pnp_res;
> +		}
> +		break;
> +	case IORESOURCE_DMA:
> +		for (i = 0; i < PNP_MAX_DMA; i++) {
> +			pnp_res = &dev->res->dma[i];
> +			res = &pnp_res->res;
> +			if (res->flags & IORESOURCE_UNSET)
> +				return pnp_res;
> +		}
> +		break;
> +	}
> +	return NULL;
> +}
> +

Rene
