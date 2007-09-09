Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbXIIMXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbXIIMXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 08:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXIIMWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 08:22:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35629 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbXIIMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 08:22:54 -0400
Date: Sun, 9 Sep 2007 13:22:52 +0100
To: jirislaby@gmail.com, jeff@garzik.org, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1
Message-ID: <20070909122251.GA31986@skynet.ie>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(To list based on CC's in net-add-ath5k-wireless-driver-fix.patch . If
that is in error, apologies)

On (31/08/07 21:58), Andrew Morton didst pronounce:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
> 

I thought I would give the ath5k driver a shot on my Thinkpad T60p to see
what happened but it wasn't particularly successful. lspci -v shows

03:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
        Subsystem: IBM ThinkPad 11a/b/g Wireless LAN Mini Express Adapter (AR5BXB6)
        Flags: bus master, fast devsel, latency 0, IRQ 22
        Memory at edf00000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
        Capabilities: [60] Express Legacy Endpoint IRQ 0
        Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel

During boot, the following relevant information in dmesg shows up;

ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:03:00.0 to 64
Uhhuh. NMI received for unknown reason b1 on CPU 0.
You have some hardware problem, likely on the PCI bus.
Dazed and confused, but trying to continue
ath5k_hw_nic_wakeup: failed to resume the MAC Chip
ACPI: PCI interrupt for device 0000:03:00.0 disabled
ath_pci: probe of 0000:03:00.0 failed with error -5

Needless to say, it fails to bring up networking later. I have no real idea
how to debug something like this. Any suggestions?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
