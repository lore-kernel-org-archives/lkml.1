Return-Path: <linux-kernel-owner+w=401wt.eu-S965376AbXCLNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbXCLNZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965411AbXCLNZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:25:31 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:42431 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376AbXCLNZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f2YfGUEeATPeTIrdBV+q0O1xHLEAT/U2MCGYwnOmmXh1S3U5abXtZ+Es5G3iQG4Xmo4P1PlcZ2B2B0Pq3rxuwhBKUnJgN+FLuea5polpI1PpFYfpsJ2Ur6cRIxdk2dcEWYrQSidcnIFfM0NugT8bIGD/vybADBSlcDm4gIqfN3k=
Message-ID: <3877989d0703120625w4afbf197qa30b62bac3cdfcf5@mail.gmail.com>
Date: Mon, 12 Mar 2007 21:25:29 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: 2.6.21-rc3-mm2 hangs my opteron during bootup, ACPI?
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <45F54E04.40302@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070307201915.4d579113.akpm@linux-foundation.org>
	 <45F54E04.40302@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

try acpi=off please.

On 3/12/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> I went from 2.6.18-rc5-mm1 to 2.6.21-rc3-mm2
> The computer now hangs solid during boot, at this point:
>
> usb 1-1: configuration #1 chosen from 1 choice
> drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0
> alt 0 proto 2 vid 0x04B8 pid 0x0007
> usb 1-3: new high speed USB device using ehci_hcd and address 3
> pc87360: PC8736x not detected, module not inserted.
> md: raid1 personality registered for level 1
> md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
> md: bitmap version 4.39
> EDAC MC: Ver: 2.0.1 Sep  2 2006
> sdhci: Secure Digital Host Controller Interface driver, 0.12
> sdhci: Copyright(c) Pierre Ossman
> wbsd: Winbond W83L51xD SD/MMC card interface driver, 1.6
> wbsd: Copyright(c) Pierre Ossman
> Advanced Linux Sound Architecture Driver Version 1.0.12rc1 (Thu Jun 22
> 13:55:50 2006 UTC).
> ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 17
>
>
> Here it stops with a dead keyboard.  No sysrq, it is time for the power
> button.
> A 2.6.18-rc5-mm1 boot continues like this:
>
> gameport: Trident 4DWave is pci0000:00:06.0/gameport0, speed 1884kHz
> ALSA device list:
>   #0: Trident TRID4DWAVENX PCI Audio at 0x9400, irq 17
> oprofile: using NMI interrupt.
> Netfilter messages via NETLINK v0.30.
> IPv4 over IPv4 tunneling driver
> GRE over IPv4 tunneling driver
> ip_conntrack version 2.4 (2043 buckets, 16344 max) - 288 bytes per conntrack
> ip_tables: (C) 2000-2006 Netfilter Core Team
> joydump: ,------------------ START ----------------.
>
>
> I'll be trying 2.6.20 next, unless adviced otherwise.
>
> Helge Hafting
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
