Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYIXRSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYIXRSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYIXRS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:18:26 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:42559 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYIXRSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:18:25 -0400
X-Greylist: delayed 2470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2008 13:18:25 EDT
Subject: Re: bug report
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Todor Gyumyushev <todor@saturnosoft.biz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48DA0B39.5050401@saturnosoft.biz>
References: <48DA0B39.5050401@saturnosoft.biz>
Content-Type: text/plain; charset=utf-8
Date: Wed, 24 Sep 2008 18:38:37 +0200
Message-Id: <1222274317.14959.4.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ons, 24 09 2008 kl. 12:41 +0300, skrev Todor Gyumyushev:
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-sff.c:944 ata_sff_hsm_move+0x4a9/0x6a0()
> Modules linked in: cdc_acm eth1394 vboxdrv isofs zlib_inflate ath5k 
> aes_generic nls_utf8 nls_cp437 vfat fat nls_base i915 drm kvm 
> acpi_cpufreq hci_usb rfcomm l2cap pktcdvd nfsd lockd nfs_acl auth_rpcgss 
> sunrpc exportfs fan ac battery microcode firmware_class loop usb_storage 
> usbhid snd_hda_intel arc4 snd_pcm_oss sg ecb crypto_blkcipher 
> snd_mixer_oss cryptomgr snd_pcm snd_timer tpm_infineon sr_mod usblp snd 
> rng_core cdrom ehci_hcd mac80211 thermal ohci1394 ieee1394 processor 
> evdev thermal_sys tpm uhci_hcd iTCO_wdt iTCO_vendor_support soundcore 
> cfg80211 tpm_bios sky2 hwmon snd_page_alloc intel_agp button [last 
> unloaded: ath5k]
> Pid: 0, comm: swapper Tainted: G        W 2.6.26.5 #6

This warning is not the first produced by your system, see the W flag in
the line above. Can you find an earlier warning in your dmesg/log? Or is
it similar to this one?

> Call Trace:
>  <IRQ>  [<ffffffff80236214>] warn_on_slowpath+0x64/0xc0
>  [<ffffffff803c9ec8>] ata_sff_data_xfer+0x98/0xc0
>  [<ffffffff803c96c9>] ata_sff_hsm_move+0x4a9/0x6a0
>  [<ffffffff803c9c13>] ata_sff_interrupt+0x1a3/0x2c0
>  [<ffffffff802748e4>] handle_IRQ_event+0x34/0x70
>  [<ffffffff80275e60>] handle_edge_irq+0xc0/0x160
>  [<ffffffff8020ebac>] do_IRQ+0x7c/0x100
>  [<ffffffff8020bc51>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff8021c800>] lapic_next_event+0x0/0x10
>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>  [<ffffffffa00564bc>] :processor:acpi_idle_enter_simple+0x1c5/0x235
>  [<ffffffffa00564b2>] :processor:acpi_idle_enter_simple+0x1bb/0x235
>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>  [<ffffffff803fbce7>] cpuidle_idle_call+0xd7/0x120
>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>  [<ffffffff80209410>] default_idle+0x0/0x50
>  [<ffffffff8020a720>] cpu_idle+0x60/0xd0
> 
> ---[ end trace 05ba06d61030bbb9 ]---
> 


Simon Holm Thøgersen

