Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbXERHRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbXERHRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXERHRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:17:11 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:45554 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbXERHRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:17:10 -0400
Date: Fri, 18 May 2007 16:15:24 +0900
From: Mattia Dongili <malattia@linux.it>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR
Message-ID: <20070518071523.GA3195@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc1-mm1-2 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After finally catching fw-{ohci,core} to be problematic during resume,
I'm now experiencing an immediate resume after suspending.

2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
2.6.21-rc6-mm* after the cpuidle fixes).

my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
and a str cycle with PM_DEBUG=y:
http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt

So this is on a vaio Sz72B,
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller IDE (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
06:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8036 PCI-E Fast Ethernet Controller (rev 15)
09:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
09:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
09:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)

Any idea where to start from? (bisecting is ok, but it'll take some
time...)
-- 
mattia
:wq!
