Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZFYFhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZFYFhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZFYFhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:37:05 -0400
Received: from waste.org ([66.93.16.53]:52437 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZFYFhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:37:04 -0400
Subject: Re: [PATCH 04/19] drivers/char/hw_random: Use PCI_VDEVICE
From: Matt Mackall <mpm@selenic.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <6498b0c571fd010583c911cabc346c26ce8f25a7.1245906152.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
	 <6498b0c571fd010583c911cabc346c26ce8f25a7.1245906152.git.joe@perches.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 00:36:18 -0500
Message-Id: <1245908178.21085.303.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 22:13 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/char/hw_random/amd-rng.c   |    4 ++--
>  drivers/char/hw_random/geode-rng.c |    3 +--
>  2 files changed, 3 insertions(+), 4 deletions(-)

Acked-by: Matt Mackall <mpm@selenic.com>

> diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
> index cd0ba51..0d8c578 100644
> --- a/drivers/char/hw_random/amd-rng.c
> +++ b/drivers/char/hw_random/amd-rng.c
> @@ -44,8 +44,8 @@
>   * want to register another driver on the same PCI id.
>   */
>  static const struct pci_device_id pci_tbl[] = {
> -	{ 0x1022, 0x7443, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
> -	{ 0x1022, 0x746b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
> +	{ PCI_VDEVICE(AMD, 0x7443), 0, },
> +	{ PCI_VDEVICE(AMD, 0x746b), 0, },
>  	{ 0, },	/* terminate list */
>  };
>  MODULE_DEVICE_TABLE(pci, pci_tbl);
> diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
> index 64d513f..4c4d4e1 100644
> --- a/drivers/char/hw_random/geode-rng.c
> +++ b/drivers/char/hw_random/geode-rng.c
> @@ -46,8 +46,7 @@
>   * want to register another driver on the same PCI id.
>   */
>  static const struct pci_device_id pci_tbl[] = {
> -	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES), 0, },
>  	{ 0, },	/* terminate list */
>  };
>  MODULE_DEVICE_TABLE(pci, pci_tbl);

-- 
http://selenic.com : development and support for Mercurial and Linux


