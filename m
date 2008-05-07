Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbYEGWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbYEGWT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbYEGWSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:18:23 -0400
Received: from smtp.ono.com ([62.42.230.12]:35453 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765229AbYEGWST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:18:19 -0400
Date: Thu, 8 May 2008 00:18:15 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: A couple problems with -rc1-git5
Message-ID: <20080508001815.371ec9d3@werewolf.home>
X-Mailer: Claws Mail 3.4.0cvs16 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I built 2.6.26-rc1-git5 and foud a couple problems.

First, I get this warning on boot:

------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x100/0x112()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-jam05 #1
 [<c011e4f8>] warn_on_slowpath+0x4d/0x66
 [<c0132d78>] __atomic_notifier_call_chain+0x27/0x48
 [<c0132db0>] atomic_notifier_call_chain+0x17/0x1b
 [<c024b21c>] notify_update+0x1f/0x23
 [<c024b465>] vt_console_print+0x1dd/0x2a6
 [<c024b288>] vt_console_print+0x0/0x2a6
 [<c0132932>] up+0x9/0x2b
 [<c01f37f0>] init_tag_map+0x4e/0x95
 [<c01f3915>] __blk_queue_init_tags+0x27/0x4e
 [<c01f3aee>] blk_queue_init_tags+0x100/0x112
 [<c0284dd8>] ahd_platform_set_tags+0x179/0x1a8
 [<c02851c7>] ahd_linux_slave_configure+0xcd/0x131
 [<c025e90c>] scsi_probe_and_add_lun+0x706/0x966
 [<c025edcb>] __scsi_scan_target+0xd9/0x5d8
 [<c019d553>] sysfs_ilookup_test+0x0/0xd
 [<c019db0b>] sysfs_addrm_finish+0x14/0x1c6
 [<c019d85d>] sysfs_find_dirent+0x1e/0x27
 [<c019d8a1>] sysfs_add_one+0x3b/0x8b
 [<c019d2c9>] sysfs_add_file_mode+0x4d/0x76
 [<c019ec61>] internal_create_group+0xd7/0x196
 [<c032a382>] klist_next+0x53/0x90
 [<c025f342>] scsi_scan_channel+0x78/0x8d
 [<c025f3ff>] scsi_scan_host_selected+0xa8/0xd1
 [<c025f48f>] do_scsi_scan_host+0x67/0x69
 [<c0287363>] ahd_linux_register_host+0x266/0x2e3
 [<c0287c6f>] ahd_pci_map_int+0x2c/0x50
 [<c0280f5a>] ahd_pci_config+0x533/0x824
 [<c01fd606>] kobject_get+0xf/0x13
 [<c0252085>] get_device+0xe/0x14
 [<c02096ac>] pci_dev_get+0xf/0x13
 [<c0287efc>] ahd_linux_pci_dev_probe+0x139/0x17f
 [<c019db0b>] sysfs_addrm_finish+0x14/0x1c6
 [<c019d85d>] sysfs_find_dirent+0x1e/0x27
 [<c019d8a1>] sysfs_add_one+0x3b/0x8b
 [<c019e543>] sysfs_create_link+0x89/0x106
 [<c0209633>] pci_match_device+0x9c/0xad
 [<c0287dc3>] ahd_linux_pci_dev_probe+0x0/0x17f
 [<c02096f0>] pci_device_probe+0x40/0x5f
 [<c02545c3>] driver_probe_device+0x76/0x152
 [<c02546f5>] __driver_attach+0x56/0x58
 [<c0253de4>] bus_for_each_dev+0x3c/0x5a
 [<c0254486>] driver_attach+0x16/0x1a
 [<c025469f>] __driver_attach+0x0/0x58
 [<c025428d>] bus_add_driver+0x19c/0x21f
 [<c0209667>] pci_device_remove+0x0/0x36
 [<c025482e>] driver_register+0x4d/0x10f
 [<c02098dd>] __pci_register_driver+0x32/0x65
 [<c0418b9f>] ahd_linux_init+0x53/0x6f
 [<c04047a0>] kernel_init+0x11a/0x27f
 [<c011a438>] finish_task_switch+0x1f/0x6d
 [<c011a8c6>] schedule_tail+0x16/0x44
 [<c0102d32>] ret_from_fork+0x6/0x1c
 [<c0404686>] kernel_init+0x0/0x27f
 [<c0404686>] kernel_init+0x0/0x27f
 [<c0103a0f>] kernel_thread_helper+0x7/0x18
 =======================
---[ end trace 20d7bdfa512ea60e ]---

Second, lsscsi gives strange output:

werewolf:~# lsscsi
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
[target1:0:0]type?   vendor?  model?           rev?  -
[target1:0:1]type?   vendor?  model?           rev?  -
[target2:0:0]type?   vendor?  model?           rev?  -
[target2:0:1]type?   vendor?  model?           rev?  -
[target4:0:0]type?   vendor?  model?           rev?  -
[1:0:0:0]    disk    SEAGATE  ST336807LW       0C01  -
[1:0:1:0]    disk    SEAGATE  ST336807LW       0C01  -
[2:0:0:0]    disk    ATA      ST3120022A       3.06  -
[2:0:1:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL12  -
[4:0:0:0]    disk    ATA      WDC WD3200AVJS-6 12.0  -

What does this mean ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
