Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbXG0UBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbXG0UBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762483AbXG0UAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:00:55 -0400
Received: from zaphod.dth.net ([85.159.112.68]:54733 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762417AbXG0UAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:00:54 -0400
X-Greylist: delayed 1339 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 16:00:53 EDT
Date: Fri, 27 Jul 2007 21:38:32 +0200
From: dth <dth@dth.net>
To: linux-kernel@vger.kernel.org
Subject: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
Message-ID: <20070727193832.GA20289@dth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a via mini-itx epia 5000 motherboard as a firewall.
It has an ide device: PQI 128MB flash DOM [1] which just plugs
directly into the ide connector on the motherboard.
2.6.22-git17 works, although it gives some warning 
hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hda: set_drive_speed_status: error=0x04 { DriveStatusError }
Full dmesg output [2]

When i compiled any 2.6.23-rc1 kernel out so far it always froze on me.
Yesterday i tried 2.6.23-rc1-git3 and i booted until:

VP_IDE: VIA vt8231 (rev 10) IDE UDMA100 controller on pci0000:00:11.1
    ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
hda: PQI IDE DiskOnModule, ATA DISK drive
hda: IRQ probe failed (0xfff2)
Clocksource tsc unstable (delta = 84358771493 ns)

So i went back to 2.6.22-git17.
This morning i saw a fresh git4 and compiled/installed that.
This kernel actually booted! (once)
I had a netconsole running to catch the lucky event [3]

After about 2 minutes of working however, the whole machine froze.
No message at the console, not able to toggle numlock, no magic
sysrq key features: solid frozen.
After the power cycle i was not able to boot the same kernel
ever again. It was just like a timer had run out and it wouldn't 
work anymore. 

I know my hardware is "ancient" and the flash thing is probably
not current. My firewall however is solar powerpowered (10 watt 
power consumption) and it would be fun if i could run the latest/
greatest kernels on it.

Config files and hdparm info on the DOM in the same directory as
dmesg output.

Any comments appriciated.

Danny

[1] http://www.memorydepot.com/ssd_diskonmodule.asp
[2] http://www.dth.net/kernel/via_output_2.6.22_git17
[3] http://www.dth.net/kernel/via_output_2.6.23-rc1-git4


-- 
