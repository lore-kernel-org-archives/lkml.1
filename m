Return-Path: <linux-kernel-owner+w=401wt.eu-S1764560AbZDHPkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764560AbZDHPkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763968AbZDHPkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:40:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:41664 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800AbZDHPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=DXT/fIbASP+Uy9M/TE1UDx2Dgm9d6Q4irDnLpa4q5urHlxb2Sz0TkGXKnn7gbed4b4
         gZgRnpNJ5sB1fuCRnu4YCG8F4ufmVp/pmoFhtSkE5op62wx9Ij5G3eVcNYzPF4IqlV4g
         M+WjlBqt/Jy5A6gMAVBqs8QQdVWUSHyBypGeA=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 23:40:20 +0800
Message-ID: <d82e647a0904080840x7ef0b291m4f015e2c43bc5d03@mail.gmail.com>
Subject: 2.6.31-rc1: x86 microcode driver warning
From: Ming Lei <tom.leiming@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel version : 2.6.31-rc1 + acpi battery oops patch


[   16.551406] ------------[ cut here ]------------
[   16.551410] WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x4d/0xc6()
[   16.551413] Hardware name: Latitude D630
[   16.551416] sysfs group ffffffffa02b4d40 not found for kobject 'cpu0'
[   16.551418] Modules linked in: microcode(-) snd_hda_codec_idt
snd_hda_intel snd_hda_codec snd_hwdep snd_seq_device snd_pcm_oss
snd_mixer_oss snd_pcm snd_timer i2c_i801 i2c_core ohci1394 ieee1394
usbhid iwl3945 tg3 iwlcore mac80211 sg cfg80211 libphy snd
snd_page_alloc processor battery button ac thermal sr_mod cdrom evdev
dcdbas ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
[   16.551481] Pid: 3167, comm: rmmod Not tainted 2.6.30-rc1-dirty #89
[   16.551484] Call Trace:
[   16.551491]  [<ffffffff802404d1>] warn_slowpath+0xb1/0xed
[   16.551497]  [<ffffffff80262b6a>] ? get_lock_stats+0x14/0x4c
[   16.551503]  [<ffffffff80485b02>] ? mutex_unlock+0x9/0xb
[   16.551508]  [<ffffffff802644bf>] ? mark_held_locks+0x4d/0x6b
[   16.551512]  [<ffffffff80485acd>] ? __mutex_unlock_slowpath+0x124/0x150
[   16.551517]  [<ffffffff8026479f>] ? trace_hardirqs_on_caller+0x139/0x164
[   16.551521]  [<ffffffff802647d7>] ? trace_hardirqs_on+0xd/0xf
[   16.551527]  [<ffffffff80319cd5>] sysfs_remove_group+0x4d/0xc6
[   16.551534]  [<ffffffffa02b2414>] mc_sysdev_remove+0x4f/0x68 [microcode]
[   16.551540]  [<ffffffff803cd9e2>] sysdev_driver_unregister+0x5b/0x94
[   16.551546]  [<ffffffffa02b2eab>] microcode_exit+0x34/0x60 [microcode]
[   16.551551]  [<ffffffff8026f2b6>] sys_delete_module+0x1ca/0x245
[   16.551556]  [<ffffffff8026479f>] ? trace_hardirqs_on_caller+0x139/0x164
[   16.551561]  [<ffffffff80487a3d>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   16.551566]  [<ffffffff8020b142>] system_call_fastpath+0x16/0x1b
[   16.551570] ---[ end trace 562a06720ccbbb65 ]---
[   16.551576] ------------[ cut here ]------------
[   16.551579] WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x4d/0xc6()
[   16.551582] Hardware name: Latitude D630
[   16.551585] sysfs group ffffffffa02b4d40 not found for kobject 'cpu1'
[   16.551587] Modules linked in: microcode(-) snd_hda_codec_idt
snd_hda_intel snd_hda_codec snd_hwdep snd_seq_device snd_pcm_oss
snd_mixer_oss snd_pcm snd_timer i2c_i801 i2c_core ohci1394 ieee1394
usbhid iwl3945 tg3 iwlcore mac80211 sg cfg80211 libphy snd
snd_page_alloc processor battery button ac thermal sr_mod cdrom evdev
dcdbas ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
[   16.551646] Pid: 3167, comm: rmmod Tainted: G        W  2.6.30-rc1-dirty #89
[   16.551648] Call Trace:
[   16.551653]  [<ffffffff802404d1>] warn_slowpath+0xb1/0xed
[   16.551658]  [<ffffffff804863a9>] ? mutex_lock_nested+0x308/0x362
[   16.551663]  [<ffffffff80485a18>] ? __mutex_unlock_slowpath+0x6f/0x150
[   16.551668]  [<ffffffff8026368c>] ? trace_hardirqs_off+0xd/0xf
[   16.551672]  [<ffffffff80485acd>] ? __mutex_unlock_slowpath+0x124/0x150
[   16.551677]  [<ffffffff80264685>] ? trace_hardirqs_on_caller+0x1f/0x164
[   16.551681]  [<ffffffff802647d7>] ? trace_hardirqs_on+0xd/0xf
[   16.551686]  [<ffffffff80319cd5>] sysfs_remove_group+0x4d/0xc6
[   16.551692]  [<ffffffffa02b2414>] mc_sysdev_remove+0x4f/0x68 [microcode]
[   16.551697]  [<ffffffff803cd9e2>] sysdev_driver_unregister+0x5b/0x94
[   16.551703]  [<ffffffffa02b2eab>] microcode_exit+0x34/0x60 [microcode]
[   16.551707]  [<ffffffff8026f2b6>] sys_delete_module+0x1ca/0x245
[   16.551712]  [<ffffffff8026479f>] ? trace_hardirqs_on_caller+0x139/0x164
[   16.551717]  [<ffffffff80487a3d>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   16.551722]  [<ffffffff8020b142>] system_call_fastpath+0x16/0x1b
[   16.551725] ---[ end trace 562a06720ccbbb66 ]---
[   16.551730] PM: Removing info for platform:microcode
[   16.551974] bus: 'platform': remove device microcode
[   16.553880] Microcode Update Driver: v2.00 removed.


-- 
Lei Ming
