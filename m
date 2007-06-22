Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXFVLe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXFVLe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXFVLeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:34:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36247 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969AbXFVLeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:34:18 -0400
Date: Fri, 22 Jun 2007 13:34:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 6/12] acpi: fix compile warnings
Message-ID: <20070622113437.GM23017@stusta.de>
References: <20070619225011.GH5193@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070619225011.GH5193@alberich.amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 12:50:11AM +0200, Andreas Herrmann wrote:
> Fix compile warnings:
> 
>  drivers/acpi/bus.c: In function 'acpi_bus_get_power':
>  drivers/acpi/bus.c:162: warning: implicit declaration of function 'acpi_power_get_inferred_state'
>  drivers/acpi/bus.c: In function 'acpi_bus_set_power':
>  drivers/acpi/bus.c:232: warning: implicit declaration of function 'acpi_power_transition'
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index b4a9ea5..e01dca1 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -43,6 +43,8 @@ ACPI_MODULE_NAME("bus");
>  #ifdef	CONFIG_X86
>  extern void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger);
>  #endif
> +extern int acpi_power_get_inferred_state(struct acpi_device *);
> +extern int acpi_power_transition(struct acpi_device *, int);
>...

NAK, they belong into a header file.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

