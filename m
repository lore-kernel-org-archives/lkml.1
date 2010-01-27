Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808Ab0A0Rbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0A0Rbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726Ab0A0Rbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:31:33 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:55737 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755597Ab0A0Rbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:31:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Mh+Fm6/TZ+AwUHbCrYj/eCK6c6I6labPmX/K+kEkB79enPsJWoOkcTBdAEtFDO4CCdfYkoJZT0Z6GAp9w9ScfcB4Jan2j3tgwzxPCFIvhOeIdtTtBVXy/H8E6/tOtRlU;
Date: Wed, 27 Jan 2010 09:31:13 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: pci tree build failure
Message-ID: <20100127093113.70203e4d@jbarnes-piketon>
In-Reply-To: <20100127174900.e2f8fcf9.sfr@canb.auug.org.au>
References: <20100127174900.e2f8fcf9.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 17:49:00 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> In file included from drivers/pci/pcie/pme/pcie_pme.c:22:
> include/linux/pci-acpi.h:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'acpi_find_root_bridge_handle'
> 
> You seem to have lost the patch below which I have reapplied for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 18 Jan 2010 19:36:11 +1100
> Subject: [PATCH] pci: PCIE_PME seems to depend on ACPI
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/pci/pcie/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
> index cf3c35f..b8b494b 100644
> --- a/drivers/pci/pcie/Kconfig
> +++ b/drivers/pci/pcie/Kconfig
> @@ -49,4 +49,4 @@ config PCIEASPM_DEBUG
>  
>  config PCIE_PME
>  	def_bool y
> -	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL
> +	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL && ACPI

Sorry about that.  Sometimes I point git in the wrong direction and it
takes of a limb or two.  Should be fixed now.

-- 
Jesse Barnes, Intel Open Source Technology Center
