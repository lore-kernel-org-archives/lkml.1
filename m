Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbYBOUad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbYBOUad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYBOUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:30:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:55777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbYBOUaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:30:25 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 5/8] kernel-doc: fix pci-acpi warning
Date: Fri, 15 Feb 2008 15:30:06 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0802031444390.3021@shark.he.net>
In-Reply-To: <Pine.LNX.4.64.0802031444390.3021@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802151530.07124.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-Len

On Sunday 03 February 2008 18:06, Randy.Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix PCI kernel-doc warning:
> Warning(linux-2.6.24-git12//drivers/pci/pci-acpi.c:166): No description found for parameter 'hid'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>   drivers/pci/pci-acpi.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- linux-2.6.24-git12.orig/drivers/pci/pci-acpi.c
> +++ linux-2.6.24-git12/drivers/pci/pci-acpi.c
> @@ -158,6 +158,7 @@ run_osc_out:
>   /**
>    * __pci_osc_support_set - register OS support to Firmware
>    * @flags: OS support bits
> + * @hid: hardware ID
>    *
>    * Update OS support fields and doing a _OSC Query to obtain an update
>    * from Firmware on supported control bits.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
