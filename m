Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbXINRgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbXINRgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXINRgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:36:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbXINRgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:36:09 -0400
Message-ID: <46EAC653.3010603@redhat.com>
Date: Fri, 14 Sep 2007 13:35:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Lossy interrupts on x86_64
References: <200709120833.15980.jbarnes@virtuousgeek.org> <20070912090151.97c9a78e.randy.dunlap@oracle.com> <200709120929.52217.jbarnes@virtuousgeek.org>
In-Reply-To: <200709120929.52217.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2007 12:29 PM, Jesse Barnes wrote:
> 
> [jbarnes@jbarnes-t61 ~]$ cat /proc/interrupts
>            CPU0       CPU1
>   0:     290050     289541   IO-APIC-edge      timer
>   1:       3862       3956   IO-APIC-edge      i8042
>   8:          0          0   IO-APIC-edge      rtc0
>   9:       1632       1643   IO-APIC-fasteoi   acpi
>  12:     183662     183926   IO-APIC-edge      i8042
>  14:      20626      20717   IO-APIC-edge      libata
>  15:          0          0   IO-APIC-edge      libata
>  16:      46812      46825   IO-APIC-fasteoi   yenta, uhci_hcd:usb3, i915@pci:0000:00:02.0
>  17:      63715      63653   IO-APIC-fasteoi   uhci_hcd:usb4, HDA Intel, firewire_ohci, iwl4965
>  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
>  19:         52         36   IO-APIC-fasteoi   ehci_hcd:usb7
>  20:         43         46   IO-APIC-fasteoi   uhci_hcd:usb1
>  21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
>  22:          2          1   IO-APIC-fasteoi   ehci_hcd:usb6
> 2297:        937        944   PCI-MSI-edge      eth0
> 2298:      12392      12402   PCI-MSI-edge      ahci
> NMI:          0          0
> LOC:     290913     335027
> ERR:          0
> 

Hmm, is there any way to force those "fasteoi" handlers to "level"
instead?
