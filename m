Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbYFESDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbYFESDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYFESDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:03:08 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:7499 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYFESDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nXTMTJfPpef+IFRf4Ms2rVNVIOp8/bEhlzrNoXSYrjnpsu/9x9k5h777xprc7HETi+
         djtPU2Eczj6YbasCPc9RkF5UjhJjeEAqFPFfevyRI3drLxPOZkWVDTtm7XLFXrXSExDi
         Q0dwKrbnRZckA0WE+I4Be7qpuQArf2883UZy4=
Message-ID: <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com>
Date: Thu, 5 Jun 2008 21:03:03 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Thomas Backlund" <tmb@mandriva.org>
Subject: Re: iwl4965 oops in 2.6.25-rc5 x86_64
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <4848289D.1080205@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4848289D.1080205@mandriva.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 8:55 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> Hi,
> (please cc me on replies as I'm not subscribed)
>
> booting a 2.6.26-rc5 x86_64 kernel on a Acer TravelMate 6720G laptop with a
> Intel a/b/g/n wireless gets me this oops in syslog...
>
>> Jun  5 19:55:05 5720g kernel: firmware: requesting iwlwifi-4965-1.ucode
>> Jun  5 19:55:05 5720g kernel: Registered led device: iwl-phy0:radio
>> Jun  5 19:55:05 5720g kernel: Registered led device: iwl-phy0:assoc
>> Jun  5 19:55:05 5720g kernel: Registered led device: iwl-phy0:RX
>> Jun  5 19:55:05 5720g kernel: Registered led device: iwl-phy0:TX
>> Jun  5 19:55:05 5720g kernel: ADDRCONF(NETDEV_UP): wlan0: link is not
>> ready
>> Jun  5 19:55:06 5720g kernel: BUG: unable to handle kernel NULL pointer
>> dereference at 0000000000000000
>> Jun  5 19:55:06 5720g kernel: IP: [<ffffffffa020b64d>]
>> :iwl4965:iwl4965_enqueue_hcmd+0x12a/0x20f
>> Jun  5 19:55:06 5720g kernel: PGD 0 Jun  5 19:55:06 5720g kernel: Oops:
>> 0000 [1] SMP Jun  5 19:55:06 5720g kernel: CPU 1 Jun  5 19:55:06 5720g
>> kernel: Modules linked in: af_packet kvm_intel kvm kqemu snd_seq_dummy
>> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
>> snd_mixer_oss ipv6 xt_tcpudp iptable_filter ip_tables x_tables binfmt_misc
>> loop dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave
>> acpi_cpufreq freq_table tifm_sd tifm_7xx1 tifm_core nvram pcmcia
>> snd_hda_intel ohci1394 mmc_block ieee1394 i2c_i801 arc4 ecb sdhci
>> crypto_blkcipher firewire_ohci snd_pcsp battery firewire_core acer_wmi ac
>> snd_pcm container mmc_core video output crc_itu_t i2c_core iTCO_wdt thermal
>> snd_timer iTCO_vendor_support snd joydev iwl4965 wmi processor button
>> yenta_socket rsrc_nonstatic pcmcia_core firmware_class soundcore
>> snd_page_alloc sr_mod sg serio_raw evdev rtc_cmos nsc_ircc rtc_core rtc_lib
>> intel_agp iwlcore tg3 rfkill mac80211 led_class cdrom irda crc_ccitt
>> cfg80211 ide_generic piix ide_core ata_piix ahci libata dock sd_mod scsi_mod
>> ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [las
>
> t unloaded: nf_conntrack]
>>
>> Jun  5 19:55:06 5720g kernel: Pid: 10, comm: events/1 Not tainted
>> 2.6.26-0.rc5.1mdvsmp #1
>> Jun  5 19:55:06 5720g kernel: RIP: 0010:[<ffffffffa020b64d>]
>>  [<ffffffffa020b64d>] :iwl4965:iwl4965_enqueue_hcmd+0x12a/0x20f
>> Jun  5 19:55:06 5720g kernel: RSP: 0018:ffff81013fb15b90  EFLAGS: 00010086
>> Jun  5 19:55:06 5720g kernel: RAX: 0000000000000000 RBX: 0000000000000000
>> RCX: 0000000000000064
>> Jun  5 19:55:06 5720g kernel: RDX: 0000000000000022 RSI: 0000000000000000
>> RDI: ffff8100bf84c318
>> Jun  5 19:55:06 5720g kernel: RBP: ffff81013fb15be0 R08: ffff8100bf941100
>> R09: 0000000000000300
>> Jun  5 19:55:06 5720g kernel: R10: ffff81013fb15a60 R11: ffff81013fb10a78
>> R12: ffff8100bf84c300
>> Jun  5 19:55:06 5720g kernel: R13: ffff81013bc81f20 R14: ffff81013fb15d00
>> R15: 0000000000000002
>> Jun  5 19:55:06 5720g kernel: FS:  0000000000000000(0000)
>> GS:ffff81013fab8ac0(0000) knlGS:0000000000000000
>> Jun  5 19:55:06 5720g kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
>> 000000008005003b
>> Jun  5 19:55:06 5720g kernel: CR2: 0000000000000000 CR3: 0000000000201000
>> CR4: 00000000000026e0
>> Jun  5 19:55:06 5720g kernel: DR0: 0000000000000000 DR1: 0000000000000000
>> DR2: 0000000000000000
>> Jun  5 19:55:06 5720g kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
>> DR7: 0000000000000400
>> Jun  5 19:55:06 5720g kernel: Process events/1 (pid: 10, threadinfo
>> ffff81013fb14000, task ffff81013fb102c0)
>> Jun  5 19:55:06 5720g kernel: Stack:  ffffffff806f9de8 ffffffff8075c1e0
>> ffff81013bc82968 006881013fb10a10
>> Jun  5 19:55:06 5720g kernel:  0000000000000006 ffff81013d1a5d00
>> ffff81013fb15d00 ffff81013bc81f20
>> Jun  5 19:55:06 5720g kernel:  0000000000000246 ffff81013d1a5dac
>> ffff81013fb15c60 ffffffffa018ee37
>> Jun  5 19:55:06 5720g kernel: Call Trace:
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa018ee37>]
>> :iwlcore:iwl_send_cmd_sync+0x94/0x257
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff80257ed5>] ?
>> __lock_acquire+0xbee/0xd5a
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa018f04b>]
>> :iwlcore:iwl_send_cmd+0x16/0x1b
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa0218c41>]
>> :iwl4965:iwl_send_static_wepkey_cmd+0xcb/0xd5
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa0218cef>]
>> :iwl4965:iwl_set_default_wep_key+0xa4/0xbe
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa020ae00>]
>> :iwl4965:iwl4965_mac_set_key+0xf1/0x137
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa01543f4>]
>> :mac80211:__ieee80211_key_todo+0x106/0x200
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa0154594>]
>> :mac80211:ieee80211_key_todo+0x17/0x25
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa01545ab>]
>> :mac80211:key_todo+0x9/0xb
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff80247104>]
>> run_workqueue+0xfc/0x203
>> Jun  5 19:55:06 5720g kernel:  [<ffffffffa01545a2>] ?
>> :mac80211:key_todo+0x0/0xb
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff802472eb>]
>> worker_thread+0xe0/0xf1
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff8024acac>] ?
>> autoremove_wake_function+0x0/0x38
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff8024720b>] ?
>> worker_thread+0x0/0xf1
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff8024a97b>] kthread+0x49/0x76
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff8020d248>] child_rip+0xa/0x12
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff8020c7dc>] ?
>> restore_args+0x0/0x30
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff8024a932>] ? kthread+0x0/0x76
>> Jun  5 19:55:06 5720g kernel:  [<ffffffff8020d23e>] ? child_rip+0x0/0x12
>> Jun  5 19:55:06 5720g kernel: Jun  5 19:55:06 5720g kernel: Jun  5
>> 19:55:06 5720g kernel: Code: 69 c8 80 01 00 00 41 8a 06 4d 89 cc 4d 03 a5 c0
>> 44 00 00 41 88 44 24 14 4c 89 e7 f3 a5 49 8d 7c 24 18 41 0f b7 4e 02 49 8b
>> 76 18 <f3> a4 41 c6 44 24 15 00 41 0f b6 95 94 44 00 00 89 d0 80 cc 04 Jun
>>  5 19:55:06 5720g kernel: RIP  [<ffffffffa020b64d>]
>> :iwl4965:iwl4965_enqueue_hcmd+0x12a/0x20f
>> Jun  5 19:55:06 5720g kernel:  RSP <ffff81013fb15b90>
>> Jun  5 19:55:06 5720g kernel: CR2: 0000000000000000
>> Jun  5 19:55:06 5720g kernel: ---[ end trace c03f2ff7573a0188 ]---
>
>
> and shortly after the system locks up hard...
>
> Config is here:
> http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel-linus/current/SOURCES/x86_64-smp.config?revision=215259&view=markup
>
> lspci -vvv about the card:
>>
>> 04:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN
>> Network Connection (rev 61)
>>        Subsystem: Intel Corporation Device 1101
>>                                  Control: I/O- Mem+ BusMaster+ SpecCycle-
>> MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR+ <PERR- INTx-        Latency: 0, Cache Line Size: 64
>> bytes
>>  Interrupt: pin A routed to IRQ 11
>>                                  Region 0: Memory at f8000000 (64-bit,
>> non-prefetchable) [size=8K]
>>  Capabilities: <access denied>
>>                                  Kernel modules: iwl4965
>>
>
> So far I have tested 2.6.26-rc3,rc4,rc5 and all ends up with this oops
>
> If I remove the wlan0 config the kernel will boot, but as soon as I try to
> configure it, I get a lockup...
>
> If it makes any difference, I'm trying to connect to a WPA2-personal
> encrypted wifi on a Dlink DIR-655 Draft-N router...
>
> The last kernel that I used that works was a 2.6.24.7 series kernel
> (I haven't yet tried to see if the 2.6.25.x kernel works)
>
> I thought of posting it here before trying to dig into it any deeper...
>
> Any thoughts?
>
> --
> Thomas
>
Can you please verify with latest wireless-testing. git
Thanks
Tomas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
