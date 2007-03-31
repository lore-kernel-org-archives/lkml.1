Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXCaUOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXCaUOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXCaUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:14:06 -0400
Received: from smtpout08-04.prod.mesa1.secureserver.net ([64.202.165.12]:60623
	"HELO smtpout08.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752431AbXCaUOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:14:03 -0400
Message-ID: <460EC109.5070300@seclark.us>
Date: Sat, 31 Mar 2007 16:14:01 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc5 from fc7-rc2 problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have just tried booting the fc7-rc2 live cd on 2 of my laptops and it 
failed on both.

Laptop 1 is an asus vbi s96f that get a panic that says exception in 
interrupt routine
for my rtl8139.

This device works fine in 2.6.20.2
$ lspci -v
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 
945GT Express Memory Controller Hub (rev 03)
        Subsystem: Intel Corporation Mobile 945GM/PM/GMS/940GML and 
945GT Express Memory Controller Hub
        Flags: bus master, fast devsel, latency 0
        Capabilities: <access denied>

00:02.0 VGA compatible controller: Intel Corporation Mobile 
945GM/GMS/940GML Express Integrated Graphics Controller (rev 03) 
(prog-if 00 [VGA])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1252
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
        I/O ports at ec00 [size=8]
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Memory at feb40000 (32-bit, non-prefetchable) [size=256K]
        Capabilities: <access denied>

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML 
Express Integrated Graphics Controller (rev 03)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1252
        Flags: bus master, fast devsel, latency 0
        Memory at fea80000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1343
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at feb38000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 (rev 02) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        Capabilities: <access denied>

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 2 (rev 02) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Memory behind bridge: fe700000-fe7fffff
        Capabilities: <access denied>

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 3 (rev 02) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=02, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fdf00000-fe6fffff
        Prefetchable memory behind bridge: 00000000bdf00000-00000000bfe00000
        Capabilities: <access denied>

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at e400 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 0, IRQ 20
        I/O ports at e480 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 0, IRQ 18
        I/O ports at e800 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#4 (rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 0, IRQ 16
        I/O ports at e880 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 0, IRQ 19
        Memory at feb3fc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
(prog-if 01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fe800000-fe8fffff
        Prefetchable memory behind bridge: 0000000080000000-0000000080000000
        Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
Bridge (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 0
        Capabilities: <access denied>

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) 
Serial ATA Storage Controller IDE (rev 02) (prog-if 80 [Master])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 20
        I/O ports at 01f0 [size=8]
        I/O ports at 03f4 [size=1]
        I/O ports at 0170 [size=8]
        I/O ports at 0374 [size=1]
        I/O ports at ffa0 [size=16]
        Capabilities: <access denied>

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
(rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: medium devsel, IRQ 20
        I/O ports at 0400 [size=32]

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
Network Connection (rev 02)
        Subsystem: Intel Corporation Unknown device 1000
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at fe7ff000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

05:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (prog-if 
10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at fe8fe800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: <access denied>

05:01.1 Class 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host 
Adapter (rev 19)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 64, IRQ 17
        Memory at fe8ff000 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>

05:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: bus master, medium devsel, latency 0, IRQ 10
        Memory at fe8ff400 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>

05:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
Adapter (rev 0a)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1347
        Flags: medium devsel, IRQ 10
        Memory at fe8ff800 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>

05:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169SC 
Gigabit Ethernet (rev 10)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1345
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
        I/O ports at d800 [size=256]
        Memory at fe8ffc00 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at 80000000 [disabled] [size=128K]
        Capabilities: <access denied>


The other laptop is a hp n5430 it fail in the ali-pata driver not being 
able to read the cdrom, timeing out
and dropping into a bash shell telling me to tell it where the root 
filesystem is. Also it sets my hard
drive to udma/33 when it run find at udma/66 under 2.6.20.1. It would 
really be nice if the people makeing
all these changes would at least keep things compatible with what they 
were before. These are regressions
guys!

This hp n5430 system works fine with 2.6.20.1.

Hope this stuff gets fixed.


-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



