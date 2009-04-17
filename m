Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZDQJNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZDQJNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbZDQJNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:13:12 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44827 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbZDQJNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=UCHz5ie8990tFnxrB6uBFgtN3f/WdUJMFrdR3k8ZeovzlthuEgQdxLWj+5RXiQZoC7
         tHouK8JF2o6DX6uYHG66r6GHxv9y0mx1yGuqHtZbuzhjtLFNymTykaciYiia4pzMXuB5
         6nauon8vQmA53yhX+tb0CLa3uj4KR3bMgnBFM=
MIME-Version: 1.0
Date: Fri, 17 Apr 2009 11:13:08 +0200
Message-ID: <c4e36d110904170213q24c2688ag9bcaa8562dddaa3f@mail.gmail.com>
Subject: WARNING: at fs/sysfs/group.c:138 sysfs_remove_group
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


When I've checked  2.6.30-rc2 kernel and  I've got among other errors
with Wifi message below.
As I've noticed - some people were reporting this problem already earlier:

http://www.gossamer-threads.com/lists/linux/kernel/1058276?page=last

But for me - it started with 2.6.30-rc kernels.
I've T61, 4GB, C2D, X86_64.



Zdenek


platform microcode: firmware: requesting intel-ucode/06-0f-0a
platform microcode: firmware: requesting intel-ucode/06-0f-0a
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x10b/0x110()
Hardware name: 6464CTO
sysfs group ffffffffa038d900 not found for kobject 'cpu0'
Modules linked in: microcode(-) binfmt_misc dm_mirror dm_region_hash
dm_log dm_mod kvm_intel kvm i915 dr
m i2c_algo_bit uinput btusb bluetooth arc4 ecb cryptomgr aead
pcompress thinkpad_acpi snd_hda_codec_analog crypto_blkcipher
crypto_hash snd_hda_intel cry
pto_algapi snd_hda_codec iwl3945 snd_seq_oss iwlcore
snd_seq_midi_event mac80211 snd_seq rfkill backlight i2c_i801 psmouse
intel_agp snd_seq_device snd_p
cm_oss rtc_cmos rtc_core sr_mod cdrom i2c_core sdhci_pci sdhci
mmc_core serio_raw led_class iTCO_wdt iTCO_vendor_support nvram
cfg80211 snd_mixer_oss e10
00e rtc_lib snd_pcm snd_timer snd evdev soundcore button ac battery
snd_page_alloc uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
scsi_wait_scan]
Pid: 1983, comm: rmmod Not tainted 2.6.30-rc2-00076-g3ee8da8 #51
Call Trace:
 [<ffffffff802434bf>] warn_slowpath+0xaf/0xf0
 [<ffffffff8039c3dd>] ? kobject_release+0x5d/0xa0
 [<ffffffff80333f7b>] sysfs_remove_group+0x10b/0x110
 [<ffffffffa038b3f8>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff8043c08f>] sysdev_driver_unregister+0x5f/0xa0
 [<ffffffffa038bee8>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026e974>] sys_delete_module+0x1b4/0x280
 [<ffffffff8039ff18>] ? __up_write+0xd8/0x150
 [<ffffffff8053e35f>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8020c19b>] system_call_fastpath+0x16/0x1b

WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x10b/0x110()
Hardware name: 6464CTO
sysfs group ffffffffa038d900 not found for kobject 'cpu1'
Modules linked in: microcode(-) binfmt_misc dm_mirror dm_region_hash
dm_log dm_mod kvm_intel kvm i915 dr
m i2c_algo_bit uinput btusb bluetooth arc4 ecb cryptomgr aead
pcompress thinkpad_acpi snd_hda_codec_analog crypto_blkcipher
crypto_hash snd_hda_intel cry
pto_algapi snd_hda_codec iwl3945 snd_seq_oss iwlcore
snd_seq_midi_event mac80211 snd_seq rfkill backlight i2c_i801 psmouse
intel_agp snd_seq_device snd_p
cm_oss rtc_cmos rtc_core sr_mod cdrom i2c_core sdhci_pci sdhci
mmc_core serio_raw led_class iTCO_wdt iTCO_vendor_support nvram
cfg80211 snd_mixer_oss e10
00e rtc_lib snd_pcm snd_timer snd evdev soundcore button ac battery
snd_page_alloc uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
scsi_wait_scan]
Pid: 1983, comm: rmmod Tainted: G        W  2.6.30-rc2-00076-g3ee8da8 #51
Call Trace:
 [<ffffffff802434bf>] warn_slowpath+0xaf/0xf0
 [<ffffffff802397b6>] ? finish_task_switch+0x56/0x110
 [<ffffffff8053bc77>] ? thread_return+0x3e/0x707
 [<ffffffff80333f7b>] sysfs_remove_group+0x10b/0x110
 [<ffffffffa038b3f8>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff8043c08f>] sysdev_driver_unregister+0x5f/0xa0
 [<ffffffffa038bee8>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026e974>] sys_delete_module+0x1b4/0x280
 [<ffffffff8039ff18>] ? __up_write+0xd8/0x150
 [<ffffffff8053e35f>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8020c19b>] system_call_fastpath+0x16/0x1b
---[ end trace 5eaaec53f6843efd ]---
Microcode Update Driver: v2.00 removed.
