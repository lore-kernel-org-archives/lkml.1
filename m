Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZLCQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZLCQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZLCQ1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:27:23 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:24530 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZLCQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:27:22 -0500
Subject: Re: [PATCH 2/2 v2] pci: change PCI nomenclature in drivers/pci/
 (non-comment changes)
From: Andrew Patterson <andrew.patterson@hp.com>
To: Stefan Assmann <sassmann@redhat.com>
Cc: linux-pci@vger.kernel.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, rjw@sisk.pl, ddutile@redhat.com,
       kaneshige.kenji@jp.fujitsu.com, khc@pm.waw.pl
In-Reply-To: <20091203114932.24905.78292.sendpatchset@localhost.localdomain>
References: <20091203114914.24905.67372.sendpatchset@localhost.localdomain>
	 <20091203114932.24905.78292.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 09:27:22 -0700
Message-ID: <1259857642.2684.64.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 06:49 -0500, Stefan Assmann wrote:
> From: Stefan Assmann <sassmann@redhat.com>
> 
> Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
> terms listed in the "Trademark and Logo Usage Guidelines".
> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
> 
> Patch is limited to drivers/pci/ and changes concern non-comment parts or
> anything that might be visible to the user.
> 
> Signed-off-by: Stefan Assmann <sassmann@redhat.com>
> ---
>  drivers/pci/hotplug/pci_hotplug_core.c |   22 +++++++++++-----------
>  drivers/pci/pcie/aer/Kconfig.debug     |    4 ++--
>  drivers/pci/pcie/aer/aer_inject.c      |    2 +-
>  drivers/pci/pcie/aer/aerdrv_errprint.c |    4 ++--
>  drivers/pci/pcie/portdrv_pci.c         |    2 +-
>  5 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
> index 0325d98..38183a5 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -68,26 +68,26 @@ static DEFINE_MUTEX(pci_hp_mutex);
>  static char *pci_bus_speed_strings[] = {
>  	"33 MHz PCI",		/* 0x00 */
>  	"66 MHz PCI",		/* 0x01 */
> -	"66 MHz PCIX", 		/* 0x02 */
> -	"100 MHz PCIX",		/* 0x03 */
> -	"133 MHz PCIX",		/* 0x04 */
> +	"66 MHz PCI-X",		/* 0x02 */
> +	"100 MHz PCI-X",	/* 0x03 */
> +	"133 MHz PCI-X",	/* 0x04 */
>  	NULL,			/* 0x05 */
>  	NULL,			/* 0x06 */
>  	NULL,			/* 0x07 */
>  	NULL,			/* 0x08 */
> -	"66 MHz PCIX 266",	/* 0x09 */
> -	"100 MHz PCIX 266",	/* 0x0a */
> -	"133 MHz PCIX 266",	/* 0x0b */
> +	"66 MHz PCI-X 266",	/* 0x09 */
> +	"100 MHz PCI-X 266",	/* 0x0a */
> +	"133 MHz PCI-X 266",	/* 0x0b */
>  	NULL,			/* 0x0c */
>  	NULL,			/* 0x0d */
>  	NULL,			/* 0x0e */
>  	NULL,			/* 0x0f */
>  	NULL,			/* 0x10 */
> -	"66 MHz PCIX 533",	/* 0x11 */
> -	"100 MHz PCIX 533",	/* 0x12 */
> -	"133 MHz PCIX 533",	/* 0x13 */
> -	"2.5 GT/s PCI-E",	/* 0x14 */
> -	"5.0 GT/s PCI-E",	/* 0x15 */
> +	"66 MHz PCI-X 533",	/* 0x11 */
> +	"100 MHz PCI-X 533",	/* 0x12 */
> +	"133 MHz PCI-X 533",	/* 0x13 */
> +	"2.5 GT/s PCIe",	/* 0x14 */
> +	"5.0 GT/s PCIe",	/* 0x15 */
>  };
>  
>  #ifdef CONFIG_HOTPLUG_PCI_CPCI
> diff --git a/drivers/pci/pcie/aer/Kconfig.debug b/drivers/pci/pcie/aer/Kconfig.debug
> index b8c925c..edfe756 100644
> --- a/drivers/pci/pcie/aer/Kconfig.debug
> +++ b/drivers/pci/pcie/aer/Kconfig.debug
> @@ -3,14 +3,14 @@
>  #
>  
>  config PCIEAER_INJECT
> -	tristate "PCIE AER error injector support"
> +	tristate "PCIe AER error injector support"
>  	depends on PCIEAER
>  	default n
>  	help
>  	  This enables PCI Express Root Port Advanced Error Reporting
>  	  (AER) software error injector.
>  
> -	  Debuging PCIE AER code is quite difficult because it is hard
> +	  Debuging PCIe AER code is quite difficult because it is hard

Why not fix the typo while changing this line.  "Debuging" shoud be
"Debugging".

>  	  to trigger various real hardware errors. Software based
>  	  error injection can fake almost all kinds of errors with the
>  	  help of a user space helper tool aer-inject, which can be
> diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
> index a21dee3..8e056f2 100644
> --- a/drivers/pci/pcie/aer/aer_inject.c
> +++ b/drivers/pci/pcie/aer/aer_inject.c
> @@ -462,5 +462,5 @@ static void __exit aer_inject_exit(void)
>  module_init(aer_inject_init);
>  module_exit(aer_inject_exit);
>  
> -MODULE_DESCRIPTION("PCIE AER software error injector");
> +MODULE_DESCRIPTION("PCIe AER software error injector");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 44acde7..9d3e4c8 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -184,7 +184,7 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>  
>  	if (info->status == 0) {
>  		AER_PR(info, dev,
> -			"PCIE Bus Error: severity=%s, type=Unaccessible, "
> +			"PCIe Bus Error: severity=%s, type=Unaccessible, "
>  			"id=%04x(Unregistered Agent ID)\n",
>  			aer_error_severity_string[info->severity], id);
>  	} else {
> @@ -194,7 +194,7 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>  		agent = AER_GET_AGENT(info->severity, info->status);
>  
>  		AER_PR(info, dev,
> -			"PCIE Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
> +			"PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
>  			aer_error_severity_string[info->severity],
>  			aer_error_layer[layer], id, aer_agent_string[agent]);
>  
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index f635e47..6788d0f 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -24,7 +24,7 @@
>   */
>  #define DRIVER_VERSION "v1.0"
>  #define DRIVER_AUTHOR "tom.l.nguyen@intel.com"
> -#define DRIVER_DESC "PCIE Port Bus Driver"
> +#define DRIVER_DESC "PCIe Port Bus Driver"
>  MODULE_AUTHOR(DRIVER_AUTHOR);
>  MODULE_DESCRIPTION(DRIVER_DESC);
>  MODULE_LICENSE("GPL");


-- 
Andrew Patterson
Hewlett-Packard

