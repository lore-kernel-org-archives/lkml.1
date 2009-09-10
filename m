Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZIJT5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZIJT5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZIJT5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:57:48 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:33503 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZIJT5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:57:47 -0400
Subject: Re: [PATCH 4/6] tpm_tis: print complete vendor information
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Andy Isaacson <adi@vmware.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, adi@hexapodia.org, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <1246410255-6839-5-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-5-git-send-email-adi@vmware.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 16:57:39 -0300
Message-Id: <1252612659.4837.111.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

On Tue, 2009-06-30 at 18:04 -0700, Andy Isaacson wrote:
> The TPM_VID field contains a vendor-id as well as a device-id,
> but the code only prints the device-id.  Fix it.
> 
> Signed-off-by: Andy Isaacson <adi@vmware.com>
> ---
>  drivers/char/tpm/tpm_tis.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index e0bda02..50c2a8a 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -464,7 +464,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> 
>  	dev_info(dev,
> -		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
> +		 "1.2 TPM (%04X:%04X rev %d)\n", vendor & 0xffff,
>  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
> 
>  	/* Figure out the capabilities */

