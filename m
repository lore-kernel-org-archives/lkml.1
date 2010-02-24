Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab0BYAHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 19:07:49 -0500
Received: from animx.eu.org ([216.98.75.249]:54787 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab0BYAHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 19:07:47 -0500
X-Greylist: delayed 1906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 19:07:46 EST
Date: Wed, 24 Feb 2010 18:35:59 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.33 warning message
Message-ID: <20100224233559.GA26243@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just upgraded to 2.6.33.  This is x86 32-bit.

I saw this in my logs, what is this?

[ 1078.173129] ------------[ cut here ]------------
[ 1078.173164] WARNING: at /usr/src/linux/dist/2.6.33/drivers/ata/libata-core.c:5186 ata_qc_issue+0x2ab/0x2c0 [libata]()
[ 1078.173168] Hardware name: X7DA8
[ 1078.173170] Modules linked in: radeon ttm drm_kms_helper drm agpgart fb i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect nfsd exportfs nfs lockd sunrpc ipv6 xt_conntrack xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_LOG xt_mac iptable_filter ip_tables x_tables fuse reiserfs crc32 dm_mod parport_pc parport 8250_pnp 8250 serial_core usb_storage e1000e ahci sg sr_mod cdrom ata_piix snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 md_mod i5k_amb w83793 hwmon_vid hwmon i2c_i801 i2c_core aic94xx libsas libata firmware_class scsi_transport_sas [last unloaded: usb_storage]
[ 1078.173242] Pid: 22481, comm: smartctl Not tainted 2.6.33 #1
[ 1078.173245] Call Trace:
[ 1078.173257]  [<f830640b>] ? ata_qc_issue+0x2ab/0x2c0 [libata]
[ 1078.173268]  [<f830640b>] ? ata_qc_issue+0x2ab/0x2c0 [libata]
[ 1078.173276]  [<c022d21f>] ? warn_slowpath_common+0x7f/0xb0
[ 1078.173287]  [<f830640b>] ? ata_qc_issue+0x2ab/0x2c0 [libata]
[ 1078.173291]  [<c022d263>] ? warn_slowpath_null+0x13/0x20
[ 1078.173302]  [<f830640b>] ? ata_qc_issue+0x2ab/0x2c0 [libata]
[ 1078.173308]  [<c0362ad0>] ? scsi_sg_alloc+0x0/0x50
[ 1078.173312]  [<c0362c81>] ? scsi_init_io+0x11/0xa0
[ 1078.173316]  [<c0362dd3>] ? scsi_setup_blk_pc_cmnd+0x43/0xd0
[ 1078.173327]  [<f830b519>] ? ata_scsi_translate+0xb9/0x140 [libata]
[ 1078.173333]  [<c0428435>] ? schedule+0x3a5/0x890
[ 1078.173338]  [<c035db60>] ? scsi_done+0x0/0x10
[ 1078.173350]  [<f830bf55>] ? ata_sas_queuecmd+0x125/0x220 [libata]
[ 1078.173362]  [<f830d570>] ? ata_scsi_pass_thru+0x0/0x2f0 [libata]
[ 1078.173372]  [<f834787f>] ? sas_queuecommand+0x6f/0x260 [libsas]
[ 1078.173375]  [<c035db60>] ? scsi_done+0x0/0x10
[ 1078.173379]  [<c035e1ab>] ? scsi_dispatch_cmd+0xdb/0x1b0
[ 1078.173383]  [<c0364115>] ? scsi_request_fn+0x235/0x390
[ 1078.173388]  [<c02f83e2>] ? __blk_run_queue+0x72/0x110
[ 1078.173391]  [<c02f5d77>] ? elv_insert+0xf7/0x170
[ 1078.173395]  [<c02fbf80>] ? blk_execute_rq_nowait+0x50/0x90
[ 1078.173398]  [<c02fc033>] ? blk_execute_rq+0x73/0xd0
[ 1078.173402]  [<c02fbf00>] ? blk_end_sync_rq+0x0/0x30
[ 1078.173405]  [<c02fc2eb>] ? blk_recount_segments+0x1b/0x30
[ 1078.173409]  [<c02f6a42>] ? blk_rq_bio_prep+0x82/0xa0
[ 1078.173413]  [<c02fba0c>] ? blk_rq_append_bio+0x1c/0x60
[ 1078.173417]  [<c02fbced>] ? blk_rq_map_user+0x17d/0x240
[ 1078.173421]  [<c02ff9ae>] ? sg_io+0x19e/0x370
[ 1078.173425]  [<c02ffe81>] ? scsi_cmd_ioctl+0x301/0x440
[ 1078.173429]  [<c0307612>] ? vsnprintf+0x732/0x10c0
[ 1078.173434]  [<c02221fc>] ? kmap_atomic+0x1c/0x30
[ 1078.173439]  [<c02645dc>] ? get_page_from_freelist+0x1fc/0x430
[ 1078.173444]  [<c037fd96>] ? sd_ioctl+0x86/0xd0
[ 1078.173448]  [<c02fd416>] ? __blkdev_driver_ioctl+0x86/0xa0
[ 1078.173451]  [<c02fd639>] ? blkdev_ioctl+0x209/0xa60
[ 1078.173455]  [<c02266b0>] ? finish_task_switch+0x40/0xa0
[ 1078.173459]  [<c0428270>] ? schedule+0x1e0/0x890
[ 1078.173464]  [<c025f79f>] ? find_get_page+0x2f/0xc0
[ 1078.173467]  [<c0261254>] ? filemap_fault+0x84/0x3d0
[ 1078.173471]  [<c02221fc>] ? kmap_atomic+0x1c/0x30
[ 1078.173476]  [<c0272051>] ? __do_fault+0x2c1/0x480
[ 1078.173481]  [<c02b2f55>] ? block_ioctl+0x35/0x50
[ 1078.173484]  [<c02b2f20>] ? block_ioctl+0x0/0x50
[ 1078.173489]  [<c029941b>] ? vfs_ioctl+0x2b/0xa0
[ 1078.173492]  [<c02995cb>] ? do_vfs_ioctl+0x6b/0x560
[ 1078.173496]  [<c02578ec>] ? __rcu_process_callbacks+0x6c/0x2b0
[ 1078.173501]  [<c021c8ae>] ? do_page_fault+0x14e/0x300
[ 1078.173505]  [<c0299afd>] ? sys_ioctl+0x3d/0x70
[ 1078.173509]  [<c042a769>] ? syscall_call+0x7/0xb
[ 1078.173512] ---[ end trace edc422bcc33123db ]---

I must add that after I upgraded I added an hdd monitoring script for munin
to my config to watch HDD temps.  This happened when munin ran it.
The disks it's being ran on is sd[c-h] which are on the onboard aic94xx chip.
All 6 disks are segate 750gb sata.

Also, this only happened once so far (On the first run of 2).

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
