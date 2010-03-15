Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab0COBwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:52:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:9776 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab0COBwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:52:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,640,1262592000"; 
   d="scan'208";a="254601665"
Subject: Re: [PATCH v2 2/3] ipmi: Convert tracking of the ACPI device
	pointer to a	PNP device
From: ykzhao <yakui.zhao@intel.com>
To: Myron Stowe <myron.stowe@hp.com>
Cc: "minyard@acm.org" <minyard@acm.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>
In-Reply-To: <20100313181347.20614.7897.stgit@bob.kio>
References: <20100313180121.20614.92547.stgit@bob.kio>
	 <20100313181347.20614.7897.stgit@bob.kio>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Mon, 15 Mar 2010 09:50:34 +0800
Message-Id: <1268617834.3617.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 02:13 +0800, Myron Stowe wrote:
> Convert PNP patch (git 9e368fa011d4e0aa050db348d69514900520e40b) to
> maintain a pointer to a PNP device, 'pnp_dev', instead of the ACPI
> device, 'acpi_dev', that is currently being tracked with PNP based
> IPMI device discovery.
> 
> Signed-off-by: Myron Stowe <myron.stowe@hp.com>
> Cc: Zhao Yakui <yakui.zhao@intel.com>

Acked-by: Zhao Yakui <yakui.zhao@intel.com>
> ---
> 
>  drivers/char/ipmi/ipmi_si_intf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 86a7dd7..0e31aa9 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2093,7 +2093,7 @@ static int __devinit ipmi_pnp_probe(struct pnp_dev *dev,
>  		info->irq_setup = std_irq_setup;
>  	}
>  
> -	info->dev = &acpi_dev->dev;
> +	info->dev = &dev->dev;
>  	pnp_set_drvdata(dev, info);
>  
>  	return try_smi_init(info);
> 

