Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbXGNMdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbXGNMdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 08:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbXGNMdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 08:33:37 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:45525 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbXGNMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 08:33:37 -0400
From: Markus <lists4me@web.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: flooding: "new high speed USB device using ehci_hcd and address"
Date: Sat, 14 Jul 2007 14:33:34 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141433.35026.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX1/Yvz7hzjIDnXv3aLbZnqy3Ic+Swb4gO46egdrE
	CkKnZWOkfTd8mlCjTXYAhffjT1JyS/P/Hcjhow+XgzCTVZ4TNG
	/jI67ftvs=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I just build 2.6.22-git5 to test the cfs.

I looked in the log and found:
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb 1-5: new high speed USB device using ehci_hcd and address 3
usb 1-5: new high speed USB device using ehci_hcd and address 4
usb 1-5: new high speed USB device using ehci_hcd and address 5
usb 1-5: new high speed USB device using ehci_hcd and address 6
usb 1-5: new high speed USB device using ehci_hcd and address 7
usb 1-5: new high speed USB device using ehci_hcd and address 8
usb 1-5: new high speed USB device using ehci_hcd and address 9

They do from address 2 up to 127 and then begin again. They are printed 
about three to four times a second.

# lsusb
Bus 002 Device 006: ID 046d:c222 Logitech, Inc.
Bus 002 Device 005: ID 046d:c221 Logitech, Inc.
Bus 002 Device 004: ID 046d:08b5 Logitech, Inc.
Bus 002 Device 003: ID 046d:c041 Logitech, Inc.
Bus 002 Device 002: ID 046d:c223 Logitech, Inc.
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 001: ID 0000:0000

# lspci
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller 
(rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 
Audio Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller 
(rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller 
(rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7600 
GS] (rev a1)
05:06.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
05:07.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 
Video Broadcast Decoder (rev f0)


   Markus
