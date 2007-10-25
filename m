Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbXJYPmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbXJYPmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbXJYPmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:42:38 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:36051 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbXJYPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:42:37 -0400
Message-ID: <4720B7C5.1080101@student.ltu.se>
Date: Thu, 25 Oct 2007 17:35:33 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] [libata] fix 'if(' and similar areas that lack whitespace
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234834.76D681F81AC@havoc.gtf.org>
In-Reply-To: <20071024234834.76D681F81AC@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/ata/pata_acpi.c         |    4 +-
>  drivers/ata/pata_optidma.c      |    2 +-
>  drivers/ata/pata_pdc2027x.c     |    2 +-
>  drivers/ata/pata_pdc202xx_old.c |    4 +-
>  drivers/ata/pata_via.c          |    2 +-
>  drivers/ata/pata_winbond.c      |    2 +-
>  drivers/ata/sata_nv.c           |   46 +++++++++++++++++++-------------------
>  drivers/ata/sata_sx4.c          |    4 +-
>  8 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
> index 0f6f7bc..e4542ab 100644
> --- a/drivers/ata/pata_acpi.c
> +++ b/drivers/ata/pata_acpi.c
> @@ -181,7 +181,7 @@ static void pacpi_set_piomode(struct ata_port *ap, struct ata_device *adev)
>  	int unit = adev->devno;
>  	struct pata_acpi *acpi = ap->private_data;
>  
> -	if(!(acpi->gtm.flags & 0x10))
> +	if (!(acpi->gtm.flags & 0x10))
>  		unit = 0;
>  
>  	/* Now stuff the nS values into the structure */
> @@ -202,7 +202,7 @@ static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
>  	int unit = adev->devno;
>  	struct pata_acpi *acpi = ap->private_data;
>  
> -	if(!(acpi->gtm.flags & 0x10))
> +	if (!(acpi->gtm.flags & 0x10))
>  		unit = 0;
>  
>  	/* Now stuff the nS values into the structure */
> diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
> index 6b07b5b..f9b485a 100644
> --- a/drivers/ata/pata_optidma.c
> +++ b/drivers/ata/pata_optidma.c
> @@ -449,7 +449,7 @@ static int optiplus_with_udma(struct pci_dev *pdev)
>  
>  	/* Find function 1 */
>  	dev1 = pci_get_device(0x1045, 0xC701, NULL);
> -	if(dev1 == NULL)
> +	if (dev1 == NULL)
>   
Maybe "if (!dev1)" instead?
>  		return 0;
>  
>  	/* Rev must be >= 0x10 */
>
>   
<snip>
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index 2e0279f..9210bb2 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -1012,7 +1012,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
>  				u32 check_commands;
>  				int pos, error = 0;
>  
> -				if(ata_tag_valid(ap->link.active_tag))
> +				if (ata_tag_valid(ap->link.active_tag))
>  					check_commands = 1 << ap->link.active_tag;
>  				else
>  					check_commands = ap->link.sactive;
> @@ -1028,7 +1028,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
>  		}
>  	}
>  
> -	if(notifier_clears[0] || notifier_clears[1]) {
> +	if (notifier_clears[0] || notifier_clears[1]) {
>  		/* Note: Both notifier clear registers must be written
>  		   if either is set, even if one is zero, according to NVIDIA. */
>  		struct nv_adma_port_priv *pp = host->ports[0]->private_data;
> @@ -1119,7 +1119,7 @@ static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
>  {
>  	struct nv_adma_port_priv *pp = qc->ap->private_data;
>  
> -	if(pp->flags & NV_ADMA_PORT_REGISTER_MODE)
> +	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
>  		ata_bmdma_post_internal_cmd(qc);
>  }
>  
> @@ -1194,10 +1194,10 @@ static int nv_adma_port_start(struct ata_port *ap)
>  
>  	tmp = readw(mmio + NV_ADMA_CTL);
>  	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
> -	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
> +	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
>   
Missed the space before closing parentheses...
>  	udelay(1);
>  	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
> -	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
> +	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
>   
and here
>  
>  	return 0;
>  }
> @@ -1255,10 +1255,10 @@ static int nv_adma_port_resume(struct ata_port *ap)
>  
>  	tmp = readw(mmio + NV_ADMA_CTL);
>  	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
> -	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
> +	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
>   
and here
>  	udelay(1);
>  	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
> -	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
> +	readw(mmio + NV_ADMA_CTL );	/* flush posted write */
>   
and here
>  
>  	return 0;
>  }
>   
The rest looks good.

cu
Richard Knutsson


