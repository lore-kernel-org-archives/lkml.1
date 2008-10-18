Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbYJRGEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbYJRGEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 02:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYJRGEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 02:04:11 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:33947 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750858AbYJRGEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 02:04:09 -0400
Date: Sat, 18 Oct 2008 03:04:00 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Alexandre Lymberopoulos <lymber@gmail.com>, 502583@bugs.debian.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug#502583: scary messages in dmesg
Message-ID: <20081018060400.GB916@ime.usp.br>
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alexandre.

On Oct 18 2008, Alexandre Lymberopoulos wrote:
> Package: usbmount
> Severity: normal
(...)
> [32282.607205] wmnetload[6372]: segfault at 1 ip b7db75a9 sp bfdfc288 error 4 in libc-2.7.so[b7d41000+155000]
> [39070.466297] usb 5-2: USB disconnect, address 3
> [39071.159613] Buffer I/O error on device sda1, logical block 1545
> [39071.159625] lost page write due to I/O error on sda1
> [39071.159642] ------------[ cut here ]------------
> [39071.159646] WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x20/0x6a()
> [39071.159649] Modules linked in: nls_utf8 nls_cp437 vfat fat nls_base sd_mod usb_storage i915 drm ipv6 loop joydev pcmcia snd_intel8x0 snd_intel8x0m snd_ac97_codec ac97_bus ieee80211 ieee80211_crypt snd_seq_dummy firmware_class yenta_socket rsrc_nonstatic pcmcia_core serio_raw snd_pcm_oss snd_mixer_oss i2c_i801 pcspkr psmouse i2c_core snd_pcm snd_seq_midi snd_seq_oss iTCO_wdt snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd rng_core soundcore snd_page_alloc video output button battery ac intel_agp agpgart evdev dcdbas ext3 jbd mbcache ide_cd_mod cdrom ide_disk ide_pci_generic piix ide_core ata_generic libata scsi_mod dock e100 mii ehci_hcd uhci_hcd usbcore thermal processor fan thermal_sys [last unloaded: ipw2200]
> [39071.159742] Pid: 8890, comm: umount Not tainted 2.6.26-1-686 #1
> [39071.159751]  [<c012242b>] warn_on_slowpath+0x40/0x66
> [39071.159770]  [<c01d1c0c>] generic_make_request+0x34d/0x37b
> [39071.159787]  [<f892d304>] ext3_getblk+0x9f/0x17d [ext3]
> [39071.159811]  [<c0158949>] mempool_alloc+0x1c/0xba
> [39071.159822]  [<c01d2ce8>] submit_bio+0xc6/0xcd
> [39071.159831]  [<c0158929>] mempool_free+0x63/0x67
> [39071.159843]  [<c01900a8>] mark_buffer_dirty+0x20/0x6a
> [39071.159849]  [<f887ec2c>] journal_update_superblock+0x59/0x97 [jbd]
> [39071.159865]  [<f887db43>] cleanup_journal_tail+0xac/0xb1 [jbd]
> [39071.159877]  [<f887de27>] log_do_checkpoint+0x2a8/0x2ee [jbd]
> [39071.159890]  [<c01564fe>] find_get_pages_tag+0x2a/0x6e
> [39071.159901]  [<c01564fe>] find_get_pages_tag+0x2a/0x6e
> [39071.159908]  [<c0135eec>] getnstimeofday+0x37/0xbc
> [39071.159919]  [<c01df8c4>] rb_insert_color+0x4c/0xad
> [39071.159929]  [<c0133c2e>] enqueue_hrtimer+0xc9/0xd4
> [39071.159938]  [<c01341f6>] hrtimer_start+0xf7/0x110
> [39071.159948]  [<c011d36d>] hrtick_set+0x8f/0xd8
> [39071.159957]  [<c02b7eb8>] schedule+0x64e/0x66f
> [39071.159976]  [<f887f6fc>] journal_destroy+0xc7/0x163 [jbd]
> [39071.160040]  [<c013177c>] autoremove_wake_function+0x0/0x2d
> [39071.160051]  [<f8933f16>] ext3_put_super+0x1f/0x169 [ext3]
> [39071.160071]  [<c0175a85>] generic_shutdown_super+0x4f/0xc8
> [39071.160078]  [<c019ebe3>] vfs_quota_off+0x0/0x518
> [39071.160084]  [<c0175b0a>] kill_block_super+0xc/0x1b
> [39071.160090]  [<c0175ba9>] deactivate_super+0x4b/0x60
> [39071.160097]  [<c0186ca7>] sys_umount+0x282/0x2c8
> [39071.160105]  [<c010f6a1>] flush_tlb_mm+0x39/0x60
> [39071.160119]  [<c0115afb>] do_page_fault+0x29b/0x5b8
> [39071.160132]  [<c0103853>] sysenter_past_esp+0x78/0xb1
> [39071.160144]  [<c02b0000>] virtcons_probe+0xd6/0xdd
> [39071.160154]  =======================
> [39071.160157] ---[ end trace c45f2bacd26f4247 ]---
> [39071.160167] Buffer I/O error on device sda1, logical block 1545
> [39071.160170] lost page write due to I/O error on sda1
> [39071.160184] Buffer I/O error on device sda1, logical block 1545
> [39071.160187] lost page write due to I/O error on sda1
> [39071.160197] Buffer I/O error on device sda1, logical block 1545
> [39071.160201] lost page write due to I/O error on sda1
> [39071.160210] Buffer I/O error on device sda1, logical block 1545
> [39071.160213] lost page write due to I/O error on sda1
> [39071.160223] Buffer I/O error on device sda1, logical block 1545
> [39071.160226] lost page write due to I/O error on sda1
> [39071.160235] Buffer I/O error on device sda1, logical block 1545
> [39071.160238] lost page write due to I/O error on sda1
> [39071.160247] Buffer I/O error on device sda1, logical block 1545
> [39071.160251] lost page write due to I/O error on sda1
> [39071.160259] Buffer I/O error on device sda1, logical block 1545
> [39071.160262] lost page write due to I/O error on sda1
> [39071.160272] Buffer I/O error on device sda1, logical block 1545
> [39071.160275] lost page write due to I/O error on sda1
> [39140.700073] usb 5-1: new high speed USB device using ehci_hcd and address 4
> [39140.946003] usb 5-1: configuration #1 chosen from 1 choice
> [39140.948029] scsi2 : SCSI emulation for USB Mass Storage devices
> [39140.949899] usb 5-1: New USB device found, idVendor=067b, idProduct=3507
> [39140.949909] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [39140.949914] usb 5-1: Product: PL-3507C USB Storage Device
> [39140.949917] usb 5-1: Manufacturer: Prolific
> [39140.949920] usb 5-1: SerialNumber: 01201290
> [39140.950566] usb-storage: device found at 4
> [39140.950573] usb-storage: waiting for device to settle before scanning
> [39145.948337] usb-storage: device scan complete

As these messages indicate something going wild in kernelland (due to the
stack trace), I'm CC'ing the linux-kernel mailing list. It is probably
triggered by something probably not related to usbmount.

Just for extra information, what kind of fs do you have on your memory
stick? Can you provide extra details on the situation?


Regards, Rogério Brito.

P.S.: Alexandre's complete dmesg is available at
http://bugs.debian.org/502583

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
