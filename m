Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbXAaAW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbXAaAW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXAaAW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:22:29 -0500
Received: from 87-194-8-112.bethere.co.uk ([87.194.8.112]:60074 "EHLO
	bloch.verdurin.priv" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbXAaAW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:22:28 -0500
X-Greylist: delayed 3123 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 19:22:27 EST
Date: Tue, 30 Jan 2007 23:30:21 +0000
From: bloch@verdurin.com
To: linux-kernel@vger.kernel.org
Cc: Alex Dubov <oakad@yahoo.com>
Subject: MMC: tifm_7xx1 driver detects card but does not make it mountable
Message-ID: <20070130233021.GN14953@bloch.config>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Alex Dubov <oakad@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running recent kernels the insertion of a MemoryStick into the card
reader of a Sony Vaio VGNSZ3XWP is detected but the card does not seem
to be probed for partitions and hence is not made available to
userspace.

Here is the message upon card insertion:

tifm_7xx1: ms card detected in socket 0

lspci:

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile
945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML
Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
Serial ATA Storage Controller IDE (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 02)
06:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
Network Connection (rev 02)
07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8036 PCI-E
Fast Ethernet Controller (rev 15)
09:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
09:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
IEEE 1394 Host Controller
09:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
Card Reader (SD/MMC/MS/MS PRO/xD)

lsusb:

Bus 004 Device 001: ID 0000:0000  
Bus 004 Device 002: ID 044e:300c Alps Electric Co., Ltd 
Bus 003 Device 002: ID 0483:2016 SGS Thomson Microelectronics
Fingerprint Reader
Bus 003 Device 001: ID 0000:0000  
Bus 001 Device 001: ID 0000:0000  
Bus 005 Device 001: ID 0000:0000  
Bus 005 Device 004: ID 05ca:1830 Ricoh Co., Ltd 
Bus 005 Device 002: ID 054c:0281 Sony Corp. 
Bus 002 Device 001: ID 0000:0000  


Adam
