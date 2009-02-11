Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbZBKRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbZBKRId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbZBKRIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:08:15 -0500
Received: from stz-softwaretechnik.de ([217.160.223.211]:2450 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757298AbZBKRIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:08:13 -0500
X-Greylist: delayed 2071 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 12:08:13 EST
Date: Wed, 11 Feb 2009 17:33:17 +0100
From: Ralf Gross <Ralf-Lists@ralfgross.de>
To: linux-kernel@vger.kernel.org
Subject: Machine Check Exception with kernels > 2.6.18 and Supermicro Board
Message-ID: <20090211163317.GC32352@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running debian etch (amd64) on a Supermicro Server (Supermicro
Board X7DBE+, 16 GB RAM). Since upgrading to kernel 2.6.24 or 2.6.26
from the default etch kernel 2.6.18, I get Machine Check Exceptions.

HARDWARE ERROR
CPU 1: Machine Check Exception:   0 Bank 5: 1000001004000e0f
TSC 0
This is not a software problem!
Run through mcelog --ascii to decode and contact your hardware vendor
Kernel panic - not syncing: Machine check


With mcelog decoded error message:

HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 BANK 5 MCG status:
MCi status:
Invalid log
BQ_DCU_READ_TYPE BQ_ERR_AERR2_TYPE BQ_ERR_AERR2_TYPE response parity error
STATUS 1000001004000e0f MCGSTATUS 0



Any idea if this really is a hardware problem (bus, cpu, ram...?), or maybe
caused by a faulty driver? Our hardware vendor told me that at least on windows
this could be caused by a bad driver.


TIA
Ralf

(Please CC me, because I'm not subscribed to the LKML, thanks!)



Hardware setup:

Supermicro X7DBE+
2x Xeon 5110
Intel 5000P Chipset
16 GB FB DDR2-RAM with ECC, PC667 

lspci output:

00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 2-3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 4-5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 6-7 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller (rev 09)
00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA Storage Controller AHCI (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E3 (rev 01)
03:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge A (rev 09)
03:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09)
05:01.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
05:01.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
06:00.0 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN Controller Copper (rev 01)
06:00.1 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN Controller Copper (rev 01)
07:01.0 Fibre Channel: QLogic Corp. QLA2422 Fibre Channel Adapter (rev 02)
0b:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

