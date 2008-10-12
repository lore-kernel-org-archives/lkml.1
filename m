Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYJLPrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYJLPrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 11:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYJLPqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 11:46:52 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:20767 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYJLPqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 11:46:52 -0400
Message-ID: <48F21BE9.8010405@msgid.tls.msk.ru>
Date: Sun, 12 Oct 2008 19:46:49 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27 ASPM: Pre-1.1 PCIe device detected - RS780 PCI to PCI bridge?
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tried shiny-new 2.6.27 kernel on this my system,
with compiled-in ASPM support.  And become curious by
this message during bootup:

Pre-1.1 PCIe device detected, disable ASPM for 0000:00:06.0. It can be enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:06.0 32bit mmio: [fea00000, feafffff]

Here's the device in question:

00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)

Should I be concerned by this presence of "Pre-1.1 PCIe device"?
Which should not be Pre-1.1, I think...

And here's the system specs:

AMD 780G/SB700 based Asus M3A-H/HDMI motherboard,
with AMD Phenom 9750 CPU.  lspci:

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx)
00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:12.1 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:13.1 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Graphics
02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit Ethernet Adapter (rev b0)
03:05.0 Serial controller: NetMos Technology PCI 9845 Multi-I/O Controller (rev 01)
03:06.0 Network controller: AIRONET Wireless Communications PC4800 (rev 01)
03:07.0 Ethernet controller: D-Link System Inc RTL8139 Ethernet (rev 10)

Thanks!

/mjt
