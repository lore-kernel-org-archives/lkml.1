Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZEMOIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZEMOIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZEMOIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:08:38 -0400
Received: from main.gmane.org ([80.91.229.2]:46346 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbZEMOIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:08:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: timer interrupt handled by CPU0 only
Date: Wed, 13 May 2009 14:25:28 +0100
Message-ID: <8buqd6-bab.ln1@woodchuck.wormnet.eu>
References: <200905131927152180665@gmail.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-1-sparc64 (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qmh524 <qmh524@gmail.com> wrote:
>
> I have start irqbalance service. Why the timer interrupt only happend in CPU0
>
irqBALANCE...you could also ask why all your eth0 IRQ's are on CPU3 or 
your ATA action is on CPU2.

It's my understanding you *steer* IRQ's to a CPU, you do not round-robin 
them across all the CPU's.

Cheers

> $ sudo service irqbalance status
> irqbalance (pid 2390) is running...
> $ cat /proc/interrupts
>           CPU0       CPU1       CPU2       CPU3
>  0:   21487296          0          0          0    IO-APIC-edge  timer
>  1:          3          0          0          0    IO-APIC-edge  i8042
>  8:          1          0          0          0    IO-APIC-edge  rtc
>  9:          0          0          0          0   IO-APIC-level  acpi
> 12:          4          0          0          0    IO-APIC-edge  i8042
> 74:         18          0          0          0   IO-APIC-level
> uhci_hcd:usb1, uhci_hcd:usb3, ehci_hcd:usb4
> 82:          0          0          0          0   IO-APIC-level  uhci_hcd:usb2
> 90:       1934          0   45886283          0   IO-APIC-level  libata
> 98:          0          0          0          0   IO-APIC-level  libata
> 106:        120          0          0   22824923         PCI-MSI  eth0
> 169:      16933          0    9370507          0   IO-APIC-level  ioc0
> NMI:      43241      26776      33934      29946
> LOC:   21487192   21487118   21487046   21486887
> ERR:          0
> MIS:          0

-- 
Alexander Clouter
.sigmonster says: A hammer sometimes misses its mark - a bouquet never.

