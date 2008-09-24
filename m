Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYIXJmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYIXJmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYIXJmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:42:09 -0400
Received: from filter2.host.bg ([87.120.40.156]:50653 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbYIXJmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:42:08 -0400
Message-ID: <48DA0B39.5050401@saturnosoft.biz>
Date: Wed, 24 Sep 2008 12:41:13 +0300
From: Todor Gyumyushev <todor@saturnosoft.biz>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bug report
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:944 ata_sff_hsm_move+0x4a9/0x6a0()
Modules linked in: cdc_acm eth1394 vboxdrv isofs zlib_inflate ath5k 
aes_generic nls_utf8 nls_cp437 vfat fat nls_base i915 drm kvm 
acpi_cpufreq hci_usb rfcomm l2cap pktcdvd nfsd lockd nfs_acl auth_rpcgss 
sunrpc exportfs fan ac battery microcode firmware_class loop usb_storage 
usbhid snd_hda_intel arc4 snd_pcm_oss sg ecb crypto_blkcipher 
snd_mixer_oss cryptomgr snd_pcm snd_timer tpm_infineon sr_mod usblp snd 
rng_core cdrom ehci_hcd mac80211 thermal ohci1394 ieee1394 processor 
evdev thermal_sys tpm uhci_hcd iTCO_wdt iTCO_vendor_support soundcore 
cfg80211 tpm_bios sky2 hwmon snd_page_alloc intel_agp button [last 
unloaded: ath5k]
Pid: 0, comm: swapper Tainted: G        W 2.6.26.5 #6

Call Trace:
 <IRQ>  [<ffffffff80236214>] warn_on_slowpath+0x64/0xc0
 [<ffffffff803c9ec8>] ata_sff_data_xfer+0x98/0xc0
 [<ffffffff803c96c9>] ata_sff_hsm_move+0x4a9/0x6a0
 [<ffffffff803c9c13>] ata_sff_interrupt+0x1a3/0x2c0
 [<ffffffff802748e4>] handle_IRQ_event+0x34/0x70
 [<ffffffff80275e60>] handle_edge_irq+0xc0/0x160
 [<ffffffff8020ebac>] do_IRQ+0x7c/0x100
 [<ffffffff8020bc51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8021c800>] lapic_next_event+0x0/0x10
 [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
 [<ffffffffa00564bc>] :processor:acpi_idle_enter_simple+0x1c5/0x235
 [<ffffffffa00564b2>] :processor:acpi_idle_enter_simple+0x1bb/0x235
 [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
 [<ffffffff803fbce7>] cpuidle_idle_call+0xd7/0x120
 [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
 [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
 [<ffffffff80209410>] default_idle+0x0/0x50
 [<ffffffff8020a720>] cpu_idle+0x60/0xd0

---[ end trace 05ba06d61030bbb9 ]---

