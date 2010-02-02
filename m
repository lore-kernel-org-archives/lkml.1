Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0BBOVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:21:50 -0500
Received: from n77.bullet.mail.sp1.yahoo.com ([98.136.44.45]:20559 "HELO
	n77.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755792Ab0BBOVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:21:48 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 336468.32629.bm@omp608.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ameritech.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=yVVofNnA+4/rDt2ZeSQov9QOpN9YKIST4ZYd1AS3kxgIvIDPzRREPcEBd4Syq34KH94Q/yfrsJ92mF5kvFZvNiSqMrc6n0e3NAw3wxB6JwNBYemop+KRtg9UdlDZmHDrJAc1OQOgNh76j9HSYBBE03kcGtmKHUHH2HgRZIoFBBg=;
Message-ID: <73211.74714.qm@web180714.mail.sp1.yahoo.com>
X-YMail-OSG: .DDCn1oVM1lQU1b_oLUrKaQuq4S78nLtbzmYTzkVuG0RDy326KRExrVzt8X8y2tbCrUF1RWwX_gMofWlrHRZRoZGp3mu6Fe2c.0M_vE3GO87G6gVRGSagwL30eVi6LvQbi5DWYzTfg6PkDSJSpQoNWyUQLRnFVNzk5uLB_1_5CnUOHjNoKbYuzjebUO865pwUiulfL974C4if86TlWzeGeInyKV1jpqyA_pwD0K5p0bRyt4JsE.ii_qfpJpiTaRUEDmOphWY3dScF_7HE0Oa9cFiEDP5Jtjo
X-Mailer: YahooMailRC/272.7 YahooMailWebService/0.8.100.260964
Date: Tue, 2 Feb 2010 06:21:46 -0800 (PST)
From: Frederick V Heitkamp <heitkamp@ameritech.net>
Subject: Crash 2.6.32.x, Echo 3G, Alsa, SCSI
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repeatable Hard Crash.
What else do I need to provide?
Thanks!

Fred



[ 5484.995249] WriteControlReg: not written, no change
[ 5485.069621] divide error: 0000 [#1] pcm_hw_params ok
[ 5485.070159] Prepare rate=44100 format=2 channels=2
[ 5485.070161] set_audio_format[14] = 5
[ 5485.070166] Prepare rate=44100 format=2 channels=2
[ 5485.070167] set_audio_format[14] = 5
[ 5485.070003] PREEMPT SMP 
[ 5485.070003] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:0a:01.0/sound/card0/uevent
[ 5485.070003] Modules linked in: radeon ttm drm_kms_helper i2c_algo_bit jfs dme1737 hwmon_vid coretemp ipv6 snd_hda_codec_atihdmi snd_hda_intel snd_echo3g snd_hda_codec snd_rawmidi snd_seq_device snd_hwdep snd_pcm snd_timer snd st i3000_edac rtc_cmos parport_pc soundcore shpchp parport rtc_core snd_page_alloc i2c_i801 rtc_lib sr_mod pci_hotplug usblp container edac_core cdrom rng_core joydev sg evdev firewire_sbp2 firewire_ohci firewire_core crc_itu_t hangcheck_timer drm cryptoloop loop video output thermal processor fan button microcode cpuid usbhid uhci_hcd ehci_hcd
[ 5485.070003] 
[ 5485.070003] Pid: 5871, comm: rsync Not tainted (2.6.32.3 #14) empty
[ 5485.070003] EIP: 0060:[<f87aa037>] EFLAGS: 00010246 CPU: 0
[ 5485.070003] EIP is at pcm_pointer+0x37/0x70 [snd_echo3g]
[ 5485.070003] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[ 5485.070003] ESI: f695e5c0 EDI: 00000000 EBP: cd11d2c0 ESP: eb39ff04
[ 5485.070003]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 5485.070003] Process rsync (pid: 5871, ti=eb39e000 task=f71b6180 task.ti=eb39e000)
[ 5485.070003] Stack:
[ 5485.070003]  c104764e 0000000e f695e5c0 f6b20000 00000000 f87ac9bf 00000024 00000009
[ 5485.070003] <0> f6a7f400 00000246 00000000 f66068c0 00000000 00000000 00000000 c107a5d5
[ 5485.070003] <0> c14f4a24 c107e375 c103fe7a 00000010 17a61f80 000004fd c14f5380 c14f53bc
[ 5485.070003] Call Trace:
[ 5485.070003]  [<c104764e>] ? run_timer_softirq+0x17e/0x2e0
[ 5485.070003]  [<f87ac9bf>] ? snd_echo_interrupt+0x11f/0x240 [snd_echo3g]
[ 5485.070003]  [<c107a5d5>] ? handle_IRQ_event+0x45/0x190
[ 5485.070003]  [<c107e375>] ? rcu_process_callbacks+0x35/0x40
[ 5485.070003]  [<c103fe7a>] ? __do_softirq+0xba/0x200
[ 5485.070003]  [<c107c235>] ? handle_fasteoi_irq+0x65/0xd0
[ 5485.070003]  [<c1005955>] ? handle_irq+0x15/0x30
[ 5485.070003]  [<c1004ec7>] ? do_IRQ+0x47/0xc0
[ 5485.070003]  [<c10401a5>] ? irq_exit+0x35/0x50
[ 5485.070003]  [<c1019584>] ? smp_apic_timer_interrupt+0x54/0x90
[ 5485.070003]  [<c10035e9>] ? common_interrupt+0x29/0x30
[ 5485.070003] Code: 40 70 8b a8 ac 00 00 00 8b 45 00 8b 00 89 c1 2b 4d 04 03 4d 08 89 45 04 89 4d 08 8b 46 70 8b 58 4c 8b 78 40 8d 04 cd 00 00 00 00 <f7> f3 39 c7 77 2a 89 fa 29 f8 f7 da 89 14 24 eb 08 8b 46 70 8b 
[ 5485.070003] EIP: [<f87aa037>] pcm_pointer+0x37/0x70 [snd_echo3g] SS:ESP 0068:eb39ff04
[ 5485.785994] ---[ end trace 6967d8f15086f11c ]---
[ 5485.799787] Kernel panic - not syncing: Fatal exception in interrupt
[ 5485.818780] Pid: 5871, comm: rsync Tainted: G      D    2.6.32.3 #14
[ 5485.837766] Call Trace:
[ 5485.845052]  [<c13c249e>] ? panic+0x4d/0xf1
[ 5485.857547]  [<c1006a8e>] ? oops_end+0x8e/0x90
[ 5485.870820]  [<c100423c>] ? do_divide_error+0x7c/0x90
[ 5485.885922]  [<f87aa037>] ? pcm_pointer+0x37/0x70 [snd_echo3g]
[ 5485.903349]  [<c1009268>] ? sched_clock+0x8/0x10
[ 5485.917147]  [<f870f039>] ? snd_pcm_update_hw_ptr_pos+0x19/0xd0 [snd_pcm]
[ 5485.937433]  [<c105d1d0>] ? ktime_get_ts+0xd0/0x100
[ 5485.951994]  [<c13c52a6>] ? error_code+0x66/0x6c
[ 5485.965788]  [<c10041c0>] ? do_divide_error+0x0/0x90
[ 5485.980619]  [<f87aa037>] ? pcm_pointer+0x37/0x70 [snd_echo3g]
[ 5485.998047]  [<c104764e>] ? run_timer_softirq+0x17e/0x2e0
[ 5486.014175]  [<f87ac9bf>] ? snd_echo_interrupt+0x11f/0x240 [snd_echo3g]
[ 5486.033940]  [<c107a5d5>] ? handle_IRQ_event+0x45/0x190
[ 5486.049537]  [<c107e375>] ? rcu_process_callbacks+0x35/0x40
[ 5486.066169]  [<c103fe7a>] ? __do_softirq+0xba/0x200
[ 5486.080727]  [<c107c235>] ? handle_fasteoi_irq+0x65/0xd0
[ 5486.096584]  [<c1005955>] ? handle_irq+0x15/0x30
[ 5486.110360]  [<c1004ec7>] ? do_IRQ+0x47/0xc0
[ 5486.123098]  [<c10401a5>] ? irq_exit+0x35/0x50
[ 5486.136357]  [<c1019584>] ? smp_apic_timer_interrupt+0x54/0x90
[ 5486.153770]  [<c10035e9>] ? common_interrupt+0x29/0x30

