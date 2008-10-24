Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYJXVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYJXVlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYJXVlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:41:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJXVln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:41:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: WARNING on 2.6.27-rc9: sysfs: duplicate filename 'usbdev5.5_ep89' can not be created
Date: Fri, 24 Oct 2008 23:46:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <E1KnKmy-0006EN-Ai@closure.thunk.org>
In-Reply-To: <E1KnKmy-0006EN-Ai@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242346.12025.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 of October 2008, Theodore Ts'o wrote:
> 
> I'm getting a whole series of warnings running 2.6.27-rc9.  I haven't
> seen them before, but then again it's been a while since I've tried
> charging my Blackberry via the USB port, which is apparently what
> triggered this.  Seems to be mostly harmless, other than dirtying up my
> logs.  :-)
> 
> Is this a known problem?

Is this still a problem?  Has it been fixed in 2.6.27?

Rafael

 
> [87465.889737] ------------[ cut here ]------------
> [87465.889740] WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x2f/0x3b()
> [87465.889743] sysfs: duplicate filename 'usbdev5.5_ep89' can not be created
> [87465.889746] Modules linked in: esp4 xfrm4_mode_tunnel dummy usb_storage libusual berry_charge btusb bluetooth uhci_hcd ehci_hcd usbcore af_packet i915 kvm_intel camellia blowfish af_key snd_hda_intel snd_hwdep video output intel_agp ide_pci_generic piix ide_core sg ata_piix ata_generic dm_mirror dm_log dm_snapshot dm_mod
> [87465.889797] Pid: 10, comm: events/1 Tainted: G        W 2.6.27-rc8-00145-g4b882d3 #71
> [87465.889802]  [<c013c839>] warn_slowpath+0x53/0x76
> [87465.889810]  [<c0158e2f>] ? print_lock_contention_bug+0x11/0xa8
> [87465.889818]  [<c0158e2f>] ? print_lock_contention_bug+0x11/0xa8
> [87465.889825]  [<c01e49d4>] ? sysfs_addrm_start+0x5c/0x8e
> [87465.889832]  [<c01e48a5>] ? sysfs_find_dirent+0x1b/0x2c
> [87465.889838]  [<c01e496c>] sysfs_add_one+0x2f/0x3b
> [87465.889843]  [<c01e4e45>] create_dir+0x48/0x6d
> [87465.889848]  [<c01e4e9c>] sysfs_create_dir+0x32/0x46
> [87465.889854]  [<c046aa96>] ? _spin_unlock+0x22/0x25
> [87465.889861]  [<c02b9b8f>] kobject_add_internal+0xb3/0x157
> [87465.889869]  [<c02b9cde>] kobject_add_varg+0x35/0x41
> [87465.889874]  [<c02ba046>] kobject_add+0x49/0x4f
> [87465.889879]  [<c032f571>] device_add+0x8a/0x4d6
> [87465.889885]  [<c032f9d4>] device_register+0x17/0x1a
> [87465.889890]  [<f8e6bea6>] usb_create_ep_files+0x1f3/0x261 [usbcore]
> [87465.889917]  [<f8e6b4d4>] usb_create_sysfs_intf_files+0x69/0x7e [usbcore]
> [87465.889939]  [<f8e67e57>] usb_set_configuration+0x40d/0x42a [usbcore]
> [87465.889960]  [<f8e67e9b>] driver_set_config_work+0x27/0x47 [usbcore]
> [87465.889982]  [<c014a7df>] run_workqueue+0xc7/0x197
> [87465.889988]  [<c014a79d>] ? run_workqueue+0x85/0x197
> [87465.889994]  [<f8e67e74>] ? driver_set_config_work+0x0/0x47 [usbcore]
> [87465.890016]  [<c014b26c>] worker_thread+0xbb/0xc7
> [87465.890022]  [<c014d9a9>] ? autoremove_wake_function+0x0/0x35
> [87465.890029]  [<c014b1b1>] ? worker_thread+0x0/0xc7
> [87465.890035]  [<c014d8be>] kthread+0x40/0x66
> [87465.890040]  [<c014d87e>] ? kthread+0x0/0x66
> [87465.890046]  [<c01157f7>] kernel_thread_helper+0x7/0x10
> [87465.890051]  =======================
> [87465.890054] ---[ end trace fb54349569d4deee ]---
> [87465.890060] kobject_add_internal failed for usbdev5.5_ep89 with -EEXIST, don't try to register things with the same name in the same directory.
> [87465.890065] Pid: 10, comm: events/1 Tainted: G        W 2.6.27-rc8-00145-g4b882d3 #71
> [87465.890069]  [<c02b9bfb>] kobject_add_internal+0x11f/0x157
> [87465.890074]  [<c02b9cde>] kobject_add_varg+0x35/0x41
> [87465.890080]  [<c02ba046>] kobject_add+0x49/0x4f
> [87465.890085]  [<c032f571>] device_add+0x8a/0x4d6
> [87465.890090]  [<c032f9d4>] device_register+0x17/0x1a
> [87465.890095]  [<f8e6bea6>] usb_create_ep_files+0x1f3/0x261 [usbcore]
> [87465.890119]  [<f8e6b4d4>] usb_create_sysfs_intf_files+0x69/0x7e [usbcore]
> [87465.890140]  [<f8e67e57>] usb_set_configuration+0x40d/0x42a [usbcore]
> [87465.890161]  [<f8e67e9b>] driver_set_config_work+0x27/0x47 [usbcore]
> [87465.890181]  [<c014a7df>] run_workqueue+0xc7/0x197
> [87465.890187]  [<c014a79d>] ? run_workqueue+0x85/0x197
> [87465.890193]  [<f8e67e74>] ? driver_set_config_work+0x0/0x47 [usbcore]
> [87465.890216]  [<c014b26c>] worker_thread+0xbb/0xc7
> [87465.890221]  [<c014d9a9>] ? autoremove_wake_function+0x0/0x35
> [87465.890228]  [<c014b1b1>] ? worker_thread+0x0/0xc7
> [87465.890233]  [<c014d8be>] kthread+0x40/0x66
> [87465.890238]  [<c014d87e>] ? kthread+0x0/0x66
> [87465.890245]  [<c01157f7>] kernel_thread_helper+0x7/0x10
> [87465.890250]  =======================
> [87465.890262] ------------[ cut here ]------------
> [87465.890266] WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x2f/0x3b()
> [87465.890269] sysfs: duplicate filename 'usbdev5.5_ep0a' can not be created
> [87465.890271] Modules linked in: esp4 xfrm4_mode_tunnel dummy usb_storage libusual berry_charge btusb bluetooth uhci_hcd ehci_hcd usbcore af_packet i915 kvm_intel camellia blowfish af_key snd_hda_intel snd_hwdep video output intel_agp ide_pci_generic piix ide_core sg ata_piix ata_generic dm_mirror dm_log dm_snapshot dm_mod
> [87465.890316] Pid: 10, comm: events/1 Tainted: G        W 2.6.27-rc8-00145-g4b882d3 #71
> [87465.890319]  [<c013c839>] warn_slowpath+0x53/0x76
> [87465.890326]  [<c0158e2f>] ? print_lock_contention_bug+0x11/0xa8
> [87465.890333]  [<c01e49d4>] ? sysfs_addrm_start+0x5c/0x8e
> [87465.890339]  [<c01e48a5>] ? sysfs_find_dirent+0x1b/0x2c
> [87465.890346]  [<c01e496c>] sysfs_add_one+0x2f/0x3b
> [87465.890351]  [<c01e4e45>] create_dir+0x48/0x6d
> [87465.890356]  [<c01e4e9c>] sysfs_create_dir+0x32/0x46
> [87465.890361]  [<c046aa96>] ? _spin_unlock+0x22/0x25
> [87465.890366]  [<c02b9b8f>] kobject_add_internal+0xb3/0x157
> [87465.890372]  [<c02b9cde>] kobject_add_varg+0x35/0x41
> [87465.890377]  [<c02ba046>] kobject_add+0x49/0x4f
> [87465.890381]  [<c032f571>] device_add+0x8a/0x4d6
> [87465.890386]  [<c032f9d4>] device_register+0x17/0x1a
> [87465.890391]  [<f8e6bea6>] usb_create_ep_files+0x1f3/0x261 [usbcore]
> [87465.890414]  [<f8e6b4d4>] usb_create_sysfs_intf_files+0x69/0x7e [usbcore]
> [87465.890435]  [<f8e67e57>] usb_set_configuration+0x40d/0x42a [usbcore]
> [87465.890456]  [<f8e67e9b>] driver_set_config_work+0x27/0x47 [usbcore]
> [87465.890476]  [<c014a7df>] run_workqueue+0xc7/0x197
> [87465.890481]  [<c014a79d>] ? run_workqueue+0x85/0x197
> [87465.890487]  [<f8e67e74>] ? driver_set_config_work+0x0/0x47 [usbcore]
> [87465.890509]  [<c014b26c>] worker_thread+0xbb/0xc7
> [87465.890514]  [<c014d9a9>] ? autoremove_wake_function+0x0/0x35
> [87465.890520]  [<c014b1b1>] ? worker_thread+0x0/0xc7
> [87465.890526]  [<c014d8be>] kthread+0x40/0x66
> [87465.890531]  [<c014d87e>] ? kthread+0x0/0x66
> [87465.890537]  [<c01157f7>] kernel_thread_helper+0x7/0x10
> [87465.890542]  =======================
> [87465.890544] ---[ end trace fb54349569d4deee ]---
> [87465.890549] kobject_add_internal failed for usbdev5.5_ep0a with -EEXIST, don't try to register things with the same name in the same directory.
> [87465.890554] Pid: 10, comm: events/1 Tainted: G        W 2.6.27-rc8-00145-g4b882d3 #71
> [87465.890557]  [<c02b9bfb>] kobject_add_internal+0x11f/0x157
> [87465.890563]  [<c02b9cde>] kobject_add_varg+0x35/0x41
> [87465.890568]  [<c02ba046>] kobject_add+0x49/0x4f
> [87465.890573]  [<c032f571>] device_add+0x8a/0x4d6
> [87465.890578]  [<c032f9d4>] device_register+0x17/0x1a
> [87465.890582]  [<f8e6bea6>] usb_create_ep_files+0x1f3/0x261 [usbcore]
> [87465.890605]  [<f8e6b4d4>] usb_create_sysfs_intf_files+0x69/0x7e [usbcore]
> [87465.890626]  [<f8e67e57>] usb_set_configuration+0x40d/0x42a [usbcore]
> [87465.890647]  [<f8e67e9b>] driver_set_config_work+0x27/0x47 [usbcore]
> [87465.890668]  [<c014a7df>] run_workqueue+0xc7/0x197
> [87465.890673]  [<c014a79d>] ? run_workqueue+0x85/0x197
> [87465.890679]  [<f8e67e74>] ? driver_set_config_work+0x0/0x47 [usbcore]
> [87465.890701]  [<c014b26c>] worker_thread+0xbb/0xc7
> [87465.890707]  [<c014d9a9>] ? autoremove_wake_function+0x0/0x35
> [87465.890714]  [<c014b1b1>] ? worker_thread+0x0/0xc7
> [87465.890720]  [<c014d8be>] kthread+0x40/0x66
> [87465.890725]  [<c014d87e>] ? kthread+0x0/0x66
> [87465.890731]  [<c01157f7>] kernel_thread_helper+0x7/0x10
> [87465.890736]  =======================
> [87465.934658] scsi10 : SCSI emulation for USB Mass Storage devices
> [87465.961840] usb-storage: device found at 5
> [87465.961844] usb-storage: waiting for device to settle before scanning
> [87465.961847] ------------[ cut here ]------------
> [87465.961852] WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x2f/0x3b()
> [87465.961855] sysfs: duplicate filename 'usbdev5.5_ep89' can not be created
> [87465.961858] Modules linked in: esp4 xfrm4_mode_tunnel dummy usb_storage libusual berry_charge btusb bluetooth uhci_hcd ehci_hcd usbcore af_packet i915 kvm_intel camellia blowfish af_key snd_hda_intel snd_hwdep video output intel_agp ide_pci_generic piix ide_core sg ata_piix ata_generic dm_mirror dm_log dm_snapshot dm_mod
> [87465.961909] Pid: 10, comm: events/1 Tainted: G        W 2.6.27-rc8-00145-g4b882d3 #71
> [87465.961914]  [<c013c839>] warn_slowpath+0x53/0x76
> [87465.961922]  [<c0158e2f>] ? print_lock_contention_bug+0x11/0xa8
> [87465.961930]  [<c0158e2f>] ? print_lock_contention_bug+0x11/0xa8
> [87465.961937]  [<c01e49d4>] ? sysfs_addrm_start+0x5c/0x8e
> [87465.961944]  [<c01e48a5>] ? sysfs_find_dirent+0x1b/0x2c
> [87465.961950]  [<c01e496c>] sysfs_add_one+0x2f/0x3b
> [87465.961955]  [<c01e4e45>] create_dir+0x48/0x6d
> [87465.961960]  [<c01e4e9c>] sysfs_create_dir+0x32/0x46
> [87465.961965]  [<c046aa96>] ? _spin_unlock+0x22/0x25
> [87465.961972]  [<c02b9b8f>] kobject_add_internal+0xb3/0x157
> [87465.961979]  [<c02b9cde>] kobject_add_varg+0x35/0x41
> [87465.961984]  [<c02ba046>] kobject_add+0x49/0x4f
> [87465.961991]  [<c032f571>] device_add+0x8a/0x4d6
> [87465.961997]  [<c032f9d4>] device_register+0x17/0x1a
> [87465.962002]  [<f8e6bea6>] usb_create_ep_files+0x1f3/0x261 [usbcore]
> [87465.962028]  [<f8e6b4d4>] usb_create_sysfs_intf_files+0x69/0x7e [usbcore]
> [87465.962050]  [<f8e67e57>] usb_set_configuration+0x40d/0x42a [usbcore]
> [87465.962071]  [<f8e67e9b>] driver_set_config_work+0x27/0x47 [usbcore]
> [87465.962110]  [<c014a7df>] run_workqueue+0xc7/0x197
> [87465.962116]  [<c014a79d>] ? run_workqueue+0x85/0x197
> [87465.962122]  [<f8e67e74>] ? driver_set_config_work+0x0/0x47 [usbcore]
> [87465.962144]  [<c014b26c>] worker_thread+0xbb/0xc7
> [87465.962150]  [<c014d9a9>] ? autoremove_wake_function+0x0/0x35
> [87465.962157]  [<c014b1b1>] ? worker_thread+0x0/0xc7
> [87465.962163]  [<c014d8be>] kthread+0x40/0x66
> [87465.962168]  [<c014d87e>] ? kthread+0x0/0x66
> [87465.962174]  [<c01157f7>] kernel_thread_helper+0x7/0x10
> [87465.962180]  =======================
> [87465.962184] ---[ end trace fb54349569d4deee ]---
> [87465.962189] kobject_add_internal failed for usbdev5.5_ep89 with -EEXIST, don't try to register things with the same name in the same directory.
> [87465.962194] Pid: 10, comm: events/1 Tainted: G        W 2.6.27-rc8-00145-g4b882d3 #71
> [87465.962197]  [<c02b9bfb>] kobject_add_internal+0x11f/0x157
> [87465.962203]  [<c02b9cde>] kobject_add_varg+0x35/0x41
> [87465.962209]  [<c02ba046>] kobject_add+0x49/0x4f
> [87465.962213]  [<c032f571>] device_add+0x8a/0x4d6
> [87465.962219]  [<c032f9d4>] device_register+0x17/0x1a
> [87465.962224]  [<f8e6bea6>] usb_create_ep_files+0x1f3/0x261 [usbcore]
> [87465.962246]  [<f8e6b4d4>] usb_create_sysfs_intf_files+0x69/0x7e [usbcore]
> [87465.962268]  [<f8e67e57>] usb_set_configuration+0x40d/0x42a [usbcore]
> [87465.962289]  [<f8e67e9b>] driver_set_config_work+0x27/0x47 [usbcore]
> [87465.962309]  [<c014a7df>] run_workqueue+0xc7/0x197
> [87465.962314]  [<c014a79d>] ? run_workqueue+0x85/0x197
> [87465.962320]  [<f8e67e74>] ? driver_set_config_work+0x0/0x47 [usbcore]
> [87465.962342]  [<c014b26c>] worker_thread+0xbb/0xc7
> [87465.962348]  [<c014d9a9>] ? autoremove_wake_function+0x0/0x35
> [87465.962354]  [<c014b1b1>] ? worker_thread+0x0/0xc7
> [87465.962360]  [<c014d8be>] kthread+0x40/0x66
> [87465.962365]  [<c014d87e>] ? kthread+0x0/0x66
> [87465.962371]  [<c01157f7>] kernel_thread_helper+0x7/0x10
> [87465.962376]  =======================
> [87465.962389] ------------[ cut here ]------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


