Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbYFZPPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbYFZPPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYFZPPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:15:32 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:38981 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYFZPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:15:31 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 11:15:31 EDT
Message-ID: <4863AEFB.6010300@planet.nl>
Date: Thu, 26 Jun 2008 17:00:11 +0200
From: Christian Boon <chris.boon@planet.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PCI: Failed to allocate mem 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 15:00:14.0821 (UTC) FILETIME=[56EC1950:01C8D79D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when booting the latest git kernel i get this error:

PCI: Failed to allocate mem resource #6:20000@f0000000 for 0000:01:00.0

# /sbin/lspci

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory 
Controller Hub (rev 0c)
00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI 
Express Root Port (rev 0c)
00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network 
Connection (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 2 (rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 3 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 4 (rev 03)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 5 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface 
Controller (rev 03)
00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) 
SATA IDE Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller 
(rev 03)
01:00.0 VGA compatible controller: nVidia Corporation Quadro NVS 140M 
(rev a1)
03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or 
AGN Network Connection (rev 61)
15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller 
(rev 04)
15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro 
Host Adapter (rev 21)
15:00.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff)
15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
Adapter (rev 11)
15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)

This has to do with the PCI Express Root Port if i am correct?
My laptop is working OK (Lenovo T61) as far as i know so i don't know 
how serious the error is?

Chris
