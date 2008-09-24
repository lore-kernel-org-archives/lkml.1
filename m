Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYIXR4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYIXR4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYIXR4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:56:37 -0400
Received: from filter2.host.bg ([87.120.40.156]:34925 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIXR4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:56:36 -0400
Message-ID: <48DA7F1E.5030508@saturnosoft.biz>
Date: Wed, 24 Sep 2008 20:55:42 +0300
From: Todor Gyumyushev <todor@saturnosoft.biz>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: =?UTF-8?B?U2ltb24gSG9sbSBUaMO4Z2Vyc2Vu?= <odie@cs.aau.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: bug report
References: <48DA0B39.5050401@saturnosoft.biz> <1222274317.14959.4.camel@odie.local>
In-Reply-To: <1222274317.14959.4.camel@odie.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Holm Thøgersen wrote:
> ons, 24 09 2008 kl. 12:41 +0300, skrev Todor Gyumyushev:
>   
>> ------------[ cut here ]------------
>> WARNING: at drivers/ata/libata-sff.c:944 ata_sff_hsm_move+0x4a9/0x6a0()
>> Modules linked in: cdc_acm eth1394 vboxdrv isofs zlib_inflate ath5k 
>> aes_generic nls_utf8 nls_cp437 vfat fat nls_base i915 drm kvm 
>> acpi_cpufreq hci_usb rfcomm l2cap pktcdvd nfsd lockd nfs_acl auth_rpcgss 
>> sunrpc exportfs fan ac battery microcode firmware_class loop usb_storage 
>> usbhid snd_hda_intel arc4 snd_pcm_oss sg ecb crypto_blkcipher 
>> snd_mixer_oss cryptomgr snd_pcm snd_timer tpm_infineon sr_mod usblp snd 
>> rng_core cdrom ehci_hcd mac80211 thermal ohci1394 ieee1394 processor 
>> evdev thermal_sys tpm uhci_hcd iTCO_wdt iTCO_vendor_support soundcore 
>> cfg80211 tpm_bios sky2 hwmon snd_page_alloc intel_agp button [last 
>> unloaded: ath5k]
>> Pid: 0, comm: swapper Tainted: G        W 2.6.26.5 #6
>>     
>
> This warning is not the first produced by your system, see the W flag in
> the line above. Can you find an earlier warning in your dmesg/log? Or is
> it similar to this one?
>
>   
>> Call Trace:
>>  <IRQ>  [<ffffffff80236214>] warn_on_slowpath+0x64/0xc0
>>  [<ffffffff803c9ec8>] ata_sff_data_xfer+0x98/0xc0
>>  [<ffffffff803c96c9>] ata_sff_hsm_move+0x4a9/0x6a0
>>  [<ffffffff803c9c13>] ata_sff_interrupt+0x1a3/0x2c0
>>  [<ffffffff802748e4>] handle_IRQ_event+0x34/0x70
>>  [<ffffffff80275e60>] handle_edge_irq+0xc0/0x160
>>  [<ffffffff8020ebac>] do_IRQ+0x7c/0x100
>>  [<ffffffff8020bc51>] ret_from_intr+0x0/0xa
>>  <EOI>  [<ffffffff8021c800>] lapic_next_event+0x0/0x10
>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>  [<ffffffffa00564bc>] :processor:acpi_idle_enter_simple+0x1c5/0x235
>>  [<ffffffffa00564b2>] :processor:acpi_idle_enter_simple+0x1bb/0x235
>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>  [<ffffffff803fbce7>] cpuidle_idle_call+0xd7/0x120
>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>  [<ffffffff803fbc10>] cpuidle_idle_call+0x0/0x120
>>  [<ffffffff80209410>] default_idle+0x0/0x50
>>  [<ffffffff8020a720>] cpu_idle+0x60/0xd0
>>
>> ---[ end trace 05ba06d61030bbb9 ]---
>>
>>     
>
>
> Simon Holm Thøgersen
>
>
>   
Hi there,

yes you are correct, I found another one earlier, initially I thought is 
the same but it is not.

Regards,
Todor


------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:944 ata_sff_hsm_move+0x4a9/0x6a0()
Modules linked in: eth1394 vboxdrv isofs zlib_inflate ath5k aes_generic 
nls_utf8 nls_cp437 vfat fat nls_base i915 drm kvm acpi_cpufreq hci_usb 
rfcomm l2cap pktcdvd nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs fan 
ac battery microcode firmware_class loop usb_storage usbhid 
snd_hda_intel arc4 snd_pcm_oss sg ecb crypto_blkcipher snd_mixer_oss 
cryptomgr snd_pcm snd_timer tpm_infineon sr_mod usblp snd rng_core cdrom 
ehci_hcd mac80211 thermal ohci1394 ieee1394 processor evdev thermal_sys 
tpm uhci_hcd iTCO_wdt iTCO_vendor_support soundcore cfg80211 tpm_bios 
sky2 hwmon snd_page_alloc intel_agp button [last unloaded: ath5k]
Pid: 13270, comm: npviewer.bin Not tainted 2.6.26.5 #6

Call Trace:
 <IRQ>  [<ffffffff80236214>] warn_on_slowpath+0x64/0xc0
 [<ffffffff8032cf0b>] elv_next_request+0x12b/0x1f0
 [<ffffffff80252678>] getnstimeofday+0x48/0xc0
 [<ffffffff8024fe70>] ktime_get_ts+0x30/0x60
 [<ffffffff8024feac>] ktime_get+0xc/0x50
 [<ffffffff8022e58a>] hrtick_start_fair+0x12a/0x190
 [<ffffffff803c9ec8>] ata_sff_data_xfer+0x98/0xc0
 [<ffffffff803c96c9>] ata_sff_hsm_move+0x4a9/0x6a0
 [<ffffffff803c9c13>] ata_sff_interrupt+0x1a3/0x2c0
 [<ffffffff802748e4>] handle_IRQ_event+0x34/0x70
 [<ffffffff8023c44a>] __do_softirq+0x7a/0xf0
 [<ffffffff80275e60>] handle_edge_irq+0xc0/0x160
 [<ffffffff8020c8cc>] call_softirq+0x1c/0x30
 [<ffffffff8020ebac>] do_IRQ+0x7c/0x100
 [<ffffffff8020bc51>] ret_from_intr+0x0/0xa
 <EOI>
---[ end trace 05ba06d61030bbb9 ]---
