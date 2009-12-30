Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbZL3TJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbZL3TJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZL3TJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:09:23 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:52576 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZL3TJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:09:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SAjiCa5u7pCa0f7TTa1hREzJ4XhX/bCMaz63TJb0n0vD52jpQ5hj+txzxxpwkq1JnT
         niBonBlDXiA5Ot+JOajiLKCDWXWCV8b6AmVWlxrm7y2Avr3DWoSWqGpPVQihp5uCY4kF
         BinZigxKwf8ufUB+VPwBsZs7cqJ9gwBNGGeVw=
Message-ID: <4B3BA9D9.10102@gmail.com>
Date: Wed, 30 Dec 2009 13:28:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Disabling IRQ #20 problem with JMicron SATA-PATA Controller
References: <4B3B177E.60103@pardus.org.tr>
In-Reply-To: <4B3B177E.60103@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 03:03 AM, Ozan Çağlayan wrote:
> Hi,
>
>
> I have a new box with Asus P6T-SE board and Intel i7-920 nehalem cpu. The board has a JMicron® JMB363 PATA and SATA controller. When the controller is enabled and set to AHCI mode in BIOS, the system slows down dramatically after disabling IRQ #20.
>
> I'm using 2.6.30.9.
>
> I'm posting full dmesg, thanks:
>
> Dec 28 11:32:07 redd kernel: [   56.833649] ahci 0000:00:1f.2: version 3.0
> Dec 28 11:32:07 redd kernel: [   56.833658] ahci 0000:00:1f.2: PCI INT B ->  GSI 20 (level, low) ->  IRQ 20
> Dec 28 11:32:07 redd kernel: [   56.833691] ahci: SSS flag set, parallel bus scan disabled
> Dec 28 11:32:07 redd kernel: [   56.833728] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
> Dec 28 11:32:07 redd kernel: [   56.833730] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems
> Dec 28 11:32:07 redd kernel: [   56.833734] ahci 0000:00:1f.2: setting latency timer to 64
> Dec 28 11:32:07 redd kernel: [   56.839192] scsi0 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839263] scsi1 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839310] scsi2 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839353] scsi3 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839396] scsi4 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839447] scsi5 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839583] ata1: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc100 irq 20
> Dec 28 11:32:07 redd kernel: [   56.839586] ata2: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc180 irq 20
> Dec 28 11:32:07 redd kernel: [   56.839590] ata3: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc200 irq 20
> Dec 28 11:32:07 redd kernel: [   56.839593] ata4: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc280 irq 20
> Dec 28 11:32:07 redd kernel: [   56.839596] ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 20
> Dec 28 11:32:07 redd kernel: [   56.839600] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 20
> Dec 28 11:32:07 redd kernel: [   56.839623] ahci 0000:04:00.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
> Dec 28 11:32:07 redd kernel: [   56.839717] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
> Dec 28 11:32:07 redd kernel: [   56.839721] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part
> Dec 28 11:32:07 redd kernel: [   56.839728] ahci 0000:04:00.0: setting latency timer to 64
> Dec 28 11:32:07 redd kernel: [   56.839861] scsi6 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839912] scsi7 : ahci
> Dec 28 11:32:07 redd kernel: [   56.839978] ata7: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe100 irq 16
> Dec 28 11:32:07 redd kernel: [   56.839983] ata8: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe180 irq 16
> Dec 28 11:32:07 redd kernel: [   57.147188] ata1: SATA link down (SStatus 0 SControl 300)
> Dec 28 11:32:07 redd kernel: [   57.147218] ata7: SATA link down (SStatus 0 SControl 300)
> Dec 28 11:32:07 redd kernel: [   57.147249] ata8: SATA link down (SStatus 0 SControl 300)
> Dec 28 11:32:07 redd kernel: [   57.201093] irq 20: nobody cared (try booting with the "irqpoll" option)
> Dec 28 11:32:07 redd kernel: [   57.201098] Pid: 0, comm: swapper Not tainted 2.6.30.9-128 #1
>
>
> Dec 28 11:32:07 redd kernel: [   57.201100] Call Trace:
> Dec 28 11:32:07 redd kernel: [   57.201108]  [<c01759cf>] __report_bad_irq+0x2e/0x6f
> Dec 28 11:32:07 redd kernel: [   57.201113]  [<c0175b00>] note_interrupt+0xf0/0x148
> Dec 28 11:32:07 redd kernel: [   57.201116]  [<c017601e>] handle_fasteoi_irq+0x7d/0x9b
> Dec 28 11:32:07 redd kernel: [   57.201122]  [<c0104cdb>] handle_irq+0x3b/0x48
> Dec 28 11:32:07 redd kernel: [   57.201126]  [<c0104648>] do_IRQ+0x40/0x83
> Dec 28 11:32:07 redd kernel: [   57.201130]  [<c0103889>] common_interrupt+0x29/0x30
> Dec 28 11:32:07 redd kernel: [   57.201135]  [<c0108662>] ? mwait_idle+0x6b/0x89
> Dec 28 11:32:07 redd kernel: [   57.201139]  [<c01024b1>] cpu_idle+0x49/0x64
> Dec 28 11:32:07 redd kernel: [   57.201145]  [<c03fde07>] start_secondary+0xc6/0xc8
> Dec 28 11:32:07 redd kernel: [   57.201148] handlers:
> Dec 28 11:32:07 redd kernel: [   57.201149] [<f8076414>] (ahci_interrupt+0x0/0xa8 [ahci])
> Dec 28 11:32:07 redd kernel: [   57.201158] Disabling IRQ #20
>
>
> Dec 28 11:32:07 redd kernel: [   57.463017] ata2: SATA link down (SStatus 0 SControl 300)
> Dec 28 11:32:07 redd kernel: [   57.778848] ata3: SATA link down (SStatus 0 SControl 300)
> Dec 28 11:32:07 redd kernel: [   58.094678] ata4: SATA link down (SStatus 0 SControl 300)
> Dec 28 11:32:07 redd kernel: [   58.981252] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Dec 28 11:32:07 redd kernel: [   59.099172] ata5.00: ATA-8: ST3750528AS, CC37, max UDMA/133
> Dec 28 11:32:07 redd kernel: [   59.099175] ata5.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> Dec 28 11:32:07 redd kernel: [   59.399031] ata5.00: configured for UDMA/133
> Dec 28 11:32:07 redd kernel: [   59.410064] scsi 4:0:0:0: Direct-Access     ATA      ST3750528AS      CC37 PQ: 0 ANSI: 5
> Dec 28 11:32:07 redd kernel: [   59.410185] sd 4:0:0:0: Attached scsi generic sg0 type 0
> Dec 28 11:32:07 redd kernel: [   59.410206] sd 4:0:0:0: [sda] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
> Dec 28 11:32:07 redd kernel: [   59.410222] sd 4:0:0:0: [sda] Write Protect is off
> Dec 28 11:32:07 redd kernel: [   59.410226] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Dec 28 11:32:07 redd kernel: [   59.410246] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 28 11:32:07 redd kernel: [   59.410331]  sda: sda1 sda2<  sda5 sda6>
> Dec 28 11:32:07 redd kernel: [   59.699037] sd 4:0:0:0: [sda] Attached SCSI disk
> Dec 28 11:32:07 redd kernel: [   60.285554] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Dec 28 11:32:07 redd kernel: [   60.398475] ata6.00: ATAPI: HL-DT-ST DVDRAM GH22NS50, TN01, max UDMA/100, ATAPI AN
> Dec 28 11:32:07 redd kernel: [   60.698335] ata6.00: configured for UDMA/100

You say this only happens if the JMicron controller is enabled and set 
to AHCI mode? That's odd because it's the IRQ for the main Intel 
controller that it's complaining about. If that's really the IRQ it's 
using then I wonder how the system continues booting at all after it's 
disabled. Can you post /proc/interrupts output?

My other suggestions would be make sure you have the latest BIOS 
installed, and try a newer kernel if possible..
