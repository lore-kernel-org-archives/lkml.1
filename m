Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYFWHuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYFWHuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYFWHt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:49:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42441 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYFWHt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:49:56 -0400
Date: Mon, 23 Jun 2008 00:40:22 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
Subject: 2.6.26-rc6: pcmcia stopped working after resume
Message-ID: <20080622224022.GA2066@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After s2ram and resume, CF card in PCMCIA-to-CF slot is no longer
detected.

Jun 23 00:38:28 amd kernel: sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Jun 23 00:38:28 amd kernel: sd 0:0:0:0: [sda] 117210240 512-byte
hardware sectors (60012 MB)
Jun 23 00:38:28 amd kernel: sd 0:0:0:0: [sda] Write Protect is off
Jun 23 00:38:28 amd kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jun 23 00:38:28 amd kernel: sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Jun 23 00:38:28 amd kernel: PM: Writing back config space on device
0000:15:00.2 at offset 4 (was 0, writing e4301800)
Jun 23 00:38:28 amd kernel: PM: Writing back config space on device
0000:15:00.2 at offset 3 (was 800000, writing 804000)
Jun 23 00:38:28 amd kernel: PM: Writing back config space on device
0000:15:00.2 at offset 1 (was 2100000, writing 2100006)
Jun 23 00:38:28 amd kernel: sleepy: scsi_bus_resume start
Jun 23 00:38:28 amd kernel: sleepy: scsi_bus_resume done
Jun 23 00:38:28 amd kernel: usb 4-1: reset low speed USB device using
uhci_hcd and address 2
Jun 23 00:38:28 amd kernel: PM: Finishing wakeup.
Jun 23 00:38:28 amd kernel: Restarting tasks ... done.
Jun 23 00:38:28 amd kernel: usb 5-1: USB disconnect, address 2
Jun 23 00:38:28 amd cardmgr[1396]: executing: './ide resume hdc 2>&1'
Jun 23 00:38:28 amd cardmgr[1396]: + ./shared: line 127:
/var/run/stab: No such file or directory
Jun 23 00:38:28 amd cardmgr[1396]: + usage: ./ide [action] [device
name]
Jun 23 00:38:28 amd cardmgr[1396]: +   actions: start check stop
suspend resume
Jun 23 00:38:28 amd cardmgr[1396]: resume cmd exited with status 1
Jun 23 00:38:28 amd kernel: usb 5-1: new full speed USB device using
uhci_hcd and address 4
Jun 23 00:38:28 amd kernel: usb 5-1: configuration #1 chosen from 1
choice
Jun 23 00:38:28 amd kernel: usb 5-1: New USB device found,
idVendor=0a5c, idProduct=2110
Jun 23 00:38:28 amd kernel: usb 5-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=0
Jun 23 00:38:28 amd kernel: usb 5-1: Product: BCM2045B
Jun 23 00:38:28 amd kernel: usb 5-1: Manufacturer: Broadcom Corp
Jun 23 00:38:28 amd kernel: usb 5-2: USB disconnect, address 3
Jun 23 00:38:28 amd kernel: usb 5-2: new full speed USB device using
uhci_hcd and address 5
Jun 23 00:38:29 amd kernel: usb 5-2: configuration #1 chosen from 1
choice
Jun 23 00:38:29 amd kernel: usb 5-2: New USB device found,
idVendor=0483, idProduct=2016
Jun 23 00:38:29 amd kernel: usb 5-2: New USB device strings: Mfr=1,
Product=2, SerialNumber=0
Jun 23 00:38:29 amd kernel: usb 5-2: Product: Biometric Coprocessor
Jun 23 00:38:29 amd kernel: usb 5-2: Manufacturer: STMicroelectronics
pccard: card ejected from slot 0
Jun 23 00:38:32 amd kernel: pccard: card ejected from slot 0

I eject it, but nothing happens (and no messages in log) on
insertion. I think system will die on next s2ram attempt.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
