Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYIARV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYIARV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYIARVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:21:17 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51593 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYIARVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:21:16 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=cHoHWYv52cc5TlMY89MA:9 a=KcW5GZdjCNpIWlpfzMAA:7 a=dRV60CE9nUMLP-9TeSxai78QUR8A:4
Message-ID: <48BC248E.702@shaw.ca>
Date: Mon, 01 Sep 2008 11:21:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Radu Rendec <radu.rendec@ines.ro>
CC: linux-kernel@vger.kernel.org
Subject: Re: IRQ routing / assignment issue
References: <fa.Ayf504otegg3VVbRsozI1UFd/6Y@ifi.uio.no>
In-Reply-To: <fa.Ayf504otegg3VVbRsozI1UFd/6Y@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radu Rendec wrote:
> Hi,
> 
> I'm trying to make the kernel assign different irqs for two NICs
> connected to _separate_ pci buses. Messing around with pirq= kenrel
> parameter didn't seem to change anything.

The kernel doesn't really have any way to change the physical 
device/slot to IRQ mapping. In some cases there are BIOS settings which 
might influence this, but in most cases it's impossible to change (i.e. 
devices physically wired to the same IRQ line).

> 
> The machine is a smp (dual-xeon). Relevant lspci output is:
> 01:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721
> Gigabit Ethernet PCI Express (rev 11)
> 02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721
> Gigabit Ethernet PCI Express (rev 11)
> 
> IRQ assignment dmesg output is:
> ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> 
> At the moment I'm almost clueless about how irq routing / assignment
> works (either in general or in linux), so any suggestion would help -
> even "rtfm" would be helpful, as long as you specify what is the
> appropriate manual ;)
> 
> If you are so kind to reply, please include my address in cc (I'm not
> subscribed).
> 
> Thanks,
> 
> Radu Rendec
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

