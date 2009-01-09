Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZAIUNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZAIUNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZAIUNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:13:22 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:20172 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbZAIUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:13:21 -0500
Date: Fri, 9 Jan 2009 12:12:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 01/16] dma-debug: add Kconfig entry
Message-Id: <20090109121225.a0b4bbee.randy.dunlap@oracle.com>
In-Reply-To: <1231517970-20288-2-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
	<1231517970-20288-2-git-send-email-joerg.roedel@amd.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4967AFB5.011E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 17:19:15 +0100 Joerg Roedel wrote:

> Impact: add a Kconfig entry for DMA-API debugging

Surely Impact: is (meant to be) different from the actual patch description... ?


> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/Kconfig      |    2 ++
>  lib/Kconfig.debug |   11 +++++++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 2e13aa2..068554c 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -103,3 +103,5 @@ config HAVE_CLK
>  	  The <linux/clk.h> calls support software clock gating and
>  	  thus are a key power management tool on many systems.
>  
> +config HAVE_DMA_API_DEBUG
> +	bool
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 2e75478..cba5778 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -899,6 +899,17 @@ config DYNAMIC_PRINTK_DEBUG
>  	  debugging for all modules. This mode can be turned off via the above
>  	  disable command.
>  
> +config DMA_API_DEBUG
> +	bool "Enable debugging of DMA-API usage"
> +	depends on HAVE_DMA_API_DEBUG
> +	help
> +	  Enable this option to debug the use of the DMA API by device drivers.
> +	  With this option you will be able to detect common bugs in device
> +	  drivers like double-freeing of DMA mappings or freeing mappings that
> +	  were never allocated.
> +	  This option causes a performance degredation.  Use only if you want
> +	  to debug device drivers. If unsure, say N.
> +
>  source "samples/Kconfig"
>  
>  source "lib/Kconfig.kgdb"
> -- 

---
~Randy
