Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYLDL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYLDL0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYLDL0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:26:03 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:35697 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYLDL0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:26:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IxL9FqSDV33J9ZpuJXBbjNWa4iykAbA1n6rDc3PpSZhq8ObN8g981TfQQJTwJy2wVI
         0eUrPv+wuWwRzKGPanu0b5Umv6KPdqHm3ivcRUShh5NzwIWm/Vkizdz9rZ+wBqiQkpua
         c/k7taBVXn2ZfSSlSdQ7Vcpu4iXKg8zuZXopY=
Message-ID: <b8d38c530812040325y12b81804i8af28c86bbe29203@mail.gmail.com>
Date: Thu, 4 Dec 2008 12:25:57 +0100
From: "Thomas Pegeot" <thomas.pegeot@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Some problems with Hauppauge HVR-1100 on 2.6.27
In-Reply-To: <200811151614.53883.thomas.pegeot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811151614.53883.thomas.pegeot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've just tested my card on a Debian Sid running on a 2.6.27 kernel
(coming from http://kernel-archive.buildserver.net/debian-kernel) and
it still doesn't work :

  232.430136] CPU 0
[  232.430137] Modules linked in: nls_utf8 cifs nls_base ppdev lp ipv6
fuse loop firewire_sbp2 snd_usb_audio snd_usb_lib snd_seq_midi
snd_rawmidi snd_hwdep rtc_cmos rtc_core rtc_lib cx22702 cx88_dvb
pcspkr cx88_vp3054_i2c videobuf_dvb dvb_core k8temp tuner_simple
tuner_types snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss tuner
snd_mixer_oss cx88_alsa snd_pcm cx8800 cx8802 cx88xx ir_common
snd_seq_dummy i2c_algo_bit tveeprom v4l2_common videobuf_dma_sg
videobuf_core btcx_risc snd_seq_oss snd_seq_midi_event snd_seq
snd_timer snd_seq_device snd soundcore snd_page_alloc gspca_zc3xx
gspca_main compat_ioctl32 videodev v4l1_compat parport_pc parport
button i2c_nforce2 i2c_core joydev evdev ext3 jbd mbcache ide_cd_mod
cdrom sd_mod usbhid hid ff_memless usb_storage amd74xx ide_pci_generic
ide_core floppy sky2 firewire_ohci firewire_core sata_nv ata_generic
crc_itu_t libata forcedeth scsi_mod dock ehci_hcd ohci_hcd thermal
processor fan thermal_sys
[  232.430184] Pid: 3234, comm: kdvb-fe-0 Not tainted 2.6.27-1-amd64 #1
[  232.430186] RIP: 0010:[<ffffffffa02ee378>]  [<ffffffffa02ee378>]
simple_dvb_calc_regs+0xac/0x247 [tuner_simple]
[  232.430195] RSP: 0018:ffff880066d01d60  EFLAGS: 00010246
[  232.430197] RAX: 000000001d34ce80 RBX: ffff88007d9904c0 RCX: 0000000000000000
[  232.430199] RDX: 0000000000000000 RSI: ffffffffa02ea580 RDI: ffff880037921010
[  232.430201] RBP: ffff880066d01e00 R08: ffff880066d01db6 R09: ffff880066d07cc8
[  232.430203] R10: ffff88000101b400 R11: 0000000000000202 R12: ffff880066d01e04
[  232.430205] R13: ffff88007d9904c0 R14: ffff880037921808 R15: ffff880037921010
[  232.430207] FS:  0000000041046950(0000) GS:ffffffff80589a00(0000)
knlGS:0000000000000000
[  232.430210] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  232.430211] CR2: 00000000410429c8 CR3: 000000006dcd5000 CR4: 00000000000006e0
[  232.430214] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  232.430216] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  232.430218] Process kdvb-fe-0 (pid: 3234, threadinfo
ffff880066d00000, task ffff88007fbb7440)
[  232.430220] Stack:  ffff88006e6345c0 000000001d12fd16
ffff88000101b400 ffff88006e634608
[  232.430224]  ffff880066d01dc0 ffffffffa02e9700 ffff88007fbb7440
ffffffff802380be
[  232.430227]  ffff880066d01e01 0000000000000000 8e01ffff00001ea0
ffff88007d9904c0
[  232.430230] Call Trace:
[  232.430236]  [<ffffffff802380be>] ? finish_task_switch+0x2b/0xc4
[  232.430241]  [<ffffffffa02ef811>] ? simple_dvb_set_params+0x40/0xc1
[tuner_simple]
[  232.430245]  [<ffffffffa031f551>] ? cx22702_set_tps+0x1f/0x1c5 [cx22702]
[  232.430258]  [<ffffffffa02fdb26>] ?
dvb_frontend_swzigzag_autotune+0x189/0x1b1 [dvb_core]
[  232.430266]  [<ffffffffa02fe381>] ?
dvb_frontend_swzigzag+0x1b8/0x21c [dvb_core]
[  232.430271]  [<ffffffff80252d79>] ? down_interruptible+0x34/0x3b
[  232.430279]  [<ffffffffa02ff124>] ? dvb_frontend_thread+0x25b/0x2ef
[dvb_core]
[  232.430282]  [<ffffffff8024f731>] ? autoremove_wake_function+0x0/0x2e
[  232.430290]  [<ffffffffa02feec9>] ? dvb_frontend_thread+0x0/0x2ef [dvb_core]
[  232.430293]  [<ffffffff8024f60a>] ? kthread+0x47/0x75
[  232.430296]  [<ffffffff802392c3>] ? schedule_tail+0x27/0x5f
[  232.430299]  [<ffffffff802113b9>] ? child_rip+0xa/0x11
[  232.430301]  [<ffffffff8024f5c3>] ? kthread+0x0/0x75
[  232.430303]  [<ffffffff802113af>] ? child_rip+0x0/0x11
[  232.430305]
[  232.430306]
[  232.430307] Code: 48 89 44 24 40 48 8b 05 a7 40 00 00 8b 4a 1c 0f
b7 40 0a 03 44 24 50 89 ca d1 ea 03 15 a2 40 00 00 69 c0 24 f4 00 00
01 d0 31 d2 <f7> f1 48 8d 4d 02 89 c3 c1 e8 08 88 45 01 48 8d 45 03 48
89 4c
[  232.430327] RIP  [<ffffffffa02ee378>]
simple_dvb_calc_regs+0xac/0x247 [tuner_simple]
[  232.430331]  RSP <ffff880066d01d60>
[  232.430333] ---[ end trace 3d6b38a5baff2cc3 ]--

Do you have any idea about this problem ?

Thank you in advance. ;)

On Sat, Nov 15, 2008 at 4:14 PM, Thomas PEGEOT <thomas.pegeot@gmail.com> wrote:
> Hello,
> I've having some problems with my Hauppauge HVR-1100 (cx88-based chipset). My
> DVB card works like a charm on 2.6.27-rc4 (full .config :
> http://omploader.org/veGd1) but doesn't work any
> more on newer kernels.
>
> When i try to use my DVB card on 2.6.27.6, i get these errors in dmesg :
> divide error: 0000 [1] PREEMPT
> CPU 0
> Modules linked in: nouveau drm w83627hf hwmon_vid sky2 forcedeth i2c_nforce2
> k8temp
> Pid: 2678, comm: kdvb-fe-0 Not tainted 2.6.27.6 #1
> RIP: 0010:[<ffffffff8043f4bf>]  [<ffffffff8043f4bf>] simple_dvb_calc_regs+0x9c/0x227
> RSP: 0018:ffff880076a35d30  EFLAGS: 00010246
> RAX: 00000000217f7080 RBX: ffff880076a35db0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff807e1a00 RDI: ffff88007fbc8810
> RBP: ffff880076a35da0 R08: ffff880076a35d76 R09: 0000000000000000
> R10: 00007fffb8cd9ff8 R11: 0000000000000202 R12: ffff88007f16bba0
> R13: ffff88007f16bba0 R14: ffff88007fbc8c08 R15: ffff88007fbc8810
> FS:  00007f66af02a750(0000) GS:ffffffff80815e80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00007f66ae30aeb5 CR3: 000000006fa1f000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kdvb-fe-0 (pid: 2678, threadinfo ffff880076a34000, task ffff880066081630)
> Stack:  ffffffff8088e9d8 ffff8800768e9678 ffff880076a35d70 ffffffff8022513d
>  0000000000000001 ffff8800768e9668 ffffffff807e0b80 00000013fe9c93db
>  8e01880000002320 ffff88007fbc8810 ffff88007f16bba0 0000000000000000
> Call Trace:
>  [<ffffffff8022513d>] ? __dequeue_entity+0x61/0x6a
>  [<ffffffff8043f861>] simple_dvb_set_params+0x3e/0x9b
>  [<ffffffff80484d92>] cx22702_set_tps+0x28/0x1d0
>  [<ffffffff8047e88e>] dvb_frontend_swzigzag_autotune+0x190/0x1b7
>  [<ffffffff8047f09e>] dvb_frontend_swzigzag+0x1bc/0x21e
>  [<ffffffff8047f456>] dvb_frontend_thread+0x356/0x43a
>  [<ffffffff8047f100>] ? dvb_frontend_thread+0x0/0x43a
>  [<ffffffff802403b5>] kthread+0x49/0x76
>  [<ffffffff8020c059>] child_rip+0xa/0x11
>  [<ffffffff8024036c>] ? kthread+0x0/0x76
>  [<ffffffff8020c04f>] ? child_rip+0x0/0x11
>
>
> Code: 8b 45 c0 31 d2 44 8b 48 1c 48 8b 05 bc 2d 4b 00 44 89 c9 0f b7 40 0a d1
> e9 03 45 d0 03 0d ba 2d 4b 00 69 c0 24 f4 00 00 8d 04 01 <41> f7 f1 8a 55 d6
> 41 89 c4 88 53 04 c1 e8 08 44 88 63 02 88 43
> RIP  [<ffffffff8043f4bf>] simple_dvb_calc_regs+0x9c/0x227
>  RSP <ffff880076a35d30>
> ---[ end trace f8338edded65e015 ]---
>
>
> So i tried another configuration according to the Gentoo Wiki and it still
> fails :
> CONFIG_DVB=y
> CONFIG_DVB_CORE=y
> CONFIG_DVB_CX22700=m
> CONFIG_DVB_CX22702=y
> CONFIG_VIDEO_CX88_VP3054=m
> CONFIG_VIDEO_CX88=m
> CONFIG_VIDEO_CX88_ALSA=m
> CONFIG_VIDEO_CX88_DVB=m
> CONFIG_VIDEO_CX88_DVB_ALL_FRONTENDS=y
>
> So i'm stuck in an "old" 2.6.27-rc4 since i can't get my card working on newer
> kernels.
>
> If you need anything, feel free to ask me. ;)
>
> Thank in advance.
>
>
>
