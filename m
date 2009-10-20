Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZJTUpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZJTUpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZJTUpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:45:32 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:56671 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZJTUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:45:31 -0400
Message-ID: <4ADE2167.8010700@linux.vnet.ibm.com>
Date: Tue, 20 Oct 2009 18:45:27 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090614)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-bugs@dell.com, akpm@linux-foundation.org
Subject: Re: [PATCH] tpm: autoload tpm_tis based on system PnP IDs
References: <20091020185840.GA19773@mock.linuxdev.us.dell.com>
In-Reply-To: <20091020185840.GA19773@mock.linuxdev.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Matt Domsch wrote:
> The tpm_tis driver already has a list of supported pnp_device_ids.
> This patch simply exports that list as a MODULE_DEVICE_TABLE() so that
> the module autoloader will discover and load the module at boottime.
>
> Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
> ---
>  drivers/char/tpm/tpm_tis.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 0b73e4e..c10ab48 100644
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
>   

