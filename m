Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbXFTEaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbXFTEaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbXFTEaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:30:21 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:65144 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXFTEaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:30:20 -0400
Date: Wed, 20 Jun 2007 13:30:12 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 12/12] acpi: select ACPI_EC for SONY_LAPTOP
Message-ID: <20070620043011.GA4214@inferi.kami.home>
References: <20070619225225.GN5193@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619225225.GN5193@alberich.amd.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc5-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 12:52:25AM +0200, Andreas Herrmann wrote:
> Fix kernel build problem as SONY_LAPTOP depends on ACPI_EC.

The same questions about ACPI_SYSTEM and ACPI_POWER surviving oldconfig
hold here.
See also http://lkml.org/lkml/2007/5/15/168 and following for a previous
report.

In any case, Len if you're going apply such fixes feel free to add my
Acked-By on this one.

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 0d6f369..463fa41 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -119,6 +119,7 @@ config MSI_LAPTOP
>  config SONY_LAPTOP
>  	tristate "Sony Laptop Extras"
>  	depends on X86 && ACPI
> +	select ACPI_EC
>  	select BACKLIGHT_CLASS_DEVICE
>  	  ---help---
>  	  This mini-driver drives the SNC and SPIC devices present in the ACPI
> -- 
> 1.5.0.7
-- 
mattia
:wq!
