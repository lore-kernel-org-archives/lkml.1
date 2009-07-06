Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZGFNqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZGFNqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZGFNqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:46:36 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49191 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZGFNqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Q1zpoUf3/kPub6c+WgbQ7vSHuqiNd3IsklyTwgWmcBNhJa93mv4gNn40o81UqqfNg9
         sVhpjtX8mIhZov+lw9OTJJ21z3TZkSKs74h0b+8nI2ZHsJQ+5hQOQ5AmMb1c4g0/JPgY
         YDsoRh/L8mKRTdM4cmqr13lQNF6VSgyGboVWs=
MIME-Version: 1.0
Date: Mon, 6 Jul 2009 09:46:37 -0400
Message-ID: <5cf2d09e0907060646i293217b6s56fa427cdcb3933a@mail.gmail.com>
Subject: Journal Error - Ext3 kernel 2.6.30
From: W Lundby <w.lundby@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This boot cycle had been through hibernate several times.
The journal error was after at least 8 hours from the return from hibernate.

Jul  6 01:02:30 miro kernel: ------------[ cut here ]------------
Jul  6 01:02:30 miro kernel: WARNING: at fs/buffer.c:1152
mark_buffer_dirty+0x23/0x7d()
Jul  6 01:02:30 miro kernel: Hardware name: System Product Name
Jul  6 01:02:30 miro kernel: Modules linked in: binfmt_misc nvidia(P)
ppdev kvm_amd kvm powernow_k8 cpufreq_ondemand cpufreq_userspace
cpufreq_stats cpufreq_conservative freq_table cpufreq_powersave ipv6
fuse tun loop snd_emu10k1_synth snd_emux_synth snd_seq_virmidi
snd_seq_midi_emul snd_emu10k1 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss tvaudio snd_pcm tda7432 snd_page_alloc snd_util_mem
msp3400 snd_hwdep snd_seq_dummy tuner_simple snd_seq_oss tuner_types
tea5767 snd_seq_midi snd_rawmidi tuner snd_seq_midi_event bttv snd_seq
ir_common snd_timer v4l2_common videodev snd_seq_device v4l1_compat
v4l2_compat_ioctl32 videobuf_dma_sg emu10k1_gp snd videobuf_core
psmouse soundcore gameport btcx_risc tveeprom k8temp serio_raw pcspkr
i2c_nforce2 parport_pc parport processor button evdev ext3 jbd mbcache
dm_snapshot sd_mod usbhid sg sr_mod cdrom ohci_hcd sata_nv pata_amd
libata scsi_mod r8169 mii ehci_hcd thermal fan dm_mirror
dm_region_hash dm_log dm_mod
Jul  6 01:02:30 miro kernel: Pid: 29478, comm: firefox-bin Tainted: P
         2.6.30 #1
Jul  6 01:02:30 miro kernel: Call Trace:
Jul  6 01:02:30 miro kernel:  [<ffffffff802c15e5>] ? mark_buffer_dirty+0x23/0x7d
Jul  6 01:02:30 miro kernel:  [<ffffffff802c15e5>] ? mark_buffer_dirty+0x23/0x7d
Jul  6 01:02:30 miro kernel:  [<ffffffff80236e35>] ?
warn_slowpath_common+0x77/0xa3
Jul  6 01:02:30 miro kernel:  [<ffffffff802c15e5>] ? mark_buffer_dirty+0x23/0x7d
Jul  6 01:02:30 miro kernel:  [<ffffffffa012667d>] ?
ext3_commit_super+0x49/0x68 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffffa0127e23>] ?
ext3_handle_error+0x83/0xa9 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffffa0127ea3>] ?
__ext3_std_error+0x5a/0x61 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffffa0129573>] ?
__ext3_journal_stop+0x36/0x3d [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffff802bd25d>] ?
__mark_inode_dirty+0x29/0x190
Jul  6 01:02:30 miro kernel:  [<ffffffffa011cac7>] ?
ext3_new_blocks+0x65b/0x6c0 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffff802c3dff>] ? __bread+0x6/0x83
Jul  6 01:02:30 miro kernel:  [<ffffffffa011f810>] ?
ext3_get_branch+0x67/0xdb [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffffa01208b8>] ?
ext3_get_blocks_handle+0x375/0x829 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffff8027a5fd>] ?
__rmqueue_smallest+0x9d/0x11e
Jul  6 01:02:30 miro kernel:  [<ffffffff80209c37>] ? __switch_to+0x251/0x263
Jul  6 01:02:30 miro kernel:  [<ffffffff80286afc>] ? zone_statistics+0x3c/0x5d
Jul  6 01:02:30 miro kernel:  [<ffffffffa0120e27>] ?
ext3_get_block+0xbb/0xf8 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffff802c285b>] ?
__block_prepare_write+0x1b3/0x3b0
Jul  6 01:02:30 miro kernel:  [<ffffffffa0120d6c>] ?
ext3_get_block+0x0/0xf8 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffff802c2bc6>] ? block_write_begin+0x7a/0xc8
Jul  6 01:02:30 miro kernel:  [<ffffffffa01203d6>] ?
ext3_write_begin+0x100/0x1f5 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffffa0120d6c>] ?
ext3_get_block+0x0/0xf8 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffff802779e4>] ?
generic_file_buffered_write+0x12c/0x2e8
Jul  6 01:02:30 miro kernel:  [<ffffffff80478f4a>] ? _spin_lock+0x5/0x8
Jul  6 01:02:30 miro kernel:  [<ffffffff8027807f>] ?
__generic_file_aio_write_nolock+0x349/0x37d
Jul  6 01:02:30 miro kernel:  [<ffffffff803f6fb8>] ? sock_aio_read+0x103/0x117
Jul  6 01:02:30 miro kernel:  [<ffffffff80278869>] ?
generic_file_aio_write+0x64/0xc4
Jul  6 01:02:30 miro kernel:  [<ffffffffa011d4bc>] ?
ext3_file_write+0x16/0x96 [ext3]
Jul  6 01:02:30 miro kernel:  [<ffffffff802a32b2>] ? do_sync_write+0xce/0x113
Jul  6 01:02:30 miro kernel:  [<ffffffff80210fd4>] ? sched_clock+0x5/0x8
Jul  6 01:02:30 miro kernel:  [<ffffffff802494aa>] ?
autoremove_wake_function+0x0/0x2e
Jul  6 01:02:30 miro kernel:  [<ffffffff804773d3>] ? thread_return+0x41/0xbb
Jul  6 01:02:30 miro kernel:  [<ffffffff802a3c0d>] ? vfs_write+0xad/0x136
Jul  6 01:02:30 miro kernel:  [<ffffffff802a3d52>] ? sys_write+0x45/0x6e
Jul  6 01:02:30 miro kernel:  [<ffffffff8020af82>] ?
system_call_fastpath+0x16/0x1b
Jul  6 01:02:30 miro kernel: ---[ end trace 89c86d96868e9cda ]---
Jul  6 01:02:30 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:30 miro kernel: ata4: EH complete
Jul  6 01:02:30 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:30 miro kernel: ata4: EH complete
Jul  6 01:02:30 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:30 miro kernel: ata4: EH complete
Jul  6 01:02:30 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:30 miro kernel: ata4: EH complete
Jul  6 01:02:30 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:30 miro kernel: ata4: EH complete
Jul  6 01:02:30 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:30 miro kernel: sd 3:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Jul  6 01:02:30 miro kernel: sd 3:0:0:0: [sdb] Sense Key : Aborted
Command [current] [descriptor]
Jul  6 01:02:30 miro kernel: Descriptor sense data with sense
descriptors (in hex):
Jul  6 01:02:30 miro kernel:         72 0b 00 00 00 00 00 0c 00 0a 80
00 00 00 00 00
Jul  6 01:02:30 miro kernel:         00 9c 27 fc
Jul  6 01:02:30 miro kernel: sd 3:0:0:0: [sdb] Add. Sense: No
additional sense information
Jul  6 01:02:30 miro kernel: ata4: EH complete
Jul  6 01:02:30 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:30 miro kernel: ata4: EH complete
Jul  6 01:02:31 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:31 miro kernel: ata4: EH complete
Jul  6 01:02:31 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:31 miro kernel: ata4: EH complete
Jul  6 01:02:31 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:31 miro kernel: ata4: EH complete
Jul  6 01:02:31 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:31 miro kernel: ata4: EH complete
Jul  6 01:02:31 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:31 miro kernel: sd 3:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Jul  6 01:02:31 miro kernel: sd 3:0:0:0: [sdb] Sense Key : Aborted
Command [current] [descriptor]
Jul  6 01:02:31 miro kernel: Descriptor sense data with sense
descriptors (in hex):
Jul  6 01:02:31 miro kernel:         72 0b 00 00 00 00 00 0c 00 0a 80
00 00 00 00 00
Jul  6 01:02:31 miro kernel:         00 9c 27 fc
Jul  6 01:02:31 miro kernel: sd 3:0:0:0: [sdb] Add. Sense: No
additional sense information
Jul  6 01:02:31 miro kernel:
Jul  6 01:02:31 miro kernel: __journal_remove_journal_head: freeing
b_committed_data
Jul  6 01:02:39 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:39 miro kernel: ata4: EH complete
Jul  6 01:02:39 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:39 miro kernel: ata4: EH complete
Jul  6 01:02:39 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:39 miro kernel: ata4: EH complete
Jul  6 01:02:39 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:39 miro kernel: ata4: EH complete
Jul  6 01:02:39 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:39 miro kernel: ata4: EH complete
Jul  6 01:02:39 miro kernel: ata4.00: configured for UDMA/100
Jul  6 01:02:39 miro kernel: sd 3:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Jul  6 01:02:39 miro kernel: sd 3:0:0:0: [sdb] Sense Key : Aborted
Command [current] [descriptor]
Jul  6 01:02:39 miro kernel: Descriptor sense data with sense
descriptors (in hex):
Jul  6 01:02:39 miro kernel:         72 0b 00 00 00 00 00 0c 00 0a 80
00 00 00 00 00
Jul  6 01:02:39 miro kernel:         02 10 39 34
Jul  6 01:02:39 miro kernel: sd 3:0:0:0: [sdb] Add. Sense: No
additional sense information
Jul  6 01:02:39 miro kernel: __ratelimit: 252 callbacks suppressed
Jul  6 01:02:39 miro kernel: lost page write due to I/O error on dm-5
Jul  6 01:02:39 miro kernel: lost page write due to I/O error on dm-5
Jul  6 01:02:39 miro kernel: ata4: EH complete
