Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZDGHhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZDGHhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZDGHhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:37:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49858 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZDGHhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JsnRenRebhjBkkIm1r1664l7Ye04zf2Y0VbeHVgFOe4dRU20OIcBWYoTMIF4MCSKlT
         7I0lfMw2L3QB2N0CjsBjnF1fYSVk7miIQbnyn2rG15L/L5K9nTZ6cgIoHZ0NKB9s4qQE
         FX1Odz7VEKZPFtLjNjfhg5tcJkc/PG25fYcr8=
MIME-Version: 1.0
Date: Tue, 7 Apr 2009 09:37:37 +0200
Message-ID: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
Subject: [2.6.29-git12] BUG: scheduling while atomic: swapper/0/0x10000100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-bluetooth@vger.kernel.org,
       marcel@holtmann.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug happens when try connect with my phone via kbluetooth (kde
application for bluetooth):

[  114.896824] BUG: scheduling while atomic: swapper/0/0x10000100
[  114.896831] Modules linked in: i915 drm i2c_algo_bit i2c_core
rfcomm l2cap vboxnetflt vboxdrv xt_tcpudp xt_limit xt_state
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
iptable_filter ip_tables x_tables aes_i586 aes_generic cbc dm_crypt
dm_snapshot dm_mirror dm_region_hash dm_log dm_mod hp_wmi fuse sbp2
loop btusb bluetooth snd_hda_codec_si3054 snd_hda_codec_analog
snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss snd_pcm ecb
snd_seq_dummy snd_seq_oss snd_seq_midi iwl3945 snd_rawmidi iwlcore
snd_seq_midi_event rfkill firmware_class snd_seq mac80211 snd_timer
snd_seq_device led_class pcmcia b44 ssb lib80211 uhci_hcd ehci_hcd
intel_agp psmouse snd ohci1394 mii cfg80211 usbcore agpgart
yenta_socket rsrc_nonstatic pcmcia_core serio_raw soundcore
snd_page_alloc rtc_cmos rtc_core rtc_lib battery fan ieee1394 ac
button sg evdev
[  114.896984]
[  114.896990] Pid: 0, comm: swapper Not tainted (2.6.29-git12 #1) HP
Compaq nx6310 (EY501ES#AKD)
[  114.896998] EIP: 0060:[<c029c711>] EFLAGS: 00000246 CPU: 1
[  114.897008] EIP is at acpi_idle_enter_simple+0x151/0x1be
[  114.897014] EAX: c04f31c0 EBX: f7073450 ECX: 00000000 EDX: 01716000
[  114.897036] ESI: 00f706bb EDI: 00f7113c EBP: f7067f6c ESP: f7067f4c
[  114.897042]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  114.897048] CR0: 8005003b CR2: b7fb1000 CR3: 004f7000 CR4: 000006d0
[  114.897054] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  114.897059] DR6: ffff0ff0 DR7: 00000400
[  114.897064] Call Trace:
[  114.897074]  [<c0310156>] ? menu_select+0x36/0xf0
[  114.897083]  [<c030f3bf>] cpuidle_idle_call+0x6f/0xd0
[  114.897091]  [<c0101f15>] cpu_idle+0x55/0x90
[  114.897099]  [<c0395d38>] start_secondary+0x18d/0x205
[  114.897107]  [<c0395d38>] ? start_secondary+0x18d/0x205

dmesg:
http://unixy.pl/maciek/download/kernel/2.6.29-git12/2/dmesg-2.6.29-git12.txt

config:
http://unixy.pl/maciek/download/kernel/2.6.29-git12/config-2.6.29-git12.txt

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
