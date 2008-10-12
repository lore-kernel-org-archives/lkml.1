Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYJLRne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYJLRne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 13:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYJLRn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 13:43:26 -0400
Received: from filter2.host.bg ([87.120.40.156]:50741 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbYJLRnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 13:43:24 -0400
Message-ID: <48F236EA.2060404@saturnosoft.biz>
Date: Sun, 12 Oct 2008 20:42:02 +0300
From: Todor Gyumyushev <todor@saturnosoft.biz>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: warning report
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 3724.989177] cdrom: This disc doesn't have any tracks I recognize!
[ 4953.736107] ------------[ cut here ]------------
[ 4953.736117] WARNING: at drivers/ata/libata-sff.c:944 
ata_sff_hsm_move+0x47d/0x6a0 [libata]()
[ 4953.736121] Modules linked in: i915 drm eth1394 ipt_MASQUERADE 
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables tun 
kvm acpi_cpufreq freq_table hci_usb rfcomm l2cap bluetooth vboxdrv nfsd 
lockd nfs_acl auth_rpcgss sunrpc exportfs ipv6 ac battery fuse loop 
snd_hda_intel snd_pcm_oss snd_mixer_oss arc4 ecb snd_pcm 
crypto_blkcipher snd_timer video ath5k snd mac80211 backlight usblp 
led_class soundcore rng_core tpm_infineon intel_agp iTCO_wdt 
snd_page_alloc output iTCO_vendor_support i2c_i801 rtc_cmos tpm cfg80211 
i2c_core button tpm_bios evdev usbhid hid ext3 jbd mbcache sg sr_mod 
cdrom sd_mod crc_t10dif ohci1394 ata_piix libata scsi_mod ieee1394 dock 
ehci_hcd uhci_hcd sky2 thermal processor fan thermal_sys hwmon [last 
unloaded: kvm_intel]
[ 4953.736215] Pid: 0, comm: swapper Not tainted 2.6.27 #1
[ 4953.736218]
[ 4953.736219] Call Trace:
[ 4953.736223]  <IRQ>  [<ffffffff8023c9c4>] warn_on_slowpath+0x64/0xb0
[ 4953.736255]  [<ffffffffa0062ac8>] scsi_dispatch_cmd+0x128/0x2d0 
[scsi_mod]
[ 4953.736278]  [<ffffffffa0068e85>] scsi_request_fn+0x95/0x420 [scsi_mod]
[ 4953.736282]  [<ffffffff80346b25>] __blk_run_queue+0x65/0x110
[ 4953.736293]  [<ffffffffa00a06c8>] ata_sff_data_xfer+0x98/0xc0 [libata]
[ 4953.736297]  [<ffffffff80340000>] crypto_attr_alg_name+0x30/0x40
[ 4953.736307]  [<ffffffffa009fe9d>] ata_sff_hsm_move+0x47d/0x6a0 [libata]
[ 4953.736317]  [<ffffffffa0069693>] scsi_end_request+0xa3/0xb0 [scsi_mod]
[ 4953.736328]  [<ffffffffa00a0413>] ata_sff_interrupt+0x1a3/0x2c0 [libata]
[ 4953.736331]  [<ffffffff80283aa4>] handle_IRQ_event+0x34/0x70
[ 4953.736334]  [<ffffffff802850f0>] handle_edge_irq+0xc0/0x160
[ 4953.736337]  [<ffffffff8020f92c>] do_IRQ+0x7c/0x100
[ 4953.736339]  [<ffffffff8020c941>] ret_from_intr+0x0/0xa
[ 4953.736341]  <EOI>  [<ffffffffa000d637>] 
acpi_idle_enter_simple+0x1c7/0x237 [processor]
[ 4953.736352]  [<ffffffffa000d62d>] acpi_idle_enter_simple+0x1bd/0x237 
[processor]
[ 4953.736356]  [<ffffffff803eebf7>] cpuidle_idle_call+0xd7/0x120
[ 4953.736358]  [<ffffffff8020b306>] cpu_idle+0x66/0xf0
[ 4953.736360]
[ 4953.736361] ---[ end trace 8d1ccc07ba5c0659 ]---

