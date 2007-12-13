Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbXLMWyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbXLMWyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbXLMWyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:54:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:33217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635AbXLMWyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:54:09 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] acpi: fix modpost warnings
Date: Thu, 13 Dec 2007 17:53:51 -0500
User-Agent: KMail/1.9.5
Cc: "linux-acpi" <linux-acpi@intel.com>, linux-kernel@vger.kernel.org
References: <4760FC2A.76E4.0078.0@novell.com>
In-Reply-To: <4760FC2A.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712131753.52044.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Thursday 13 December 2007 03:32, Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
>  drivers/acpi/numa.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.24-rc5/drivers/acpi/numa.c	2007-10-09 22:31:38.000000000 +0200
> +++ 2.6.24-rc5-acpi-init-warning/drivers/acpi/numa.c	2007-12-04 16:09:33.000000000 +0100
> @@ -38,9 +38,9 @@ ACPI_MODULE_NAME("numa");
>  static nodemask_t nodes_found_map = NODE_MASK_NONE;
>  
>  /* maps to convert between proximity domain and logical node ID */
> -static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
> +static int pxm_to_node_map[MAX_PXM_DOMAINS]
>  				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
> -static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
> +static int node_to_pxm_map[MAX_NUMNODES]
>  				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
>  
>  int pxm_to_node(int pxm)
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
