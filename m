Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYGYJxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYGYJxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYGYJxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:53:25 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:37278 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751220AbYGYJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:53:24 -0400
Date: Fri, 25 Jul 2008 15:23:17 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel NULL pointer dereference at 00000002
Message-ID: <20080725095317.GA12636@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  163.378265] BUG: unable to handle kernel NULL pointer dereference at 00000002
[  163.378276] IP: [<c0124933>] sched_power_savings_store+0x13/0x70
[  163.378288] *pde = 00000000
[  163.378294] Oops: 0000 [#1] SMP
[  163.378301] Modules linked in: ipv6 usbhid hid radeon drm rfcomm l2cap bluetooth kvm_intel kvm uinput ppdev autofs4 acpi_cpufreq cpufreq_conservative cpufreq_userspace c pufreq_ondemand cpufreq_stats freq_table cpufreq_powersave sbs sbshc container iptable_filter ip_tables x_tables dm_crypt dm_mod parport_pc lp parport joydev pcmcia iTCO_wd t serio_raw yenta_socket iTCO_vendor_support rsrc_nonstatic arc4 psmouse pcspkr ecb crypto_blkcipher pcmcia_core ac battery iwl3945 rfkill mac80211 cfg80211 snd_hda_intel e 1000e video output snd_pcm snd_timer snd soundcore snd_page_alloc button shpchp pci_hotplug intel_agp agpgart thinkpad_acpi led_class nvram evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic pata_acpi ata_piix ahci ehci_hcd uhci_hcd libata scsi_mod usbcore dock thermal processor fan thermal_sys fuse
 [  163.378431]
 [  163.378436] Pid: 6456, comm: sched-powersave Not tainted (2.6.26-00149-gc8988f9-dirty #6)
 [  163.378442] EIP: 0060:[<c0124933>] EFLAGS: 00010282 CPU: 0
 [  163.378448] EIP is at sched_power_savings_store+0x13/0x70
 [  163.378453] EAX: 00000002 EBX: 00000000 ECX: ffffffea EDX: f480a480
 [  163.378458] ESI: f480a480 EDI: f69a1000 EBP: c0430464 ESP: f6b15f40
 [  163.378463]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 [  163.378468] Process sched-powersave (pid: 6456, ti=f6b14000
 task=f6ad3720 task.ti=f6b14000)
 [  163.378473] Stack: c01249a0 c0430464 c027e329 f480a480 c0430158
 00000002 c01d8ca1 00000002
 [  163.378487]        f6ae8000 f69ae314 c0430158 f6ae8000 080fc408
 c01d8be0 00000002 c0191c3f
 [  163.378501]        f6b15fa0 f6ae8000 f6ae8000 fffffff7 080fc408
 f6b14000 c0192241 f6b15fa0
 [  163.378515] Call Trace:
 [  163.378519]  [<c01249a0>] sched_mc_power_savings_store+0x0/0x10
 [  163.378527]  [<c027e329>] sysdev_class_store+0x29/0x40
 [  163.378537]  [<c01d8ca1>] sysfs_write_file+0xc1/0x110
 [  163.378546]  [<c01d8be0>] sysfs_write_file+0x0/0x110
 [  163.378553]  [<c0191c3f>] vfs_write+0x9f/0x170
 [  163.378561]  [<c0192241>] sys_write+0x41/0x70
 [  163.378568]  [<c0103d6f>] sysenter_past_esp+0x78/0xb9
 [  163.378575]  [<c0320000>] set_cpu_sibling_map+0x1e0/0x2a0
 [  163.378584]  =======================
 [  163.378587] Code: ff 89 c3 b8 08 ed 41 c0 e8 5b ef 1f 00 e8 26 66 00
 00 89 d8 5b c3 66 90 83 ec 08 89 1c 24 89 cb b9 ea ff ff ff 89 74 24 04
 89 d6 <0f> b6 10 8d 42 d0 3c 01 76 13 8b 1c 24 89 c8 8b 74 24 04 83 c4 
 [  163.378662] EIP: [<c0124933>] sched_power_savings_store+0x13/0x70
 SS:ESP 0068:f6b15f40
 [  163.378673] ---[ end trace 90dd601c24cdd750 ]---

