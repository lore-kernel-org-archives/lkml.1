Return-Path: <linux-kernel-owner+w=401wt.eu-S932256AbXGKLmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbXGKLmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761245AbXGKLlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:41:52 -0400
Received: from aun.it.uu.se ([130.238.12.36]:58002 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762105AbXGKLlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:41:51 -0400
Date: Wed, 11 Jul 2007 13:41:47 +0200 (MEST)
Message-Id: <200707111141.l6BBfllO003981@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: amaury.deganseman@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 libata problem: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 12:10:06 +0200, Amaury De Ganseman wrote:
> I see this message in dmesg(full dmesg in attach):
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd ec/00:00:00:00:00/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
>          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA

Your dmesg.txt shows that your kernel is tainted by some nvidia binary crap:

<all fine to this point>
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 24 (level, low) -> IRQ 24
PCI: Setting latency timer of device 0000:02:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13 16:33:22 PDT 2007
<some reiserfs messages>
eth0:  setting full-duplex.
usb 2-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 2 ret -110
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ec/00:00:00:00:00/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)

Ask nvidia. We don't care as long as you load that nvidia module.
