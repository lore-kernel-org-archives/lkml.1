Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZIJT4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZIJT4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZIJT4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:56:24 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:40287 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZIJT4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:56:23 -0400
Subject: Re: [PATCH 1/6] tpm_tis: various cleanups
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Andy Isaacson <adi@vmware.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, adi@hexapodia.org, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <1246410255-6839-2-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-2-git-send-email-adi@vmware.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 16:56:15 -0300
Message-Id: <1252612575.4837.109.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

On Tue, 2009-06-30 at 18:04 -0700, Andy Isaacson wrote:
> Avoid tabs in printk output.
> Use parentheses and ARRAY_SIZE() in macro definition.
> 
> Signed-off-by: Andy Isaacson <adi@vmware.com>
> ---
>  drivers/char/tpm/tpm_tis.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 717af7a..1b84441 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -474,23 +474,23 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
>  		intfcaps);
>  	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
> -		dev_dbg(dev, "\tBurst Count Static\n");
> +		dev_dbg(dev, "    Burst Count Static\n");
>  	if (intfcaps & TPM_INTF_CMD_READY_INT)
> -		dev_dbg(dev, "\tCommand Ready Int Support\n");
> +		dev_dbg(dev, "    Command Ready Int Support\n");
>  	if (intfcaps & TPM_INTF_INT_EDGE_FALLING)
> -		dev_dbg(dev, "\tInterrupt Edge Falling\n");
> +		dev_dbg(dev, "    Interrupt Edge Falling\n");
>  	if (intfcaps & TPM_INTF_INT_EDGE_RISING)
> -		dev_dbg(dev, "\tInterrupt Edge Rising\n");
> +		dev_dbg(dev, "    Interrupt Edge Rising\n");
>  	if (intfcaps & TPM_INTF_INT_LEVEL_LOW)
> -		dev_dbg(dev, "\tInterrupt Level Low\n");
> +		dev_dbg(dev, "    Interrupt Level Low\n");
>  	if (intfcaps & TPM_INTF_INT_LEVEL_HIGH)
> -		dev_dbg(dev, "\tInterrupt Level High\n");
> +		dev_dbg(dev, "    Interrupt Level High\n");
>  	if (intfcaps & TPM_INTF_LOCALITY_CHANGE_INT)
> -		dev_dbg(dev, "\tLocality Change Int Support\n");
> +		dev_dbg(dev, "    Locality Change Int Support\n");
>  	if (intfcaps & TPM_INTF_STS_VALID_INT)
> -		dev_dbg(dev, "\tSts Valid Int Support\n");
> +		dev_dbg(dev, "    Sts Valid Int Support\n");
>  	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
> -		dev_dbg(dev, "\tData Avail Int Support\n");
> +		dev_dbg(dev, "    Data Avail Int Support\n");
> 
>  	/* INTERRUPT Setup */
>  	init_waitqueue_head(&chip->vendor.read_queue);
> @@ -649,7 +649,7 @@ static struct pnp_driver tis_pnp_driver = {
>  	.remove = tpm_tis_pnp_remove,
>  };
> 
> -#define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
> +#define TIS_HID_USR_IDX (ARRAY_SIZE(tpm_pnp_tbl) - 2)
>  module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
>  		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
>  MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");

