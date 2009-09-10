Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZIJT5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZIJT5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZIJT5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:57:06 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:55459 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZIJT5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:57:04 -0400
Subject: Re: [PATCH 2/6] tpm_tis: add MODULE_DEVICE_TABLE to enable autoload
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Andy Isaacson <adi@vmware.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, adi@hexapodia.org, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <1246410255-6839-3-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-3-git-send-email-adi@vmware.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 16:56:56 -0300
Message-Id: <1252612616.4837.110.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

On Tue, 2009-06-30 at 18:04 -0700, Andy Isaacson wrote:
> Signed-off-by: Andy Isaacson <adi@vmware.com>
> ---
>  drivers/char/tpm/tpm_tis.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 1b84441..e859e0e 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -629,6 +629,7 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
>  	{"", 0},		/* User Specified */
>  	{"", 0}			/* Terminator */
>  };
> +MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
> 
>  static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
>  {

