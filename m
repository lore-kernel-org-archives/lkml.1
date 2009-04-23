Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZDWXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZDWXWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZDWXWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:22:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:39775 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZDWXWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:22:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,237,1239001200"; 
   d="scan'208";a="684456475"
Subject: Re: [PATCH] HPET: stop soliciting hpet=force users on ICH4M
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
	 <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
	 <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 16:19:04 -0700
Message-Id: <1240528744.4529.9153.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

On Thu, 2009-04-23 at 16:19 -0700, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> The HPET in the ICH4M is not documented in the data sheet
> because it was not officially validated.
> 
> While it is fine for hackers to continue to use "hpet=force"
> to enable the hardware that they have, it is not prudent to
> solicit additional "hpet=force" users on this hardware.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/kernel/quirks.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index e95022e..7563b31 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -261,8 +261,6 @@ static void old_ich_force_enable_hpet_user(struct pci_dev *dev)
>  {
>  	if (hpet_force_user)
>  		old_ich_force_enable_hpet(dev);
> -	else
> -		hpet_print_force_info();
>  }
>  
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1,

