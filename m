Return-Path: <linux-kernel-owner+w=401wt.eu-S934189AbXCVS4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbXCVS4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934192AbXCVS4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:56:15 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62305 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934189AbXCVS4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:56:13 -0400
Message-ID: <4602D137.4060402@lwfinger.net>
Date: Thu, 22 Mar 2007 13:55:51 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>	<1174433034.62033.16.camel@localhost>	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>	<4601761F.4000302@lwfinger.net>	<20070321185900.GC3801@tuxdriver.com>	<20070321202225.GN10459@waste.org>	<20070321233917.0393dfd1.akpm@linux-foundation.org>	<20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>	<4602752A.5050109@lwfinger.net> <20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------030305070904090306040907"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030305070904090306040907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Cornelia Huck wrote:
> On Thu, 22 Mar 2007 07:23:06 -0500,
> 
> This would indicate that dev_uevent had been called. But how could
> kobject_uevent then return an error without moaning about an uevent()
> error code? Maybe the following debug patch could shed some light on
> this (all moaning is prefixed with kobject_uevent_env, so it should be
> easy to spot)...

I applied the debug patch, but I don't see any error codes being returned. This time I also got the
General Protection Faults. An excerpt of the log is attached.

Thanks,

Larry

--------------030305070904090306040907
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages"

Mar 22 13:01:21 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
Mar 22 13:01:21 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:21 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:21 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:21 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:21 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:21 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:21 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:21 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:21 larrylap2 kernel: firmware_loading_store: unexpected value (0)
Mar 22 13:01:21 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:21 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:21 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:21 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:21 larrylap2 kernel: kobject 0000:01:00.0: cleaning up
Mar 22 13:01:21 larrylap2 kernel: bcm43xx: Error: PCM "bcm43xx_pcm5.fw" not available or load failed.
Mar 22 13:01:21 larrylap2 kernel: bcm43xx: core_up for active 802.11 core failed (-2)
Mar 22 13:01:45 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
Mar 22 13:01:45 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:45 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:45 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:45 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:45 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:45 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:45 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:45 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:46 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
Mar 22 13:01:46 larrylap2 kernel: firmware_loading_store: unexpected value (0)
Mar 22 13:01:46 larrylap2 kernel: kobject 0000:01:00.0: cleaning up
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:01:46 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:01:46 larrylap2 kernel: kobject 0000:01:00.0: cleaning up
Mar 22 13:01:46 larrylap2 kernel: bcm43xx: Error: PCM "bcm43xx_pcm5.fw" not available or load failed.
Mar 22 13:01:46 larrylap2 kernel: bcm43xx: core_up for active 802.11 core failed (-2)
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: cleaning up
Mar 22 13:02:10 larrylap2 kernel: general protection fault: 0000 [2] SMP 
Mar 22 13:02:10 larrylap2 kernel: last sysfs file: class/firmware/0000:01:00.0/loading
Mar 22 13:02:10 larrylap2 kernel: CPU 0 
Mar 22 13:02:10 larrylap2 kernel: Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table button battery ac nls_utf8 ntfs loop nfsd exportfs nfs lockd nfs_acl sunrpc sr_mod usb_storage libusual snd_hda_intel snd_hda_codec snd_pcm snd_timer snd ohci1394 sdhci ieee1394 soundcore mmc_core snd_page_alloc forcedeth ehci_hcd ide_cd cdrom ohci_hcd usbcore i2c_nforce2 bcm43xx firmware_class ieee80211softmac ieee80211 ieee80211_crypt ext3 mbcache jbd edd sg fan sata_nv libata amd74xx thermal processor sd_mod scsi_mod ide_disk ide_core
Mar 22 13:02:10 larrylap2 kernel: Pid: 4178, comm: cat Not tainted 2.6.21-rc4-mm1-mm1 #14
Mar 22 13:02:10 larrylap2 kernel: RIP: 0010:[<ffffffff80251f99>]  [<ffffffff80251f99>] module_put+0x1f/0x35
Mar 22 13:02:10 larrylap2 kernel: RSP: 0018:ffff810009161ea8  EFLAGS: 00010256
Mar 22 13:02:10 larrylap2 kernel: RAX: 6b6b6b6b6b6b6dab RBX: ffff810005e0c420 RCX: ffffffff803f6183
Mar 22 13:02:10 larrylap2 kernel: RDX: 0000000000000001 RSI: ffffffff802ec409 RDI: 6b6b6b6b6b6b6b6b
Mar 22 13:02:10 larrylap2 kernel: RBP: ffff810009161ea8 R08: 0000000000000000 R09: ffff81000879a888
Mar 22 13:02:10 larrylap2 kernel: R10: 0000000000000000 R11: ffffffff8811b020 R12: ffff810007c7d000
Mar 22 13:02:10 larrylap2 kernel: R13: ffff8100089c86f8 R14: ffff8100082ba048 R15: ffff8100034017c0
Mar 22 13:02:10 larrylap2 kernel: FS:  00002adf2d6ee6f0(0000) GS:ffffffff8051e000(0000) knlGS:00000000f70776d0
Mar 22 13:02:10 larrylap2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 22 13:02:10 larrylap2 kernel: CR2: 00002adf2d4133c0 CR3: 0000000009146000 CR4: 00000000000006e0
Mar 22 13:02:10 larrylap2 kernel: Process cat (pid: 4178, threadinfo ffff810009160000, task ffff810004d94080)
Mar 22 13:02:10 larrylap2 kernel: Stack:  ffff810009161ec8 ffffffff802cf4ba 0000000000000008 ffff8100082ba048
Mar 22 13:02:10 larrylap2 kernel:  ffff810009161f08 ffffffff80290a44 ffff8100086c2390 ffff8100089c86f8
Mar 22 13:02:10 larrylap2 kernel:  ffff810003590368 0000000000000000 ffff8100089c86f8 00007fff7d91b2d0
Mar 22 13:02:10 larrylap2 kernel: Call Trace:
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff802cf4ba>] release+0x3a/0x49
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff80290a44>] __fput+0xca/0x180
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff80290b0e>] fput+0x14/0x16
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff8028e1aa>] filp_close+0x66/0x71
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff8028f3c2>] sys_close+0x98/0xdd
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff80209f6e>] system_call+0x7e/0x83
Mar 22 13:02:10 larrylap2 kernel: 
Mar 22 13:02:10 larrylap2 kernel: 
Mar 22 13:02:10 larrylap2 kernel: Code: 48 ff 08 83 3f 02 75 0c 48 8b bf 50 22 00 00 e8 08 9d fd ff 
Mar 22 13:02:10 larrylap2 kernel: RIP  [<ffffffff80251f99>] module_put+0x1f/0x35
Mar 22 13:02:10 larrylap2 kernel:  RSP <ffff810009161ea8>
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: cleaning up
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: firmware_loading_store: unexpected value (0)
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: cleaning up
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: registering. parent: firmware, set: devices
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: 0000:01:00.0
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/class/firmware/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:01:00.0'
Mar 22 13:02:10 larrylap2 kernel: kobject_uevent_env: returning 0
Mar 22 13:02:10 larrylap2 kernel: bcm43xx: Error: InitVals "bcm43xx_initval06.fw" not available or load failed.
Mar 22 13:02:10 larrylap2 kernel: bcm43xx: core_up for active 802.11 core failed (-2)
Mar 22 13:02:10 larrylap2 kernel: kobject 0000:01:00.0: cleaning up
Mar 22 13:02:10 larrylap2 kernel: general protection fault: 0000 [3] SMP 
Mar 22 13:02:10 larrylap2 kernel: last sysfs file: class/firmware/0000:01:00.0/loading
Mar 22 13:02:10 larrylap2 kernel: CPU 0 
Mar 22 13:02:10 larrylap2 kernel: Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table button battery ac nls_utf8 ntfs loop nfsd exportfs nfs lockd nfs_acl sunrpc sr_mod usb_storage libusual snd_hda_intel snd_hda_codec snd_pcm snd_timer snd ohci1394 sdhci ieee1394 soundcore mmc_core snd_page_alloc forcedeth ehci_hcd ide_cd cdrom ohci_hcd usbcore i2c_nforce2 bcm43xx firmware_class ieee80211softmac ieee80211 ieee80211_crypt ext3 mbcache jbd edd sg fan sata_nv libata amd74xx thermal processor sd_mod scsi_mod ide_disk ide_core
Mar 22 13:02:10 larrylap2 kernel: Pid: 4199, comm: cat Not tainted 2.6.21-rc4-mm1-mm1 #14
Mar 22 13:02:10 larrylap2 kernel: RIP: 0010:[<ffffffff80251f99>]  [<ffffffff80251f99>] module_put+0x1f/0x35
Mar 22 13:02:10 larrylap2 kernel: RSP: 0018:ffff810008bfdea8  EFLAGS: 00010256
Mar 22 13:02:10 larrylap2 kernel: RAX: 6b6b6b6b6b6b6dab RBX: ffff8100070eb308 RCX: ffffffff803f6183
Mar 22 13:02:10 larrylap2 kernel: RDX: 0000000000000001 RSI: ffffffff802ec409 RDI: 6b6b6b6b6b6b6b6b
Mar 22 13:02:10 larrylap2 kernel: RBP: ffff810008bfdea8 R08: 0000000000000000 R09: ffff810008745338
Mar 22 13:02:10 larrylap2 kernel: R10: 0000000000000000 R11: ffffffff8811b020 R12: ffff81000999c000
Mar 22 13:02:10 larrylap2 kernel: R13: ffff8100089945a8 R14: ffff81000883e828 R15: ffff8100034017c0
Mar 22 13:02:10 larrylap2 kernel: FS:  00002b325c21c6f0(0000) GS:ffffffff8051e000(0000) knlGS:00000000f70776d0
Mar 22 13:02:10 larrylap2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 22 13:02:10 larrylap2 kernel: CR2: 00002b325bf413c0 CR3: 0000000005a02000 CR4: 00000000000006e0
Mar 22 13:02:10 larrylap2 kernel: Process cat (pid: 4199, threadinfo ffff810008bfc000, task ffff810006b78140)
Mar 22 13:02:10 larrylap2 kernel: Stack:  ffff810008bfdec8 ffffffff802cf4ba 0000000000000008 ffff81000883e828
Mar 22 13:02:10 larrylap2 kernel:  ffff810008bfdf08 ffffffff80290a44 ffff8100086c26a8 ffff8100089945a8
Mar 22 13:02:10 larrylap2 kernel:  ffff810009010050 0000000000000000 ffff8100089945a8 00007fff4edeb7a0
Mar 22 13:02:10 larrylap2 kernel: Call Trace:
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff802cf4ba>] release+0x3a/0x49
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff80290a44>] __fput+0xca/0x180
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff80290b0e>] fput+0x14/0x16
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff8028e1aa>] filp_close+0x66/0x71
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff8028f3c2>] sys_close+0x98/0xdd
Mar 22 13:02:10 larrylap2 kernel:  [<ffffffff80209f6e>] system_call+0x7e/0x83
Mar 22 13:02:10 larrylap2 kernel: 
Mar 22 13:02:10 larrylap2 kernel: 
Mar 22 13:02:10 larrylap2 kernel: Code: 48 ff 08 83 3f 02 75 0c 48 8b bf 50 22 00 00 e8 08 9d fd ff 
Mar 22 13:02:10 larrylap2 kernel: RIP  [<ffffffff80251f99>] module_put+0x1f/0x35
Mar 22 13:02:10 larrylap2 kernel:  RSP <ffff810008bfdea8>

--------------030305070904090306040907--
