Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbYDCNzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbYDCNzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYDCNzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:55:09 -0400
Received: from smtp25.orange.fr ([193.252.22.23]:33084 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYDCNzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:55:07 -0400
X-ME-UUID: 20080403135505577.8D09B1C00082@mwinf2557.orange.fr
Subject: PnP: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
From: Xavier Bestel <xavier.bestel@free.fr>
To: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 15:54:56 +0200
Message-Id: <1207230896.3438.1.camel@skunk.anacadf.mentorg.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know some of these have been reported, but I couldn't find one in the
PnP subsystem.


Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Probing PCI hardware
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-1-686 #1
 [<c01b12f8>] sysfs_add_one+0x54/0xb8
 [<c01b1ee2>] sysfs_create_link+0xaf/0xfd
 [<c01e7070>] pci_bus_add_devices+0xba/0xff
 [<c0253589>] pcibios_scan_root+0x25/0x80
 [<c01251d5>] printk+0x1b/0x1f
 [<c0394d9c>] pci_legacy_init+0x53/0xe1
 [<c0377497>] kernel_init+0x153/0x2c6
 [<c0103d92>] ret_from_fork+0x6/0x1c
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-1-686 #1
 [<c01b12f8>] sysfs_add_one+0x54/0xb8
 [<c01b1ee2>] sysfs_create_link+0xaf/0xfd
 [<c01e7070>] pci_bus_add_devices+0xba/0xff
 [<c0394d9c>] pci_legacy_init+0x53/0xe1
 [<c0377497>] kernel_init+0x153/0x2c6
 [<c0103d92>] ret_from_fork+0x6/0x1c
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:1c.0: Error creating sysfs bridge symlink, continuing...
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-1-686 #1
 [<c01b12f8>] sysfs_add_one+0x54/0xb8
 [<c01b1ee2>] sysfs_create_link+0xaf/0xfd
 [<c01e7070>] pci_bus_add_devices+0xba/0xff
 [<c0394d9c>] pci_legacy_init+0x53/0xe1
 [<c0377497>] kernel_init+0x153/0x2c6
 [<c0103d92>] ret_from_fork+0x6/0x1c
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:1c.4: Error creating sysfs bridge symlink, continuing...
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-1-686 #1
 [<c01b12f8>] sysfs_add_one+0x54/0xb8
 [<c01b1ee2>] sysfs_create_link+0xaf/0xfd
 [<c01e7070>] pci_bus_add_devices+0xba/0xff
 [<c0394d9c>] pci_legacy_init+0x53/0xe1
 [<c0377497>] kernel_init+0x153/0x2c6
 [<c0103d92>] ret_from_fork+0x6/0x1c
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:1c.5: Error creating sysfs bridge symlink, continuing...
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-1-686 #1
 [<c01b12f8>] sysfs_add_one+0x54/0xb8
 [<c01b1ee2>] sysfs_create_link+0xaf/0xfd
 [<c01e7070>] pci_bus_add_devices+0xba/0xff
 [<c0394d9c>] pci_legacy_init+0x53/0xe1
 [<c0377497>] kernel_init+0x153/0x2c6
 [<c0103d92>] ret_from_fork+0x6/0x1c
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0377344>] kernel_init+0x0/0x2c6
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:1e.0: Error creating sysfs bridge symlink, continuing...



