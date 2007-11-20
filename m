Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbXKTKdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbXKTKdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXKTKdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:33:00 -0500
Received: from osl1smout1.broadpark.no ([80.202.4.58]:50611 "EHLO
	osl1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXKTKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:32:59 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 05:32:59 EST
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=utf-8
Subject: Re: laptop reboots right after hibernation
From: Kjartan Maraas <kmaraas@broadpark.no>
To: Tomas Carnecky <tom@dbservice.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <47409DA3.7070909@dbservice.com>
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz>
 <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com>
Date: Tue, 20 Nov 2007 10:32:21 +0100
Message-id: <1195551141.2792.3.camel@localhost.localdomain>
X-Mailer: Evolution 2.21.2 (2.21.2-1.fc9)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


sø., 18.11.2007 kl. 21.16 +0100, skrev Tomas Carnecky:
> Since this is becoming more an IDE/ATA issue, I added
> linux-ide@vger.kernel.org to CC. I hope that's the right mailinglist.
> 
> Tomas Carnecky wrote:
> > (3) Once the notebook was in the docking station (whether I boot it
> > while in the dock or boot it outside and then put it into the dock) and
> > I take it out (press the 'undock' button on the dock, wait for the green
> > led, then take out the notebook) things get interesting:
> > 
> > (a) I initiate STR, notebook correctly goes to sleep, but it only wakes
> > up if I have it in the docking station. If I try to wake it up outside
> > of the docking station it will fail.
> 
[snip str problem description]

> ata4.00: ACPI cmd ef/03:45:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
> ata4: failed to recover some devices, retrying in 5 secs
> Coming out of suspend...
> [... snip ...]
> ata4.00: ACPI cmd ef/03:45:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
> ata4.00: ACPI on devcfg failed the second time, disabling (errno=-5)
> ata4.00: revalidation failed (errno=1)
> ata4: failed to recover some devices, retrying in 5 secs
> ata4.00: configured for UDMA/33
> 
I get this exact error message on a normal first time boot here. I'm
using the latest fedora development kernel which is 2.6.24-rc2-git6
based. And I have the latest BIOS from HP IIRC.

This is an HP nc6400 intel based laptop:

ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
ata1.00: ACPI on devcfg failed the second time, disabling (errno=-5)
ata1.00: revalidation failed (errno=1)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
insmod used greatest stack depth: 596 bytes left

lspci:

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA AHCI Controller (rev 01)
01:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5753M Gigabit Ethernet PCI Express (rev 21)
02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
04:06.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
04:06.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)
04:06.3 Generic system peripheral [0805]: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller
04:06.4 Communication controller: Texas Instruments PCIxx12 GemCore based SmartCard controller

Cheers
Kjartan


