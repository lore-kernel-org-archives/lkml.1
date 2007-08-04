Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbXHDMTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbXHDMTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 08:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXHDMTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 08:19:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:24706 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXHDMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 08:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=k7BN7bse+rbakzKwKqAnj4zfpNyqP968dB5JU2oqk2iAymYoxEn+S2C/R7SIob+c9VfLYF4fV/qUwTgvoCK8MmXRQGNDqh+BWr9cTWhyzZXuD6hVUKDhHnvAPLQOYbBNw58Iv4u8XM7YtpXiXrDhduTHYoOQ9Nqh5EU86lOTxVE=
Message-ID: <a44ae5cd0708040518vfcf671p7ef1c6d89e330d89@mail.gmail.com>
Date: Sat, 4 Aug 2007 08:18:58 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: 2.6.23-rc1-mm2 + cpufreq patch + hot-fixes -- [<f8ea528f>] usb_stor_scan_thread+0xbd/0x15a [usb_storage]
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

usb usb4: usb resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 4-0:1.0: hub_resume
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 4-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 3 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 4-3: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 3 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
usb 4-3: default language 0x0409
usb 4-3: new device found, idVendor=0781, idProduct=5150
usb 4-3: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 4-3: Product: Cruzer Mini
usb 4-3: Manufacturer: SanDisk Corporation
usb 4-3: SerialNumber: SNDK5C31950CBB106202
usb 4-3: uevent
usb 4-3: usb_probe_device
usb 4-3: configuration #1 chosen from 1 choice
usb 4-3: adding 4-3:1.0 (config #1, interface 0)
usb 4-3:1.0: uevent
usb 4-3:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
Initializing USB Mass Storage driver...
usb-storage 4-3:1.0: usb_probe_interface
usb-storage 4-3:1.0: usb_probe_interface - got id
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
schedule_timeout: wrong timeout value f8ea51d2
 [<c01080ab>] show_trace_log_lvl+0x12/0x25
 [<c0108a9e>] show_trace+0xd/0x10
 [<c0108bac>] dump_stack+0x16/0x18
 [<c031e31e>] schedule_timeout+0x2c/0x8b
 [<f8ea528f>] usb_stor_scan_thread+0xbd/0x15a [usb_storage]
 [<c0139d64>] kthread+0x3b/0x63
 [<c0107c63>] kernel_thread_helper+0x7/0x10
 =======================
USB Mass Storage support registered.
scsi 2:0:0:0: Direct-Access     SanDisk  Cruzer Mini      0.4  PQ: 0 ANSI: 2
sd 2:0:0:0: [sdb] 2001888 512-byte hardware sectors (1025 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] 2001888 512-byte hardware sectors (1025 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
