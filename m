Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbZDJKk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbZDJKk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763141AbZDJKkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:40:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:10726 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbZDJKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a34c5H1bn3QxhfTKAhgc0KbwQGa5pLvdxID+jjnnCtJRsXTZh7/BzJDsb+QApmSvT6
         JxXY+K8n/5RoiE5R/YhdX4B0/8wY3aIOiE+IafY1bKjxSQINy5jUMJHUqA3AgqI0tdoT
         6aRfQVqRvuJ7EgGQdC+FiBTwErM7sSdlH2wGk=
MIME-Version: 1.0
In-Reply-To: <20090409212028.7b2aa88c.akpm@linux-foundation.org>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
	 <20090409212028.7b2aa88c.akpm@linux-foundation.org>
Date: Fri, 10 Apr 2009 12:40:26 +0200
Message-ID: <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic: swapper/0/0x10000100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-bluetooth@vger.kernel.org,
       marcel@holtmann.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/10 Andrew Morton <akpm@linux-foundation.org>

> Did this get fixed?

On 2.6.30-rc1-git3 still the same:
[  162.541793] BUG: scheduling while atomic: swapper/0/0x10000100
[  162.541801] Modules linked in: i915 drm i2c_algo_bit i2c_core
rfcomm l2cap xt_tcpudp xt_limit xt_state iptable_filter
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
aes_i586 aes_generic cbc dm_crypt dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod hp_wmi rfkill fuse sbp2 loop btusb bluetooth
snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq pcmcia snd_timer
snd_seq_device uhci_hcd psmouse ohci1394 ehci_hcd b44 ssb intel_agp
snd yenta_socket rsrc_nonstatic pcmcia_core serio_raw ieee1394 usbcore
mii agpgart rtc_cmos rtc_core rtc_lib fan battery soundcore
snd_page_alloc button ac sg evdev
[  162.541945]
[  162.541952] Pid: 0, comm: swapper Not tainted (2.6.30-rc1-git3 #1)
HP Compaq nx6310 (EY501ES#AKD)
[  162.541960] EIP: 0060:[<c029f0e1>] EFLAGS: 00000246 CPU: 1
[  162.541973] EIP is at acpi_idle_enter_simple+0x15d/0x188
[  162.541979] EAX: c04f31c0 EBX: 0000099b ECX: 00000000 EDX: 01716000
[  162.541986] ESI: 00000000 EDI: f7071450 EBP: f7067f6c ESP: f7067f4c
[  162.541992]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  162.541999] CR0: 8005003b CR2: 0819d008 CR3: 2d828000 CR4: 000006d0
[  162.542006] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  162.542012] DR6: ffff0ff0 DR7: 00000400
[  162.542017] Call Trace:
[  162.542030]  [<c0310f6f>] cpuidle_idle_call+0x6f/0xd0
[  162.542039]  [<c0101f15>] cpu_idle+0x55/0x90
[  162.542048]  [<c0397ac8>] start_secondary+0x18d/0x205
[  162.542057]  [<c0395d38>] ? get_cpu_cap+0x9a/0xc2
[  175.336796] BUG: scheduling while atomic: swapper/0/0x10000100
[  175.336805] Modules linked in: i915 drm i2c_algo_bit i2c_core
rfcomm l2cap xt_tcpudp xt_limit xt_state iptable_filter
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
aes_i586 aes_generic cbc dm_crypt dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod hp_wmi rfkill fuse sbp2 loop btusb bluetooth
snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq pcmcia snd_timer
snd_seq_device uhci_hcd psmouse ohci1394 ehci_hcd b44 ssb intel_agp
snd yenta_socket rsrc_nonstatic pcmcia_core serio_raw ieee1394 usbcore
mii agpgart rtc_cmos rtc_core rtc_lib fan battery soundcore
snd_page_alloc button ac sg evdev
[  175.336948]
[  175.336956] Pid: 0, comm: swapper Not tainted (2.6.30-rc1-git3 #1)
HP Compaq nx6310 (EY501ES#AKD)
[  175.336964] EIP: 0060:[<c029f0e1>] EFLAGS: 00000246 CPU: 1
[  175.336977] EIP is at acpi_idle_enter_simple+0x15d/0x188
[  175.336984] EAX: c04f31c0 EBX: 00016912 ECX: 00000000 EDX: 01716000
[  175.336990] ESI: 00000000 EDI: f7071450 EBP: f7067f6c ESP: f7067f4c
[  175.336997]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  175.337003] CR0: 8005003b CR2: b7f79000 CR3: 2e75d000 CR4: 000006d0
[  175.337010] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  175.337016] DR6: ffff0ff0 DR7: 00000400
[  175.337021] Call Trace:
[  175.337033]  [<c0310f6f>] cpuidle_idle_call+0x6f/0xd0
[  175.337042]  [<c0101f15>] cpu_idle+0x55/0x90
[  175.337052]  [<c0397ac8>] start_secondary+0x18d/0x205
[  175.337060]  [<c0395d38>] ? get_cpu_cap+0x9a/0xc2
[  193.254798] BUG: scheduling while atomic: swapper/0/0x10000100
[  193.254806] Modules linked in: i915 drm i2c_algo_bit i2c_core
rfcomm l2cap xt_tcpudp xt_limit xt_state iptable_filter
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
aes_i586 aes_generic cbc dm_crypt dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod hp_wmi rfkill fuse sbp2 loop btusb bluetooth
snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq pcmcia snd_timer
snd_seq_device uhci_hcd psmouse ohci1394 ehci_hcd b44 ssb intel_agp
snd yenta_socket rsrc_nonstatic pcmcia_core serio_raw ieee1394 usbcore
mii agpgart rtc_cmos rtc_core rtc_lib fan battery soundcore
snd_page_alloc button ac sg evdev
[  193.254949]
[  193.254957] Pid: 0, comm: swapper Not tainted (2.6.30-rc1-git3 #1)
HP Compaq nx6310 (EY501ES#AKD)
[  193.254965] EIP: 0060:[<c029f0e1>] EFLAGS: 00000246 CPU: 1
[  193.254978] EIP is at acpi_idle_enter_simple+0x15d/0x188
[  193.254984] EAX: c04f31c0 EBX: 000017a8 ECX: 00000000 EDX: 01716000
[  193.254991] ESI: 00000000 EDI: f7071450 EBP: f7067f6c ESP: f7067f4c
[  193.254997]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  193.255004] CR0: 8005003b CR2: b7f79000 CR3: 2e75d000 CR4: 000006d0
[  193.255010] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  193.255016] DR6: ffff0ff0 DR7: 00000400
[  193.255021] Call Trace:
[  193.255034]  [<c0310f6f>] cpuidle_idle_call+0x6f/0xd0
[  193.255043]  [<c0101f15>] cpu_idle+0x55/0x90
[  193.255052]  [<c0397ac8>] start_secondary+0x18d/0x205
[  193.255061]  [<c0395d38>] ? get_cpu_cap+0x9a/0xc2
[  242.048045] hci_cmd_task: hci0 command tx timeout
[  246.048973] hci_cmd_task: hci0 command tx timeout


Regards

--
Maciej Rutecki
http://www.maciek.unixy.pl
