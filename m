Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635Ab0AJLJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0AJLJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 06:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377Ab0AJLJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 06:09:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:10803 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0AJLJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 06:09:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=kjENjjZZWZQkEhkKJ4BWqkr+SUp0ODG1ERsqJNw9kh6vlzncDgHTGwyBLFAjNvu9H8
         MiYljIBe4LRUgErtz/6e2Fi2qiLCX3OqSeUIDst+2AssSlkyKwyuQybzQ1Gx8XwIJe3X
         POWLF3EMhNre0gZAIs1xjJMa1YR0HgKRKVqWM=
Message-ID: <4B49B56A.5090608@gmail.com>
Date: Sun, 10 Jan 2010 12:09:30 +0100
From: =?UTF-8?B?TWFyY2luIFN0csSFZ293c2tp?= <marcin.stragowski@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32: WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xd9/0x100
 [cfg80211]()
References: <g38rks2i4f536eq31kUYAxe124vaj_firegpg@mail.gmail.com> <1260926643.12157.548.camel@debian>
In-Reply-To: <1260926643.12157.548.camel@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhu Yi wrote:
> On Tue, 2009-12-15 at 22:23 +0800, zdenek.kabelac@gmail.com wrote:
>   
>> 2009/12/5 Andy Isaacson <adi@hexapodia.org>:
>>     
>>> Got this on a Dell e4300 (Core 2 Duo, Inte Pro/Wireless 5300 AGN)
>>> running 2.6.32 final, while doing a suspend-on-lid-close soon after
>>> bootup:
>>>
>>> [   65.455842] ------------[ cut here ]------------
>>> [   65.460477] WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xd9/0x100 [cfg80211]()
>>> [   65.468656] Hardware name: Latitude E4300
>>> <9>[   65.474225] Modules linked in: binfmt_misc rfcomm sco bnep l2cap crc16 snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 ecb snd_seq_oss snd_seq_midi iwlagn snd_rawmidi iwlcore snd_seq_midi_event snd_seq snd_timer snd_seq_device btusb snd led_class soundcore wmi mac80211 bluetooth ricoh_mmc snd_page_alloc psmouse evdev serio_raw dcdbas cfg80211 usbhid hid i915 drm_kms_helper drm i2c_algo_bit pata_acpi i2c_core intel_agp uhci_hcd[   65.520656] ---[ end trace ea0633faa6e3e0ca ]---
>>> [   65.649368] PM: Syncing filesystems ... done.
>>> [   65.685833] PM: Preparing system for mem sleep
>>> [   65.947589] [drm] LVDS-8: set mode 1280x800 c
>>> <9>[   66.011918] Freezing user space processes ... (elapsed 0.00 seconds) <9>[   66.020637] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.[   66.028100] PM: Entering mem sleep
>>>
>>> I haven't seen this error before, so it may be a regression from .31,
>>> but then I have only had serial console set up for a few weeks.
>>>
>>> More serial console below, full dmesg (after a reboot) at
>>> http://web.hexapodia.org/~adi/tmp/e4300-dmesg-2.6.32.txt
>>>
>>>  * Setting preliminary keymap...                                                 * Speech-dispatcher configured for user sessionsps
>>>  * Starting Common Unix Printing System: cupsd                                   * PulseAudio configured for per-user sessions
>>>  * Enabling additional executable binary formats binfmt-support                    ...done. battery state...
>>> [   31.963202] [drm] TV-25: set mode NTSC 480i 0
>>> [   32.107680] [drm] TV-25: set mode NTSC 480i 0
>>> [   32.402764] [drm] TV-25: set mode NTSC 480i 0
>>> [   32.547450] [drm] TV-25: set mode NTSC 480i 0
>>> [   32.842692] [drm] TV-25: set mode NTSC 480i 0
>>> [   32.987478] [drm] TV-25: set mode NTSC 480i 0
>>> [   35.658716] [drm] TV-25: set mode NTSC 480i 0
>>> [   35.803263] [drm] TV-25: set mode NTSC 480i 0
>>> [   42.186787] wlan0: deauthenticating from 00:0b:0e:46:5c:00 by local choice (reason=3)
>>> [   42.194885] wlan0: direct probe to AP 00:0b:0e:46:5c:00 (try 1)
>>> [   42.204706] wlan0: direct probe responded
>>> [   42.208721] wlan0: authenticate with AP 00:0b:0e:46:5c:00 (try 1)
>>> [   42.217544] wlan0: authenticated
>>> [   42.220790] wlan0: associate with AP 00:0b:0e:46:5c:00 (try 1)
>>> [   42.229554] wlan0: RX AssocResp from 00:0b:0e:46:5c:00 (capab=0x421 status=0 aid=6)
>>> [   42.237207] wlan0: associated
>>> [   42.252175] cfg80211: Calling CRDA for country: US
>>> [   42.258795] cfg80211: Current regulatory domain updated by AP to: US
>>> [   42.265161]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>> [   42.272401]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
>>> [   63.151613] [drm] TV-25: set mode NTSC 480i 0
>>> [   63.606768] [drm] TV-25: set mode NTSC 480i 0
>>> [   63.919543] [drm] TV-25: set mode NTSC 480i 0
>>> [   64.103978] [drm] TV-25: set mode NTSC 480i 0
>>> [   65.381220] wlan0: deauthenticating from 00:0b:0e:46:5c:00 by local choice (reason=3)
>>> [   65.390034] wlan0: direct probe to AP 00:0b:0e:46:5c:00 (try 1)
>>> [   65.396020] wlan0: deauthenticating from 00:0b:0e:46:5c:00 by local choice (reason=3)
>>> [   65.455842] ------------[ cut here ]------------
>>> [   65.460477] WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xd9/0x100 [cfg80211]()
>>> [   65.468656] Hardware name: Latitude E4300
>>> <9>[   65.474225] Modules linked in: binfmt_misc rfcomm sco bnep l2cap crc16 snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 ecb snd_seq_oss snd_seq_midi iwlagn snd_rawmidi iwlcore snd_seq_midi_event snd_seq snd_timer snd_seq_device btusb snd led_class soundcore wmi mac80211 bluetooth ricoh_mmc snd_page_alloc psmouse evdev serio_raw dcdbas cfg80211 usbhid hid i915 drm_kms_helper drm i2c_algo_bit pata_acpi i2c_core intel_agp uhci_hcd[   65.520656] ---[ end trace ea0633faa6e3e0ca ]---
>>> [   65.649368] PM: Syncing filesystems ... done.
>>> [   65.685833] PM: Preparing system for mem sleep
>>> [   65.947589] [drm] LVDS-8: set mode 1280x800 c
>>> <9>[   66.011918] Freezing user space processes ... (elapsed 0.00 seconds) <9>[   66.020637] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.[   66.028100] PM: Entering mem sleep
>>>
>>>       
>> I've also got this message - with different hw  - Lenovo T61 - iwl3945, C2D, 64bit, 4GB
>>
>>  iwl3945 0000:03:00.0: Error: Response NULL in 'REPLY_ADD_STA'
>>  ------------[ cut here ]------------
>>  WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xf1/0x120 [cfg80211]()
>>  Hardware name: 6464CTO
>>  Modules linked in: dvb_usb_dib0700 dib7000p dib7000m dib0070 dvb_usb dib3000mc dib8000 dibx000_common dvb_core aes_generic usblp tun nfsd lockd nfs_acl auth_rpcgss exportfs hidp ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc rfcomm sco l2cap sunrpc autofs4 ipv6 binfmt_misc dm_mirror dm_region_hash dm_log kvm_intel kvm i915 drm_kms_helper drm i2c_algo_bit uinput arc4 ecb cryptomgr crypto_hash usbhid hid btusb bluetooth snd_hda_codec_analog aead pcompress crypto_blkcipher crypto_algapi snd_hda_intel iwl3945 snd_hda_codec iwlcore mac80211 snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss thinkpad_acpi sdhci_pci sdhci snd_mixer_oss snd_pcm cfg80211 mmc_core sr_mod iTCO_wdt psmouse i2c_i801 i2c_core ac snd_timer nvram rfkill rtc_cmos rtc_core rtc_lib iTCO_vendor_support battery snd ehci_hcd e1000e led_class cdrom soundcore snd_page_alloc evdev s
>>  erio_raw uhci_hcd usbcore dm_multipath video backlight output button dm_mod [last unloaded: microcode]
>>  Pid: 28586, comm: events/1 Tainted: G        W  2.6.32-00001-g7635708 #42
>>  Call Trace:
>>   [<ffffffff8105334b>] warn_slowpath_common+0x7b/0xc0
>>   [<ffffffff810533a4>] warn_slowpath_null+0x14/0x20
>>   [<ffffffffa01500c1>] wdev_cleanup_work+0xf1/0x120 [cfg80211]
>>   [<ffffffffa014ffd0>] ? wdev_cleanup_work+0x0/0x120 [cfg80211]
>>   [<ffffffff8107462a>] worker_thread+0x21a/0x400
>>   [<ffffffff810745d9>] ? worker_thread+0x1c9/0x400
>>   [<ffffffff8107a3d0>] ? autoremove_wake_function+0x0/0x40
>>   [<ffffffff81074410>] ? worker_thread+0x0/0x400
>>   [<ffffffff8107a046>] kthread+0x96/0xa0
>>   [<ffffffff8100d21a>] child_rip+0xa/0x20
>>   [<ffffffff81042fb4>] ? finish_task_switch+0x74/0xf0
>>   [<ffffffff814259bb>] ? _spin_unlock_irq+0x3b/0x60
>>   [<ffffffff8100cb80>] ? restore_args+0x0/0x30
>>   [<ffffffff81079fb0>] ? kthread+0x0/0xa0
>>   [<ffffffff8100d210>] ? child_rip+0x0/0x20
>>  ---[ end trace 2a88b94a3eb21e98 ]---
>>  (elapsed 0.03 seconds) done.
>>  Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>>  sd 0:0:0:0: [sda] Synchronizing SCSI cache
>>     
>
> This patch [1] from Johannes should fix the problem. Unfortunately it's
> not included in .32. John has already sent it to stable@.
>
> 1.
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commit;h=6d3560d4fc9c5b9fe1a07a63926ea70512c69c32
>
> Thanks,
> -yi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

Hi,

I have the same problem as Zdenek.
After reading your mail, I've downloaded the kernel 2.6.32.3 (where this 
patch is applied), but the problem still occurs.
I have lenovo t61 thinkpad just like Zdenek,  problem occurs while 
trying to put the computer in to sleep mode.



[ 1868.397536] ------------[ cut here ]------------
[ 1868.397561] WARNING: at net/wireless/core.c:614 
wdev_cleanup_work+0x52/0xd1 [cfg80211]()
[ 1868.397562] Hardware name: 64577XG
[ 1868.397563] Modules linked in: nls_utf8 nls_cp437 vfat fat aes_x86_64 
aes_generic nvidia(P) ppdev lp parport bridge stp ip      v6 vboxnetflt 
vboxnetadp vboxdrv uinput fuse firewire_sbp2 loop snd_hda_codec_analog 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd      _seq_dummy snd_seq_oss snd_seq_midi arc4 snd_rawmidi 
snd_seq_midi_event snd_seq ecb snd_timer snd_seq_device pcmcia iwlagn 
snd iwlcore soundcore yenta_socket rs      rc_nonstatic psmouse pcspkr 
serio_raw mac80211 pcmcia_core joydev btusb snd_page_alloc i2c_i801 hso 
evdev wmi cfg80211 dm_mod ide_gd_mod sd_mod ata_generic crc_      t10dif 
pata_acpi ata_piix ide_pci_generic mmc_block ahci sdhci_pci sdhci 
firewire_ohci piix libata firewire_core crc_itu_t video output scsi_mod 
ricoh_mmc mmc_c      ore ide_core intel_agp e1000e [last unloaded: 
scsi_wait_scan]
[ 1868.397606] Pid: 9, comm: events/0 Tainted: P           
2.6.32.3-noder7 #1
[ 1868.397608] Call Trace:
[ 1868.397613]  [<ffffffffa01334ed>] ? wdev_cleanup_work+0x52/0xd1 
[cfg80211]
[ 1868.397617]  [<ffffffffa01334ed>] ? wdev_cleanup_work+0x52/0xd1 
[cfg80211]
[ 1868.397621]  [<ffffffff81043324>] ? warn_slowpath_common+0x77/0xa3
[ 1868.397626]  [<ffffffffa01334ed>] ? wdev_cleanup_work+0x52/0xd1 
[cfg80211]
[ 1868.397629]  [<ffffffff81056953>] ? worker_thread+0x182/0x211
[ 1868.397633]  [<ffffffffa013349b>] ? wdev_cleanup_work+0x0/0xd1 [cfg80211]
[ 1868.397636]  [<ffffffff81059f84>] ? autoremove_wake_function+0x0/0x2e
[ 1868.397638]  [<ffffffff810567d1>] ? worker_thread+0x0/0x211
[ 1868.397641]  [<ffffffff81059cc9>] ? kthread+0x79/0x81
[ 1868.397644]  [<ffffffff8100c99a>] ? child_rip+0xa/0x20
[ 1868.397646]  [<ffffffff81059c50>] ? kthread+0x0/0x81
[ 1868.397648]  [<ffffffff8100c990>] ? child_rip+0x0/0x20
[ 1868.397649] ---[ end trace 03acd35e2c2e7960 ]---


