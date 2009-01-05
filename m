Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZAEMMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZAEMMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZAEMMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:12:12 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:43182 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZAEMMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:12:10 -0500
Date: Mon, 5 Jan 2009 13:12:24 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org
Subject: USB troubles with w760i
Message-ID: <20090105121224.GK6192@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 05 Jan 2009 13:11:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got shiny new Sony-ericsson W760i mobile phone. When I plug it into the USB
through USB cable, I got the following messages:

[526453.604104] usb usb2: usb resume
[526453.604110] ehci_hcd 0000:00:1a.7: resume root hub
[526453.667408] hub 2-0:1.0: hub_resume
[526453.667433] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001803 POWER
sig=j CSC CONNECT
[526453.667436] hub 2-0:1.0: port 3: status 0501 change 0001
[526453.667447] hub 2-0:1.0: port 4: status 0507 change 0000
[526453.770777] hub 2-0:1.0: state 7 ports 4 chg 0008 evt 0000
[526453.770791] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[526453.825770] ehci_hcd 0000:00:1a.7: port 3 high speed
[526453.825773] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER
sig=se0 PE CONNECT
[526453.877448] usb 2-3: new high speed USB device using ehci_hcd and address
11
[526454.101020] ehci_hcd 0000:00:1a.7: port 3 high speed
[526454.101025] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER
sig=se0 PE CONNECT
[526454.174558] usb 2-3: default language 0x0409
[526454.175059] usb 2-3: uevent
[526454.175076] usb 2-3: usb_probe_device
[526454.175077] usb 2-3: configuration #2 chosen from 1 choice
[526454.175650] usb 2-3: adding 2-3:2.0 (config #2, interface 0)
[526454.175664] usb 2-3:2.0: uevent
[526454.175678] libusual 2-3:2.0: usb_probe_interface
[526454.175682] libusual 2-3:2.0: usb_probe_interface - got id
[526454.175693] usb-storage 2-3:2.0: usb_probe_interface
[526454.175697] usb-storage 2-3:2.0: usb_probe_interface - got id
[526454.178273] scsi9 : SCSI emulation for USB Mass Storage devices
[526454.178526] usb-storage: device found at 11
[526454.178528] usb-storage: waiting for device to settle before scanning
[526454.179019] drivers/usb/core/inode.c: creating file '011'
[526454.179058] usb 2-3: New USB device found, idVendor=0fce, idProduct=e0c6
[526454.179060] usb 2-3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[526454.179062] usb 2-3: Product: Memory Stick
[526454.179064] usb 2-3: Manufacturer: Sony Ericsson
[526454.179065] usb 2-3: SerialNumber: 3570670220504780
[526459.177824] usb-storage: device scan complete
[526459.178328] scsi 9:0:0:0: Direct-Access     Sony Eri Memory Stick
0 PQ: 0 ANSI: 0
[526459.178690] scsi 9:0:0:1: Direct-Access     Sony Eri Memory Stick
0 PQ: 0 ANSI: 0
[526459.179532] sd 9:0:0:0: [sdb] 120093 512-byte hardware sectors: (61.4
MB/58.6 MiB)
[526459.180534] sd 9:0:0:0: [sdb] Test WP failed, assume Write Enabled
[526459.180536] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[526459.182285] sd 9:0:0:0: [sdb] 120093 512-byte hardware sectors: (61.4
MB/58.6 MiB)
[526459.183280] sd 9:0:0:0: [sdb] Test WP failed, assume Write Enabled
[526459.183283] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[526459.183286]  sdb: sdb1
[526459.186089] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[526459.186239] sd 9:0:0:0: Attached scsi generic sg2 type 0
[526459.186908] sd 9:0:0:1: [sdc] 3995648 512-byte hardware sectors: (2.04
GB/1.90 GiB)
[526459.247211] sd 9:0:0:1: [sdc] Test WP failed, assume Write Enabled
[526459.247216] sd 9:0:0:1: [sdc] Assuming drive cache: write through
[526459.264317] sd 9:0:0:1: [sdc] 3995648 512-byte hardware sectors: (2.04
GB/1.90 GiB)
[526459.266565] sd 9:0:0:1: [sdc] Test WP failed, assume Write Enabled
[526459.266567] sd 9:0:0:1: [sdc] Assuming drive cache: write through
[526459.266571]  sdc:<7>ehci_hcd 0000:00:1a.7: port 3 high speed
[526489.341028] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER
sig=se0 PE CONNECT
[526489.392244] usb 2-3: reset high speed USB device using ehci_hcd and
address 11
[526489.452275] ehci_hcd 0000:00:1a.7: port 3 high speed
[526489.452283] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER
sig=se0 PE CONNECT
[526520.349404] ehci_hcd 0000:00:1a.7: port 3 high speed
[526520.349408] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER
sig=se0 PE CONNECT
[526520.401598] usb 2-3: reset high speed USB device using ehci_hcd and
address 11
[526520.467654] ehci_hcd 0000:00:1a.7: port 3 high speed
[526520.467665] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001005 POWER
sig=se0 PE CONNECT

and the devices /dev/sdc* and /dev/sdb* disappears. Is there something I could
do for get it working? It works with Windows. This test was on 2.6.28 but it
is not better on 2.6.24 or 2.6.26.

-- 
Luká¹ Hejtmánek
