Return-Path: <linux-kernel-owner+w=401wt.eu-S1761568AbXKPQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568AbXKPQ5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXKPQ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:57:29 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:59536 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbXKPQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:57:28 -0500
Message-ID: <473DCAE0.9040401@keyaccess.nl>
Date: Fri, 16 Nov 2007 17:52:48 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Zhao Yakui <yakui.zhao@intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       shaohua.li@intel.com, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH]: PNP: Increase the value of PNP constant
References: <1195198798.2460.18.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1195198798.2460.18.camel@yakui_zhao.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-11-07 08:39, Zhao Yakui wrote:

> Subject: PNP: Increase the value of PNP constant
> From: Zhao Yakui  <yakui.zhao@intel.com>
> 
> On some systems the number of resources(IO,MEM) returnedy by PNP
> device is greater than the PNP constant, for example motherboard devices. 
> It brings that some resources can't be reserved and resource confilicts.
> This will cause PCI resources are assigned wrongly in some systems, and
> cause hang. This is a regression since we deleted ACPI motherboard
> driver and use PNP system driver.
> 
> Andrew, I thought this is an urgent issue and should be fixed ASAP, and
> this is a good candidate for -stable tree
> 
> Signed-off-by: Li Shaohua <shaohua.li@intel.com>
> Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
> 
> ---
>  drivers/pnp/pnpacpi/rsparser.c |   18 ++++++++++++++++--
>  include/linux/pnp.h            |    4 ++--
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.24-rc2/include/linux/pnp.h
> ===================================================================
> --- linux-2.6.24-rc2.orig/include/linux/pnp.h
> +++ linux-2.6.24-rc2/include/linux/pnp.h
> @@ -13,8 +13,8 @@
>  #include <linux/errno.h>
>  #include <linux/mod_devicetable.h>
>  
> -#define PNP_MAX_PORT		8
> -#define PNP_MAX_MEM		4
> +#define PNP_MAX_PORT		24
> +#define PNP_MAX_MEM		12

This fairly significantly grows (for example?) a struct pnp_resource_table. 
Are 24 and 12 really sensible?

Rene.
