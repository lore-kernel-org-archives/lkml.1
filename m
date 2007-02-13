Return-Path: <linux-kernel-owner+w=401wt.eu-S1161025AbXBMFLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025AbXBMFLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161029AbXBMFLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:11:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:39077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161025AbXBMFLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:11:02 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 7/7] cleanup: make disable_acpi() valid w/o CONFIG_ACPI
Date: Tue, 13 Feb 2007 00:09:36 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Len Brown <len.brown@intel.com>
References: <1171251120.10409.2.camel@localhost.localdomain> <1171251471.10409.15.camel@localhost.localdomain> <1171251578.10409.17.camel@localhost.localdomain>
In-Reply-To: <1171251578.10409.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702130009.36987.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Sunday 11 February 2007 22:39, Rusty Russell wrote:
> Len Brown <lenb@kernel.org> said:
> > Okay, but better to use disable_acpi()
> > indeed, since this would be the first code not already inside CONFIG_ACPI
> > to invoke disable_acpi(), we could define the inline as empty and you could
> > then scratch the #ifdef too.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> ===================================================================
> --- a/include/asm-i386/acpi.h
> +++ b/include/asm-i386/acpi.h
> @@ -127,6 +127,7 @@ extern int acpi_irq_balance_set(char *st
>  #define acpi_ioapic 0
>  static inline void acpi_noirq_set(void) { }
>  static inline void acpi_disable_pci(void) { }
> +static inline void disable_acpi(void) { }
>  
>  #endif	/* !CONFIG_ACPI */
>  
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
