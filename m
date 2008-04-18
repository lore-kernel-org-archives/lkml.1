Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbYDRSYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbYDRSYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760240AbYDRSYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:24:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:39171 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760204AbYDRSYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bm8eA7PEm1c81d2B2PnghH6OdI8ChlidfJizCzeQCatFmjiwClk6tvOatWX/rvUWEpWrzsBT/c9d4ASs5oKjClIepFpx6MHQVWWe/HKaLF9AQnQ9nPl+0hA3pOk7lKGrhjTJbt0BD6oSi+eMRhWte+LsbJ5BLGAAz4Lz5d1KT6I=
Message-ID: <a44ae5cd0804181124s772fa61bp22035c2b758471b1@mail.gmail.com>
Date: Fri, 18 Apr 2008 14:24:27 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Greg KH" <gregkh@suse.de>,
       "Kay Sievers" <kay.sievers@vrfy.org>
Subject: 2.6.25-mm1 -- WARNING: at fs/sysfs/dir.c:427 sysfs_add_one+0x33/0x9a()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    5.097022] WARNING: at fs/sysfs/dir.c:427 sysfs_add_one+0x33/0x9a()
[    5.097026] Modules linked in: floppy ohci1394(+) ieee1394
pata_amd(+) 3c59x(+) mii libata ehci_hcd(+) ohci_hcd(+) forcedeth
usbcore ssb thermal processor fan fuse
[    5.097051] Pid: 1112, comm: modprobe Not tainted 2.6.25-mm1 #7
[    5.097057]  [<c012883a>] warn_on_slowpath+0x41/0x67
[    5.097354]  [<c0128919>] ? test_ti_thread_flag+0xf/0x11
[    5.097363]  [<c01292c7>] ? vprintk+0x3ab/0x3c2
[    5.097379]  [<c0189ba5>] ? ifind+0x55/0x5f
[    5.097391]  [<c02d7450>] ? _spin_unlock+0x38/0x44
[    5.097403]  [<c0189ba5>] ? ifind+0x55/0x5f
[    5.097411]  [<c01b2410>] ? sysfs_ilookup_test+0x0/0x11
[    5.097421]  [<c01292f3>] ? printk+0x15/0x17
[    5.097430]  [<c01b2703>] sysfs_add_one+0x33/0x9a
[    5.097438]  [<c01b331e>] sysfs_create_link+0xa7/0xd1
[    5.097449]  [<c0259fef>] device_add+0x123/0x405
[    5.097466]  [<c025a2e3>] device_register+0x12/0x15
[    5.097474]  [<c025a35b>] device_create+0x75/0x9a
[    5.097484]  [<f8893dc7>] usb_classdev_notify+0x40/0x72 [usbcore]
[    5.097522]  [<c013cbae>] notifier_call_chain+0x2b/0x4a
[    5.097536]  [<c013cd51>] __blocking_notifier_call_chain+0x37/0x4c
[    5.097547]  [<c013cd72>] blocking_notifier_call_chain+0xc/0xe
[    5.097556]  [<f8893fa4>] usb_notify_add_device+0x14/0x16 [usbcore]
[    5.097581]  [<f889424c>] generic_probe+0x77/0x83 [usbcore]
[    5.097606]  [<f888ee7c>] usb_probe_device+0x32/0x38 [usbcore]
[    5.097628]  [<c025b8a2>] driver_probe_device+0xa0/0x11b
[    5.097637]  [<c025b984>] __device_attach+0x8/0xa
[    5.097644]  [<c025b060>] bus_for_each_drv+0x39/0x63
[    5.097653]  [<c025b9f6>] device_attach+0x51/0x67
[    5.097660]  [<c025b97c>] ? __device_attach+0x0/0xa
[    5.097668]  [<c025af18>] bus_attach_device+0x24/0x4e
[    5.097676]  [<c025a190>] device_add+0x2c4/0x405
[    5.097689]  [<f8888ee1>] usb_new_device+0x4d/0x83 [usbcore]
[    5.097711]  [<f888ba9e>] usb_add_hcd+0x420/0x55f [usbcore]
[    5.097735]  [<c028191f>] ? pcibios_set_master+0x78/0x81
[    5.097748]  [<f88947cf>] usb_hcd_pci_probe+0x252/0x30b [usbcore]
[    5.097774]  [<c01fe704>] pci_device_probe+0x39/0x59
[    5.097785]  [<c025b8a2>] driver_probe_device+0xa0/0x11b
[    5.097793]  [<c025b95a>] __driver_attach+0x3d/0x5f
[    5.097801]  [<c025b2aa>] bus_for_each_dev+0x3e/0x60
[    5.097811]  [<c025b739>] driver_attach+0x14/0x16
[    5.097817]  [<c025b91d>] ? __driver_attach+0x0/0x5f
[    5.097825]  [<c025ad51>] bus_add_driver+0x9d/0x1ad
[    5.097834]  [<c025baa3>] driver_register+0x47/0xa3
[    5.097841]  [<c01f944e>] ? __spin_lock_init+0x24/0x48
[    5.097852]  [<c01fe8e3>] __pci_register_driver+0x53/0x80
[    5.097861]  [<f8811035>] ohci_hcd_mod_init+0x35/0x63 [ohci_hcd]
[    5.097874]  [<c014af69>] sys_init_module+0x15e5/0x177b
[    5.097892]  [<c016a3c5>] ? vma_link+0x66/0x71
[    5.097904]  [<f8864000>] ? amd_init+0x0/0x19 [pata_amd]
[    5.097915]  [<c016aa18>] ? mmap_region+0x2cd/0x377
[    5.097925]  [<f8887790>] ? usb_root_hub_lost_power+0x0/0x2f [usbcore]
[    5.097956]  [<c0106c32>] syscall_call+0x7/0xb
[    5.097970]  =======================
[    5.097975] ---[ end trace 3d0d724a7c8aa619 ]---
[    5.097978] disabling CONFIG_USB_DEVICE_CLASS might fix this

[...]

[    5.258579] WARNING: at fs/sysfs/dir.c:427 sysfs_add_one+0x33/0x9a()
[    5.258583] Modules linked in: floppy ohci1394(+) ieee1394
pata_amd(+) 3c59x(+) mii libata ehci_hcd(+) ohci_hcd(+) forcedeth
usbcore ssb thermal processor fan fuse
[    5.258610] Pid: 1112, comm: modprobe Tainted: G        W 2.6.25-mm1 #7
[    5.258617]  [<c012883a>] warn_on_slowpath+0x41/0x67
[    5.258633]  [<c0128919>] ? test_ti_thread_flag+0xf/0x11
[    5.258642]  [<c01292c7>] ? vprintk+0x3ab/0x3c2
[    5.258656]  [<c0189b66>] ? ifind+0x16/0x5f
[    5.258668]  [<c02d7450>] ? _spin_unlock+0x38/0x44
[    5.258680]  [<c0189ba5>] ? ifind+0x55/0x5f
[    5.258687]  [<c01b2410>] ? sysfs_ilookup_test+0x0/0x11
[    5.258696]  [<c01292f3>] ? printk+0x15/0x17
[    5.258704]  [<c01b2703>] sysfs_add_one+0x33/0x9a
[    5.258712]  [<c01b331e>] sysfs_create_link+0xa7/0xd1
[    5.258722]  [<c0259fef>] device_add+0x123/0x405
[    5.258739]  [<c025a2e3>] device_register+0x12/0x15
[    5.258746]  [<c025a35b>] device_create+0x75/0x9a
[    5.258755]  [<f8893dc7>] usb_classdev_notify+0x40/0x72 [usbcore]
[    5.258793]  [<c013cbae>] notifier_call_chain+0x2b/0x4a
[    5.258806]  [<c013cd51>] __blocking_notifier_call_chain+0x37/0x4c
[    5.258817]  [<c013cd72>] blocking_notifier_call_chain+0xc/0xe
[    5.258825]  [<f8893fa4>] usb_notify_add_device+0x14/0x16 [usbcore]
[    5.258849]  [<f889424c>] generic_probe+0x77/0x83 [usbcore]
[    5.258874]  [<f888ee7c>] usb_probe_device+0x32/0x38 [usbcore]
[    5.258895]  [<c025b8a2>] driver_probe_device+0xa0/0x11b
[    5.258904]  [<c025b984>] __device_attach+0x8/0xa
[    5.258910]  [<c025b060>] bus_for_each_drv+0x39/0x63
[    5.258919]  [<c025b9f6>] device_attach+0x51/0x67
[    5.258925]  [<c025b97c>] ? __device_attach+0x0/0xa
[    5.258934]  [<c025af18>] bus_attach_device+0x24/0x4e
[    5.258941]  [<c025a190>] device_add+0x2c4/0x405
[    5.258953]  [<f8888ee1>] usb_new_device+0x4d/0x83 [usbcore]
[    5.258974]  [<f888ba9e>] usb_add_hcd+0x420/0x55f [usbcore]
[    5.258998]  [<c028191f>] ? pcibios_set_master+0x78/0x81
[    5.259011]  [<f88947cf>] usb_hcd_pci_probe+0x252/0x30b [usbcore]
[    5.259036]  [<c01fe704>] pci_device_probe+0x39/0x59
[    5.259046]  [<c025b8a2>] driver_probe_device+0xa0/0x11b
[    5.259054]  [<c025b95a>] __driver_attach+0x3d/0x5f
[    5.259062]  [<c025b2aa>] bus_for_each_dev+0x3e/0x60
[    5.259071]  [<c025b739>] driver_attach+0x14/0x16
[    5.259077]  [<c025b91d>] ? __driver_attach+0x0/0x5f
[    5.259084]  [<c025ad51>] bus_add_driver+0x9d/0x1ad
[    5.259092]  [<c025baa3>] driver_register+0x47/0xa3
[    5.259098]  [<c01f944e>] ? __spin_lock_init+0x24/0x48
[    5.259109]  [<c01fe8e3>] __pci_register_driver+0x53/0x80
[    5.259117]  [<f8811035>] ohci_hcd_mod_init+0x35/0x63 [ohci_hcd]
[    5.259130]  [<c014af69>] sys_init_module+0x15e5/0x177b
[    5.259149]  [<c016a3c5>] ? vma_link+0x66/0x71
[    5.259160]  [<f8864000>] ? amd_init+0x0/0x19 [pata_amd]
[    5.259171]  [<c016aa18>] ? mmap_region+0x2cd/0x377
[    5.259181]  [<f8887790>] ? usb_root_hub_lost_power+0x0/0x2f [usbcore]
[    5.259212]  [<c0106c32>] syscall_call+0x7/0xb
[    5.259226]  =======================
[    5.259230] ---[ end trace 3d0d724a7c8aa619 ]---
[    5.259234] disabling CONFIG_USB_DEVICE_CLASS might fix this

[...]

[    5.347825] WARNING: at fs/sysfs/dir.c:427 sysfs_add_one+0x33/0x9a()
[    5.347829] Modules linked in: floppy ohci1394(+) ieee1394
pata_amd(+) 3c59x(+) mii libata ehci_hcd(+) ohci_hcd(+) forcedeth
usbcore ssb thermal processor fan fuse
[    5.347855] Pid: 1117, comm: modprobe Tainted: G        W 2.6.25-mm1 #7
[    5.347862]  [<c012883a>] warn_on_slowpath+0x41/0x67
[    5.347879]  [<c0128919>] ? test_ti_thread_flag+0xf/0x11
[    5.347888]  [<c01292c7>] ? vprintk+0x3ab/0x3c2
[    5.347902]  [<c0189b66>] ? ifind+0x16/0x5f
[    5.347914]  [<c02d7450>] ? _spin_unlock+0x38/0x44
[    5.347926]  [<c0189ba5>] ? ifind+0x55/0x5f
[    5.347933]  [<c01b2410>] ? sysfs_ilookup_test+0x0/0x11
[    5.347942]  [<c01292f3>] ? printk+0x15/0x17
[    5.347950]  [<c01b2703>] sysfs_add_one+0x33/0x9a
[    5.347958]  [<c01b331e>] sysfs_create_link+0xa7/0xd1
[    5.347968]  [<c0259fef>] device_add+0x123/0x405
[    5.347984]  [<c025a2e3>] device_register+0x12/0x15
[    5.347992]  [<c025a35b>] device_create+0x75/0x9a
[    5.348000]  [<f8893dc7>] usb_classdev_notify+0x40/0x72 [usbcore]
[    5.348039]  [<c013cbae>] notifier_call_chain+0x2b/0x4a
[    5.348052]  [<c013cd51>] __blocking_notifier_call_chain+0x37/0x4c
[    5.348063]  [<c013cd72>] blocking_notifier_call_chain+0xc/0xe
[    5.348071]  [<f8893fa4>] usb_notify_add_device+0x14/0x16 [usbcore]
[    5.348095]  [<f889424c>] generic_probe+0x77/0x83 [usbcore]
[    5.348120]  [<f888ee7c>] usb_probe_device+0x32/0x38 [usbcore]
[    5.348141]  [<c025b8a2>] driver_probe_device+0xa0/0x11b
[    5.348150]  [<c025b984>] __device_attach+0x8/0xa
[    5.348156]  [<c025b060>] bus_for_each_drv+0x39/0x63
[    5.348165]  [<c025b9f6>] device_attach+0x51/0x67
[    5.348171]  [<c025b97c>] ? __device_attach+0x0/0xa
[    5.348179]  [<c025af18>] bus_attach_device+0x24/0x4e
[    5.348186]  [<c025a190>] device_add+0x2c4/0x405
[    5.348198]  [<f8888ee1>] usb_new_device+0x4d/0x83 [usbcore]
[    5.348219]  [<f888ba9e>] usb_add_hcd+0x420/0x55f [usbcore]
[    5.348243]  [<c028191f>] ? pcibios_set_master+0x78/0x81
[    5.348256]  [<f88947cf>] usb_hcd_pci_probe+0x252/0x30b [usbcore]
[    5.348281]  [<c01fe704>] pci_device_probe+0x39/0x59
[    5.348291]  [<c025b8a2>] driver_probe_device+0xa0/0x11b
[    5.348299]  [<c025b95a>] __driver_attach+0x3d/0x5f
[    5.348306]  [<c025b2aa>] bus_for_each_dev+0x3e/0x60
[    5.348316]  [<c025b739>] driver_attach+0x14/0x16
[    5.348322]  [<c025b91d>] ? __driver_attach+0x0/0x5f
[    5.348329]  [<c025ad51>] bus_add_driver+0x9d/0x1ad
[    5.348337]  [<c025baa3>] driver_register+0x47/0xa3
[    5.348343]  [<c01f944e>] ? __spin_lock_init+0x24/0x48
[    5.348354]  [<c01fe8e3>] __pci_register_driver+0x53/0x80
[    5.348362]  [<f8831017>] ehci_hcd_init+0x17/0x19 [ehci_hcd]
[    5.348374]  [<c014af69>] sys_init_module+0x15e5/0x177b
[    5.348394]  [<f8864000>] ? amd_init+0x0/0x19 [pata_amd]
[    5.348408]  [<f8887790>] ? usb_root_hub_lost_power+0x0/0x2f [usbcore]
[    5.348439]  [<c0106c32>] syscall_call+0x7/0xb
[    5.348453]  =======================
[    5.348457] ---[ end trace 3d0d724a7c8aa619 ]---
[    5.348461] disabling CONFIG_USB_DEVICE_CLASS might fix this
