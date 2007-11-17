Return-Path: <linux-kernel-owner+w=401wt.eu-S935348AbXKQCTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348AbXKQCTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 21:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbXKQCTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 21:19:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:58945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbXKQCTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 21:19:09 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] x86_64: remove acpi_pci_link_exit()
Date: Fri, 16 Nov 2007 21:18:34 -0500
User-Agent: KMail/1.9.5
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20071109060313.GS26163@stusta.de>
In-Reply-To: <20071109060313.GS26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711162118.34677.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-len

On Friday 09 November 2007 01:03, Adrian Bunk wrote:
> acpi_pci_link_exit() is both unused and empty.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 16d6853a1facb9bcb7a4bc19daad6d3b852cace3 
> diff --git a/arch/x86/kernel/acpi/sleep_64.c b/arch/x86/kernel/acpi/sleep_64.c
> index 79475d2..da42de2 100644
> --- a/arch/x86/kernel/acpi/sleep_64.c
> +++ b/arch/x86/kernel/acpi/sleep_64.c
> @@ -115,6 +115,3 @@ static int __init acpi_sleep_setup(char *str)
>  
>  __setup("acpi_sleep=", acpi_sleep_setup);
>  
> -void acpi_pci_link_exit(void)
> -{
> -}
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
