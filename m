Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbXLTEka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbXLTEka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXLTEkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:40:20 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:10900 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbXLTEkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:40:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Vwqu0S2XrY1npZsbzpYPKTgFcNXD96blzJSHD3FgtMtq/4VYmlF4/5J5JsSSVrF0KM4Nekx1Fc/Rc+f95oe0xYEXXRkuSS+GqjJ81aYVM/kHUccUWAupVTi6lpsRXhzNYP8pZYKDz0quEmrSVCjYjBluxt+EpPJwHWkLns4UE5I=
Message-ID: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
Date: Wed, 19 Dec 2007 23:40:17 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the patch
"find /proc | xargs tail"

[   50.595474] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   54.733829] BUG: unable to handle kernel NULL pointer dereference
at virtual address 00000018
[   54.733836] printing ip: c012d527 *pde = 00000000
[   54.733843] Oops: 0000 [#1] SMP
[   54.733847] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda3/stat
[   54.733851] Modules linked in: aes_i586 aes_generic i915 drm rfcomm
l2cap bluetooth acpi_cpufreq cpufreq_stats cpufreq_conservative sbs
sbshc dm_crypt
 sbp2 parport_pc lp parport arc4 ecb crypto_blkcipher cryptomgr
crypto_algapi pcmcia snd_hda_intel snd_pcm_oss snd_mixer_oss iwl3945
snd_pcm snd_seq_dumm
y mac80211 snd_seq_oss cfg80211 sky2 tifm_7xx1 yenta_socket
rsrc_nonstatic pcmcia_core tifm_core iTCO_wdt iTCO_vendor_support
watchdog_core watchdog_dev
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq rng_core snd_timer
snd_seq_device shpchp pci_hotplug battery snd ac button soundcore
snd_page_alloc s
r_mod cdrom pata_acpi piix ide_core firewire_ohci firewire_core
crc_itu_t thermal processor fan
[   54.733915]
[   54.733918] Pid: 5703, comm: tail Not tainted (2.6.24-rc5-mm1 #9)
[   54.733921] EIP: 0060:[<c012d527>] EFLAGS: 00210297 CPU: 1
[   54.733926] EIP is at r_show+0x2a/0x70
[   54.733928] EAX: 00000000 EBX: 00000001 ECX: c07e3224 EDX: c04bb034
[   54.733931] ESI: 00000008 EDI: efbe9420 EBP: eed41f10 ESP: eed41f04
[   54.733934]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   54.733938] Process tail (pid: 5703, ti=eed41000 task=ee5a8000
task.ti=eed41000)
[   54.733940] Stack: c03a6cac efbe9420 c07e3224 eed41f50 c0199a7e
00002000 097d1f20 e1112500
[   54.733949]        efbe9440 00000000 00000000 000001d3 0000000e
00000000 0000000d 00000000
[   54.733958]        fffffffb f7d79210 c01998e4 eed41f74 c01af4f5
eed41f9c 00002000 097d1f20
[   54.733966] Call Trace:
[   54.733968]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
[   54.733975]  [<c0107df2>] show_stack_log_lvl+0x8a/0x95
[   54.733980]  [<c0107e89>] show_registers+0x8c/0x154
[   54.733984]  [<c010805f>] die+0x10e/0x1d2
[   54.733988]  [<c039c8c9>] do_page_fault+0x52b/0x600
[   54.733993]  [<c039af9a>] error_code+0x72/0x78
[   54.733998]  [<c0199a7e>] seq_read+0x19a/0x26c
[   54.734004]  [<c01af4f5>] proc_reg_read+0x60/0x74
[   54.734009]  [<c018390d>] vfs_read+0xa2/0x11e
[   54.734015]  [<c0183d02>] sys_read+0x3b/0x60
[   54.734019]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
[   54.734023]  =======================
[   54.734025] Code: c3 55 89 d1 89 e5 57 89 c7 56 53 8b 50 64 83 7a
0c 00 77 0e 81 7a 08 ff ff 00 00 be 04 00 00 00 76 05 be 08 00 00 00
89 c8 31 db <8b
> 40 18 39 d0 74 06 43 83 fb 05 75 f3 8b 41 10 ba 2f 1b 45 c0
[   54.734071] EIP: [<c012d527>] r_show+0x2a/0x70 SS:ESP 0068:eed41f04
[   55.363749] BUG: unable to handle kernel NULL pointer dereference
at virtual address 00000018
[   55.363756] printing ip: c012d527 *pde = 00000000
[   55.363762] Oops: 0000 [#2] SMP
[   55.363766] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda3/stat
[   55.363770] Modules linked in: aes_i586 aes_generic i915 drm rfcomm
l2cap bluetooth acpi_cpufreq cpufreq_stats cpufreq_conservative sbs
sbshc dm_crypt
 sbp2 parport_pc lp parport arc4 ecb crypto_blkcipher cryptomgr
crypto_algapi pcmcia snd_hda_intel snd_pcm_oss snd_mixer_oss iwl3945
snd_pcm snd_seq_dumm
y mac80211 snd_seq_oss cfg80211 sky2 tifm_7xx1 yenta_socket
rsrc_nonstatic pcmcia_core tifm_core iTCO_wdt iTCO_vendor_support
watchdog_core watchdog_dev
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq rng_core snd_timer
snd_seq_device shpchp pci_hotplug battery snd ac button soundcore
snd_page_alloc s
r_mod cdrom pata_acpi piix ide_core firewire_ohci firewire_core
crc_itu_t thermal processor fan
[   55.363834]
[   55.363837] Pid: 5710, comm: tail Tainted: G      D (2.6.24-rc5-mm1 #9)
[   55.363840] EIP: 0060:[<c012d527>] EFLAGS: 00210297 CPU: 1
[   55.363845] EIP is at r_show+0x2a/0x70
[   55.363848] EAX: 00000000 EBX: 00000001 ECX: c07e3224 EDX: c04bb034
[   55.363851] ESI: 00000008 EDI: efbe9420 EBP: ee5a8f10 ESP: ee5a8f04
[   55.363854]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   55.363857] Process tail (pid: 5710, ti=ee5a8000 task=f76ae000
task.ti=ee5a8000)
[   55.363860] Stack: c03a6cac efbe9420 c07e3224 ee5a8f50 c0199a7e
00002000 09e26f20 f7036d00
[   55.363868]        efbe9440 00000000 00000000 000001d3 0000000e
00000000 0000000d 00000000
[   55.363877]        fffffffb f7d79210 c01998e4 ee5a8f74 c01af4f5
ee5a8f9c 00002000 09e26f20
[   55.363885] Call Trace:
[   55.363887]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
[   55.363894]  [<c0107df2>] show_stack_log_lvl+0x8a/0x95
[   55.363898]  [<c0107e89>] show_registers+0x8c/0x154
[   55.363902]  [<c010805f>] die+0x10e/0x1d2
[   55.363906]  [<c039c8c9>] do_page_fault+0x52b/0x600
[   55.363911]  [<c039af9a>] error_code+0x72/0x78
[   55.363915]  [<c0199a7e>] seq_read+0x19a/0x26c
[   55.363921]  [<c01af4f5>] proc_reg_read+0x60/0x74
[   55.363925]  [<c018390d>] vfs_read+0xa2/0x11e
[   55.363930]  [<c0183d02>] sys_read+0x3b/0x60
[   55.363934]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
[   55.363938]  =======================
[   55.363940] Code: c3 55 89 d1 89 e5 57 89 c7 56 53 8b 50 64 83 7a
0c 00 77 0e 81 7a 08 ff ff 00 00 be 04 00 00 00 76 05 be 08 00 00 00
89 c8 31 db <8b
> 40 18 39 d0 74 06 43 83 fb 05 75 f3 8b 41 10 ba 2f 1b 45 c0
[   55.363986] EIP: [<c012d527>] r_show+0x2a/0x70 SS:ESP 0068:ee5a8f04
