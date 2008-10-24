Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYJXWs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYJXWs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYJXWst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:48:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYJXWss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:48:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: [2.6.27] OOPS  WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x3e/0xa0()
Date: Sat, 25 Oct 2008 00:53:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mochel@digitalimplant.org
References: <20081017161137.GQ22427@vanheusden.com>
In-Reply-To: <20081017161137.GQ22427@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810250053.10325.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 17 of October 2008, Folkert van Heusden wrote:
> While running my rmmod/modprobe randomizer (http://vanheusden.com/pyk/ ) I got
> the following OOPS:

Is this reproducible with 2.6.26 and/or current mainline?

>  ------------[ cut here ]------------
>  WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x3e/0xa0()
>  sysfs group f8824b1c not found for kobject 'cpufreq'
>  Modules linked in: e_powersaver pcspkr dm_snapshot dm_mod eeprom usbhid(+) snd_usb_audio snd_hwdep c7temp cpufreq_ondemand psmouse snd_pcm_oss snd_mixer_oss sata_via via_rng rng_core ide_cd_mod serio_raw button snd_usb_lib fan ppdev snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart padlock_aes crypto_blkcipher snd_hda_intel i2c_viapro parport_pc hwmon_vid sr_mod cpufreq_stats(-) aes_generic videodev rfcomm uhci_hcd via_velocity crc_ccitt parport sd_mod freq_table usbserial pci_hotplug cpufreq_userspace gameport v4l1_compat firewire_core ff_memless cdrom libata crc_itu_t hid evdev tun ipv6 nls_utf8 cifs nls_base nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc l2cap bluetooth snd_pcm snd_timer snd_page_alloc snd_rawmidi snd_seq_device snd soundcore i2c_core via_agp agpgart ext3 jbd mbcache ide_disk scsi_mod dock via_rhine via82cxxx mii usbcore ide_core thermal_sys [last unloaded: e_powersaver]
>  Pid: 21201, comm: rmmod Not tainted 2.6.27-c7temp-100hz-ch341 #2
>   [<c011e126>] warn_slowpath+0x4b/0x6c
>   [<c0138e0c>] ? mark_held_locks+0x53/0x6a
>   [<c0138fbc>] ? trace_hardirqs_on+0xb/0xd
>   [<c0138f90>] ? trace_hardirqs_on_caller+0xe7/0x108
>   [<c0138fbc>] ? trace_hardirqs_on+0xb/0xd
>   [<c0138f90>] ? trace_hardirqs_on_caller+0xe7/0x108
>   [<c0138fbc>] ? trace_hardirqs_on+0xb/0xd
>   [<c01b400e>] sysfs_remove_group+0x3e/0xa0
>   [<f8824316>] cpufreq_stats_exit+0x46/0x72 [cpufreq_stats]
>   [<c014066c>] sys_delete_module+0x1a7/0x208
>   [<c0160073>] ? shrink_active_list+0x16c/0x3e8
>   [<c01680d6>] ? do_munmap+0x1db/0x1f5
>   [<c01eab50>] ? trace_hardirqs_on_thunk+0xc/0x10
>   [<c0103857>] sysenter_do_call+0x12/0x3f
>   =======================
>  ---[ end trace a49a8fac8db5df74 ]---
> 
> 
> Folkert van Heusden
> 


