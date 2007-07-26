Return-Path: <linux-kernel-owner+w=401wt.eu-S1765741AbXGZOK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765741AbXGZOK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXGZOKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:10:11 -0400
Received: from rrzd5.rz.uni-regensburg.de ([194.94.155.50]:20249 "EHLO
	rrzd5.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761056AbXGZOKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:10:09 -0400
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 10:10:09 EDT
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg, Klinikum
To: linux-kernel@vger.kernel.org
Date: Thu, 26 Jul 2007 15:36:20 +0200
MIME-Version: 1.0
Subject: Q: PCI-X @ 266MHz on HP rx6600 (Qlogic 4Gb FC HBA)
Message-ID: <46A8BF75.161.5C8424A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.25/Sophos-P=4.16.0+V=4.16+U=2.07.165+R=02 April 2007+T=237288@20070726.133542Z
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question: The Qlogic ISP2422 chip is said to handle PCI-X 266MHz. So does 
the HP Itanium2 server rx6600. Basically that was the reason to select that 
server. The FC-HBA is in a 266 MHz capable slot. However when booting SLES10 SP1 
for IA64, the logs say:

<6>QLogic Fibre Channel HBA Driver
<6>GSI 49 (level, low) -> CPU 3 (0x0300) vector 51
<6>ACPI: PCI Interrupt 0000:0f:01.0[A] -> GSI 49 (level, low) -> IRQ 51
<6>qla2xxx 0000:0f:01.0: Found an ISP2422, irq 51, iobase 0xc0000000b0040000
[...]
<6>qla2xxx 0000:0f:01.0: LOOP UP detected (4 Gbps).
<6>qla2xxx 0000:0f:01.0: Topology - (F_Port), Host Loop address 0x0
<6>scsi0 : qla2xxx
<6>qla2xxx 0000:0f:01.0:
<4> QLogic Fibre Channel HBA Driver: 8.01.07-k3
<4>  QLogic HP AB378-60001 -
<4>  ISP2422: PCI-X Mode 2 (133 MH4.00.26 [IP]  @ 0000:0f:01.0 hdma+, host#=0, 
fw=4.00.26 [IP]
<5>  Vendor: HP        Model: HSV200            Rev: 6100
<5>  Type:   RAID                               ANSI SCSI revision: 02
<5> 0:0:0:0: Attached scsi generic sg0 type 12

Now does Linux support the speed of 266 MHz, and is it just displayed incorrectly, 
or doesn't Linux support the speed of 266MHz yet?

"lspci -v" says:
0f:01.0 Fibre Channel: QLogic Corp. ISP2422-based 4Gb Fibre Channel to PCI-X HBA 
(rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 12d6
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 51
        I/O ports at 6000 [size=256]
        Memory at b0040000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at b0000000 [disabled] [size=256K]
        Capabilities: [44] Power Management version 2
        Capabilities: [4c] PCI-X non-bridge device
        Capabilities: [64] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 
Enable-
        Capabilities: [74] Vital Product Data

Please CC: any replies to my address as I'm not subscribed to the kernel list.

Regards,
Ulrich Windl

