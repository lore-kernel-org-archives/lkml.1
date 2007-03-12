Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbXCLT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbXCLT5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXCLT5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:57:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54005 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbXCLT5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:57:31 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: 2.6.21-rc3-mm2 hangs my opteron during bootup, ACPI?
Date: Mon, 12 Mar 2007 15:56:03 -0400
User-Agent: KMail/1.9.5
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <45F54E04.40302@aitel.hist.no> <3877989d0703120625w4afbf197qa30b62bac3cdfcf5@mail.gmail.com>
In-Reply-To: <3877989d0703120625w4afbf197qa30b62bac3cdfcf5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121556.03845.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 09:25, Luming Yu wrote:
> try acpi=off please.
> 
> On 3/12/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> > I went from 2.6.18-rc5-mm1 to 2.6.21-rc3-mm2
> > The computer now hangs solid during boot, at this point:
> >
> > usb 1-1: configuration #1 chosen from 1 choice
> > drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0
> > alt 0 proto 2 vid 0x04B8 pid 0x0007
> > usb 1-3: new high speed USB device using ehci_hcd and address 3
> > pc87360: PC8736x not detected, module not inserted.
> > md: raid1 personality registered for level 1
> > md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
> > md: bitmap version 4.39
> > EDAC MC: Ver: 2.0.1 Sep  2 2006
> > sdhci: Secure Digital Host Controller Interface driver, 0.12
> > sdhci: Copyright(c) Pierre Ossman
> > wbsd: Winbond W83L51xD SD/MMC card interface driver, 1.6
> > wbsd: Copyright(c) Pierre Ossman
> > Advanced Linux Sound Architecture Driver Version 1.0.12rc1 (Thu Jun 22
> > 13:55:50 2006 UTC).
> > ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 17
> >
> >
> > Here it stops with a dead keyboard.  No sysrq, it is time for the power
> > button.
> > A 2.6.18-rc5-mm1 boot continues like this:
> >
> > gameport: Trident 4DWave is pci0000:00:06.0/gameport0, speed 1884kHz
> > ALSA device list:
> >   #0: Trident TRID4DWAVENX PCI Audio at 0x9400, irq 17
> > oprofile: using NMI interrupt.
> > Netfilter messages via NETLINK v0.30.
> > IPv4 over IPv4 tunneling driver
> > GRE over IPv4 tunneling driver
> > ip_conntrack version 2.4 (2043 buckets, 16344 max) - 288 bytes per conntrack
> > ip_tables: (C) 2000-2006 Netfilter Core Team
> > joydump: ,------------------ START ----------------.
> >
> >
> > I'll be trying 2.6.20 next, unless adviced otherwise.

yes, that would be a good baseline.

But how about the latest git tree w/o anything from -mm.
eg. 2.6.21-rc3-git7

thanks,
-Len

