Return-Path: <linux-kernel-owner+w=401wt.eu-S1764322AbXJSFWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764322AbXJSFWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXJSFWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:22:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60890 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbXJSFWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:22:30 -0400
Date: Thu, 18 Oct 2007 22:20:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make advansys depend on CONFIG_VIRT_TO_BUS
Message-Id: <20071018222017.514df7b9.randy.dunlap@oracle.com>
In-Reply-To: <20071019150431.996522c5.sfr@canb.auug.org.au>
References: <20071019150431.996522c5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 15:04:31 +1000 Stephen Rothwell wrote:

> At least for now.

Please explain "why" in the changelog (what changelog?).

E.g.:
so that make allmodconfig on powerpc will have a better chance
of building.

or whatever.

> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/scsi/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 30905ce..325533c 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -523,6 +523,7 @@ config SCSI_ADVANSYS
>  	tristate "AdvanSys SCSI support"
>  	depends on SCSI
>  	depends on ISA || EISA || PCI
> +	depends on VIRT_TO_BUS
>  	help
>  	  This is a driver for all SCSI host adapters manufactured by
>  	  AdvanSys. It is documented in the kernel source in


---
~Randy
