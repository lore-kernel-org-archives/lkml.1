Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYJQQLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYJQQLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbYJQQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:11:41 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3449 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbYJQQLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:11:41 -0400
Date: Fri, 17 Oct 2008 18:11:37 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Cc: mochel@digitalimplant.org
Subject: [2.6.27] OOPS  WARNING: at fs/sysfs/group.c:138
	sysfs_remove_group+0x3e/0xa0()
Message-ID: <20081017161137.GQ22427@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Oct 11 11:14:03 CEST 2008
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running my rmmod/modprobe randomizer (http://vanheusden.com/pyk/ ) I got
the following OOPS:

 ------------[ cut here ]------------
 WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x3e/0xa0()
 sysfs group f8824b1c not found for kobject 'cpufreq'
 Modules linked in: e_powersaver pcspkr dm_snapshot dm_mod eeprom usbhid(+) snd_usb_audio snd_hwdep c7temp cpufreq_ondemand psmouse snd_pcm_oss snd_mixer_oss sata_via via_rng rng_core ide_cd_mod serio_raw button snd_usb_lib fan ppdev snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart padlock_aes crypto_blkcipher snd_hda_intel i2c_viapro parport_pc hwmon_vid sr_mod cpufreq_stats(-) aes_generic videodev rfcomm uhci_hcd via_velocity crc_ccitt parport sd_mod freq_table usbserial pci_hotplug cpufreq_userspace gameport v4l1_compat firewire_core ff_memless cdrom libata crc_itu_t hid evdev tun ipv6 nls_utf8 cifs nls_base nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc l2cap bluetooth snd_pcm snd_timer snd_page_alloc snd_rawmidi snd_seq_device snd soundcore i2c_core via_agp agpgart ext3 jbd mbcache ide_disk scsi_mod dock via_rhine via82cxxx mii usbcore ide_core thermal_sys [last unloaded: e_powersaver]
 Pid: 21201, comm: rmmod Not tainted 2.6.27-c7temp-100hz-ch341 #2
  [<c011e126>] warn_slowpath+0x4b/0x6c
  [<c0138e0c>] ? mark_held_locks+0x53/0x6a
  [<c0138fbc>] ? trace_hardirqs_on+0xb/0xd
  [<c0138f90>] ? trace_hardirqs_on_caller+0xe7/0x108
  [<c0138fbc>] ? trace_hardirqs_on+0xb/0xd
  [<c0138f90>] ? trace_hardirqs_on_caller+0xe7/0x108
  [<c0138fbc>] ? trace_hardirqs_on+0xb/0xd
  [<c01b400e>] sysfs_remove_group+0x3e/0xa0
  [<f8824316>] cpufreq_stats_exit+0x46/0x72 [cpufreq_stats]
  [<c014066c>] sys_delete_module+0x1a7/0x208
  [<c0160073>] ? shrink_active_list+0x16c/0x3e8
  [<c01680d6>] ? do_munmap+0x1db/0x1f5
  [<c01eab50>] ? trace_hardirqs_on_thunk+0xc/0x10
  [<c0103857>] sysenter_do_call+0x12/0x3f
  =======================
 ---[ end trace a49a8fac8db5df74 ]---


Folkert van Heusden

-- 
Ever wonder what is out there? Any alien races? Then please support
the seti@home project: setiathome.ssl.berkeley.edu
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
