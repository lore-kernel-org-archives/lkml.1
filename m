Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZBBThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZBBThp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBBThf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:37:35 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:60385 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZBBThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:37:34 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 14:37:34 EST
Date: Mon, 2 Feb 2009 17:28:25 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: rbrito@ime.usp.br
Subject: Stack trace with kernel 2.6.29-rc2
Message-ID: <20090202192823.GA3181@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear people,

I have compiled a kernel 2.6.29-rc2 here and my girlfriend's cell phone
had a photo that she wanted me to retouch with GIMP.

Upon plugging the phone (a Sony-Ericsson W580i), I got the following
stack trace:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[   43.301629] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   70.296125] hfs: Filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  mounting read-only.
[47560.223207] RPC: Registered udp transport module.
[47560.223213] RPC: Registered tcp transport module.
[64006.505015] usb 4-1: new full speed USB device using uhci_hcd and address 2
[64006.683960] usb 4-1: New USB device found, idVendor=0fce, idProduct=d089
[64006.683968] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[64006.683972] usb 4-1: Product: Sony Ericsson W580
[64006.683975] usb 4-1: Manufacturer: Sony Ericsson
[64006.683977] usb 4-1: SerialNumber: 3538320239844940
[64006.684265] usb 4-1: configuration #3 chosen from 1 choice
[64017.954045] usb 4-1: USB disconnect, address 2
[64019.944014] usb 4-1: new full speed USB device using uhci_hcd and address 3
[64020.104164] usb 4-1: New USB device found, idVendor=0fce, idProduct=e089
[64020.104170] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[64020.104174] usb 4-1: Product: Memory Stick
[64020.104177] usb 4-1: Manufacturer: Sony Ericsson
[64020.104180] usb 4-1: SerialNumber: 3538320239844940
[64020.104854] usb 4-1: configuration #2 chosen from 1 choice
[64020.194618] SCSI subsystem initialized
[64020.206166] Initializing USB Mass Storage driver...
[64020.206805] scsi0 : SCSI emulation for USB Mass Storage devices
[64020.210153] usb-storage: device found at 3
[64020.210157] usb-storage: waiting for device to settle before scanning
[64020.210182] usbcore: registered new interface driver usb-storage
[64020.210189] USB Mass Storage support registered.
[64025.211305] usb-storage: device scan complete
[64025.214298] scsi 0:0:0:0: Direct-Access     Sony Eri Memory Stick     0000 PQ: 0 ANSI: 0
[64025.300302] Driver 'sd' needs updating - please use bus_type methods
[64025.306246] sd 0:0:0:0: [sda] 958999 512-byte hardware sectors: (491 MB/468 MiB)
[64025.313247] sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
[64025.313253] sd 0:0:0:0: [sda] Assuming drive cache: write through
[64025.322240] sd 0:0:0:0: [sda] 958999 512-byte hardware sectors: (491 MB/468 MiB)
[64025.329243] sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
[64025.329249] sd 0:0:0:0: [sda] Assuming drive cache: write through
[64025.329254]  sda: sda1
[64025.338262] sda: p1 size 958999 limited to end of disk
[64025.341192] sd 0:0:0:0: [sda] Attached SCSI removable disk
[64025.510204] ------------[ cut here ]------------
[64025.510211] WARNING: at drivers/usb/storage/transport.c:584 last_sector_hacks+0xfd/0x155 [usb_storage]()
[64025.510214] Hardware name:  
[64025.510218] sda: Successful last sector success at 958998, device 0fce:e089:0000
[64025.510221] Modules linked in: sd_mod usb_storage scsi_mod nfs lockd nfs_acl sunrpc nls_utf8 i915 fb cfbcopyarea cfbimgblt cfbfillrect fuse hfsplus nls_base 8139too bitrev iTCO_wdt evdev pcspkr crc32 iTCO_vendor_support e100 fan 8250_pnp 8250 serial_core thermal button processor
[64025.510262] Pid: 3089, comm: usb-storage Not tainted 2.6.29-rc2-1 #1
[64025.510265] Call Trace:
[64025.510276]  [<ffffffff80235d41>] warn_slowpath+0xd8/0x112
[64025.510282]  [<ffffffff802282e3>] update_curr+0x63/0x104
[64025.510289]  [<ffffffff8047df69>] _spin_unlock_irq+0x30/0x3d
[64025.510296]  [<ffffffff8047c098>] wait_for_common+0xfd/0x10b
[64025.510301]  [<ffffffff8022de2b>] default_wake_function+0x0/0x9
[64025.510306]  [<ffffffff8023063a>] signal_pending_state+0x20/0x47
[64025.510310]  [<ffffffff8047df69>] _spin_unlock_irq+0x30/0x3d
[64025.510315]  [<ffffffff8047c098>] wait_for_common+0xfd/0x10b
[64025.510326]  [<ffffffffa0154c42>] usb_stor_msg_common+0x10d/0x136 [usb_storage]
[64025.510336]  [<ffffffffa0155027>] usb_stor_bulk_transfer_buf+0x4d/0x82 [usb_storage]
[64025.510346]  [<ffffffffa0155650>] usb_stor_Bulk_transport+0x127/0x24c [usb_storage]
[64025.510355]  [<ffffffffa0154add>] last_sector_hacks+0xfd/0x155 [usb_storage]
[64025.510365]  [<ffffffffa01553de>] usb_stor_invoke_transport+0x280/0x28b [usb_storage]
[64025.510370]  [<ffffffff8023063a>] signal_pending_state+0x20/0x47
[64025.510375]  [<ffffffff8047df69>] _spin_unlock_irq+0x30/0x3d
[64025.510380]  [<ffffffff8047c098>] wait_for_common+0xfd/0x10b
[64025.510385]  [<ffffffff8022de2b>] default_wake_function+0x0/0x9
[64025.510394]  [<ffffffffa0156614>] usb_stor_control_thread+0x12b/0x1d3 [usb_storage]
[64025.510404]  [<ffffffffa01564e9>] usb_stor_control_thread+0x0/0x1d3 [usb_storage]
[64025.510413]  [<ffffffffa01564e9>] usb_stor_control_thread+0x0/0x1d3 [usb_storage]
[64025.510419]  [<ffffffff8024795f>] kthread+0x47/0x73
[64025.510425]  [<ffffffff8020c6ea>] child_rip+0xa/0x20
[64025.510430]  [<ffffffff80247918>] kthread+0x0/0x73
[64025.510434]  [<ffffffff8020c6e0>] child_rip+0x0/0x20
[64025.510437] ---[ end trace 9a79c3d3221fb608 ]---
rbrito@chagas:~/Desktop/code$ 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

If anybody can help, I would sincerely appreciate. This is on an x86-64
machine (a Pentium D 805), running Debian unstable as userland. I can
provide many other details if needed.

Also, it seems that the 2.6.29-rc2 kernel has problems with my iBook's
HD (it disables the UDMA of the drive, while, if I revert to kernel
2.6.28, it works perfectly fine).

Please, keep me with the CC'ies, as I am not currently subscribed to
linux-kernel.


Thank you very much for any help,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
