Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbXCPFdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbXCPFdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 01:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXCPFdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 01:33:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:45329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbXCPFdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 01:33:05 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Norberto Bensa <nbensa@gmx.net>
Subject: Re: core2 duo, interrupts: is this normal?
Date: Fri, 16 Mar 2007 01:31:46 -0400
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <200703152224.54607.nbensa@gmx.net>
In-Reply-To: <200703152224.54607.nbensa@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703160131.46789.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 21:24, Norberto Bensa wrote:
> Hello,
> 
> is this output, normal? I meant, why counters on CPU1 is zero? Isn't this 
> balanced?

yes, it is normal.

If you had an interrupt-limited workload then irqbalance
would pick things up and spread them out.

-Len


> $ cat /proc/interrupts
>            CPU0       CPU1
>   0:    4180170          0   IO-APIC-edge      timer
>   1:       8060          0   IO-APIC-edge      i8042
>   7:          0          0   IO-APIC-edge      parport0
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          5          0   IO-APIC-edge      i8042
>  16:     322297          0   IO-APIC-fasteoi   uhci_hcd:usb3, libata, nvidia, 
> EMU10K1
>  17:     896399          0   IO-APIC-fasteoi   bttv0, eth0, libata
>  18:      72867          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
>  19:      27770          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
>  20:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
>  22:          3          0   IO-APIC-fasteoi   ohci1394
>  23:        155          0   IO-APIC-fasteoi   HDA Intel
> 219:     103056          0   PCI-MSI-edge      libata
> NMI:          0          0
> LOC:    4077613    4077622
> ERR:          0
> MIS:          0
> 
> 
> Many thanks in advance,
> Norberto
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
