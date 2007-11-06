Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbXKFBsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbXKFBsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXKFBsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:48:37 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:41616 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753574AbXKFBsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:48:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=phuNEh4COJ5HqFS0sfcBU8J97FpcTuD9x98awWmhLRnkVUc2MdfiVZRnIazQccf6xF9tpuwQ+xRdGY2s8uaoIHXW2ZwSjNfpysTTlnjm2Of/hX6EvPXaTwlZckFC24Pl1eNQ44uar4r0a/J2yz9la3uXUdEZ5fYE45r11vbX1mQ=
Message-ID: <a8e1da0711051748u4a0d2d57t4bad26e4f02f559e@mail.gmail.com>
Date: Tue, 6 Nov 2007 09:48:33 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Subject: Re: [Bluez-devel] [BUG] rfcomm]
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <9e0cf0bf0711050746s5f7910d8teb3c8ae9530b549e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <a8e1da0711042108r7cea1a46s8d8b93795c314119@mail.gmail.com>
	 <9e0cf0bf0711050746s5f7910d8teb3c8ae9530b549e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/07, Alon Bar-Lev <alon.barlev@gmail.com> wrote:
> On 11/5/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> > Hi,
> > I managed to produce this bug last weekend. I debugged it and found a
> > rfcomm_dev refcnt BUG.
> > please try the patch of attachment, sorry for attachement because of
> > my gmail/mutt configuration problem.
> >
> > I post it in below thread:
> > http://lkml.org/lkml/2007/11/4/207
>
> It actually worse... :(

could you tell me your usage steps of rfcomm?

Oct 23 19:41:42 alon1 EIP:    0060:[<c01c575b>]    Tainted: P        VLI
Your kernel seems tainted.

Regards
dave

>
> Best Regards,
> Alon Bar-Lev
>
> ---
>
> terrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
> ieee80211_crypt: registered algorithm 'NULL'
> ieee80211: 802.11 data/management/control stack, git-1.1.13
> ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
> ipw2200: Copyright(c) 2003-2006 Intel Corporation
> Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0
> serio: Synaptics pass-through port at isa0060/serio1/input0
> input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input2
> pnp: Device 00:0c activated.
> nsc-ircc, chip->init
> nsc-ircc, Found chip at base=0x02e
> nsc-ircc, driver loaded (Dag Brattli)
> IrDA: Registered device irda0
> nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
> e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:11:25:2e:e5:1f
> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> Yenta: CardBus bridge found at 0000:02:00.1 [1014:0552]
> Yenta: Using INTVAL to route CSC interrupts to PCI
> Yenta: Routing CardBus interrupts to PCI
> Yenta TI: socket 0000:02:00.1, mfunc 0x01d21b22, devctl 0x64
> Yenta: ISA IRQ mask 0x04b0, PCI irq 11
> Socket status: 30000086
> pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
> pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
> pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
> ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level,
> low) -> IRQ 11
> PCI: Setting latency timer of device 0000:00:1f.5 to 64
> udev: renamed network interface eth0 to eth1
> usb 2-1: new full speed USB device using uhci_hcd and address 3
> usb 2-1: configuration #1 chosen from 1 choice
> usb 3-1: new full speed USB device using uhci_hcd and address 2
> usb 3-1: configuration #1 chosen from 1 choice
> Bluetooth: Core ver 2.11
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> Bluetooth: HCI USB driver ver 2.9
> intel8x0_measure_ac97_clock: measured 50304 usecs
> intel8x0: clocking to 48000
> ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKC] -> GSI 11 (level,
> low) -> IRQ 11
> ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
> usb 3-2: new full speed USB device using uhci_hcd and address 3
> usb 3-2: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver hci_usb
> ipw2200: Detected geography ZZR (14 802.11bg channels, 0 802.11a channels)
> IBM TrackPoint firmware: 0x0e, buttons: 3/3
> input: TPPS/2 IBM TrackPoint as
> /devices/platform/i8042/serio1/serio2/input/input3
> EXT3 FS on loop5, internal journal
> NET: Registered protocol family 17
> Non-volatile memory driver v1.2
> thinkpad_acpi: ThinkPad ACPI Extras v0.16
> thinkpad_acpi: http://ibm-acpi.sf.net/
> thinkpad_acpi: ThinkPad BIOS 1RETDPWW (3.21 ), EC 1RHT71WW-3.04
> thinkpad_acpi: IBM ThinkPad T42
> input: ThinkPad Extra Buttons as /devices/virtual/input/input4
> hdaps: IBM ThinkPad T42 detected.
> hdaps: initial latch check good (0x01).
> hdaps: device successfully initialized.
> input: hdaps as /devices/platform/hdaps/input/input5
> hdaps: driver successfully loaded.
> ACPI: AC Adapter [AC] (on-line)
> ACPI: Battery Slot [BAT0] (battery present)
> input: Power Button (FF) as /devices/virtual/input/input6
> ACPI: Power Button (FF) [PWRF]
> input: Lid Switch as /devices/virtual/input/input7
> ACPI: Lid Switch [LID]
> input: Sleep Button (CM) as /devices/virtual/input/input8
> ACPI: Sleep Button (CM) [SLPB]
> ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> ACPI: Processor [CPU] (supports 8 throttling states)
> ACPI: Thermal Zone [THM0] (57 C)
> Marking TSC unstable due to: possible TSC halt in C2.
> Time: acpi_pm clocksource has been installed.
> IBM machine detected. Enabling interrupts during APM calls.
> apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
> dazuko: loaded, version=2.3.4
> io scheduler cfq registered
> Module ioatdma cannot be unloaded due to unsafe usage in
> drivers/dma/ioatdma.c:805
> PPP generic driver version 2.4.2
> SCSI subsystem initialized
> Adding 1465120k swap on /dev/loop/4.  Priority:-1 extents:1 across:1465120k
> hda: selected mode 0x45
> hda: cache flushes supported
> hdc: selected mode 0x42
> hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
> hdc: UDMA speeds >UDMA33 cannot be set
> Bluetooth: L2CAP ver 2.8
> Bluetooth: L2CAP socket layer initialized
> Bluetooth: RFCOMM socket layer initialized
> Bluetooth: RFCOMM TTY layer initialized
> Bluetooth: RFCOMM ver 1.8
> ip_tables: (C) 2000-2006 Netfilter Core Team
> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> eth0: Setting MAC to 00:a0:68:7c:46:06
> fbcondecor: console 1 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 1
> fbcondecor: console 2 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 2
> fbcondecor: console 3 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 3
> fbcondecor: console 4 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 4
> fbcondecor: console 5 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 5
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> ADDRCONF(NETDEV_UP): eth1: link is not ready
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> audit(1194276481.266:2): audit_pid=6656 old=0 by auid=4294967295
> [drm] Initialized drm 1.1.0 20060810
> [drm] Initialized radeon 1.28.0 20060524 on minor 0
> agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
> agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
> agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
> [drm] Setting GART location based on new memory map
> [drm] Loading R300 Microcode
> [drm] writeback test succeeded in 2 usecs
> vmmon: module license 'unspecified' taints kernel.
> /dev/vmmon[7085]: VMCI: Driver initialized.
> /dev/vmmon[7085]: Module vmmon: registered with major=10 minor=165
> /dev/vmmon[7085]: Module vmmon: initialized
> /dev/vmnet: open called by PID 7137 (vmnet-netifup)
> /dev/vmnet: hub 1 does not exist, allocating memory.
> /dev/vmnet: port on hub 1 successfully opened
> /dev/vmnet: open called by PID 7150 (vmnet-dhcpd)
> /dev/vmnet: port on hub 1 successfully opened
> fbcondecor: console 0 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 0
> vmnet1: no IPv6 routers present
> PPP BSD Compression module registered
> PPP Deflate Compression module registered
> swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> swsusp: Basic memory bitmaps created
> fbcondecor: console 0 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 0
> Stopping tasks ... done.
> Shrinking memory...   - done (0 pages freed)
> Freed 0 kbytes in 0.04 seconds (0.00 MB/s)
> Suspending console(s)
> usbfs 2-1:1.0: no suspend for driver usbfs?
> pnp: Device 00:0c disabled.
> eth0: Going into suspend...
> ACPI: PCI interrupt for device 0000:02:02.0 disabled
> ACPI handle has no context!
> ACPI: PCI interrupt for device 0000:02:01.0 disabled
> ACPI handle has no context!
> radeonfb (0000:01:00.0): suspending for event: 1...
> ACPI: PCI interrupt for device 0000:00:1f.5 disabled
> ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> ACPI: PCI interrupt for device 0000:00:1d.2 disabled
> ACPI: PCI interrupt for device 0000:00:1d.1 disabled
> ACPI: PCI interrupt for device 0000:00:1d.0 disabled
> swsusp: critical section:
> swsusp: Need to copy 75254 pages
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level,
> low) -> IRQ 11
> PCI: Setting latency timer of device 0000:00:1d.0 to 64
> usb usb1: root hub lost power or was reset
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level,
> low) -> IRQ 11
> PCI: Setting latency timer of device 0000:00:1d.1 to 64
> usb usb2: root hub lost power or was reset
> ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level,
> low) -> IRQ 11
> PCI: Setting latency timer of device 0000:00:1d.2 to 64
> usb usb3: root hub lost power or was reset
> ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level,
> low) -> IRQ 11
> PCI: Setting latency timer of device 0000:00:1d.7 to 64
> usb usb4: root hub lost power or was reset
> ehci_hcd 0000:00:1d.7: debug port 1
> PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> PCI: Setting latency timer of device 0000:00:1e.0 to 64
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level,
> low) -> IRQ 11
> PM: Writing back config space on device 0000:00:1f.5 at offset 1 (was
> 2900007, writing 2900003)
> ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level,
> low) -> IRQ 11
> PCI: Setting latency timer of device 0000:00:1f.5 to 64
> Clocksource tsc unstable (delta = -451320663 ns)
> radeonfb (0000:01:00.0): resuming from state: 1...
> PM: Writing back config space on device 0000:02:00.0 at offset f (was
> 3c0010b, writing 5c0010b)
> PM: Writing back config space on device 0000:02:00.0 at offset 3 (was
> 824008, writing 82a810)
> PM: Writing back config space on device 0000:02:00.0 at offset 1 (was
> 2100107, writing 2100007)
> PM: Writing back config space on device 0000:02:00.1 at offset f (was
> 3c0020b, writing 5c0020b)
> PM: Writing back config space on device 0000:02:00.1 at offset 3 (was
> 824008, writing 82a810)
> PM: Writing back config space on device 0000:02:00.1 at offset 1 (was
> 2100107, writing 2100007)
> ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 11 (level,
> low) -> IRQ 11
> eth0: Coming out of suspend...
> ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKC] -> GSI 11 (level,
> low) -> IRQ 11
> pnp: Device 00:0c activated.
> hda: selected mode 0x45
> hdc: selected mode 0x42
> hdaps: initial latch check good (0x02).
> Restarting tasks ... <6>usb 2-1: USB disconnect, address 3
> __tx_submit: hci0 tx submit failed urb f72a11d4 type 2 err -19
> done.
> usb 3-1: USB disconnect, address 2
> BUG: unable to handle kernel NULL pointer dereference at virtual
> address 00000000
>  printing eip:
> c01555c0
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT
> Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
> ppp_async vmnet(P) vmmon(P) radeon drm ipv6 autofs4 snd_pcm_oss
> snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp
> ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG
> xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter
> ip_tables x_tables rfcomm l2cap sd_mod scsi_mod ppp_generic slhc
> ioatdma cfq_iosched cpufreq_powersave cpufreq_ondemand
> cpufreq_conservative acpi_cpufreq freq_table ecryptfs dazuko commoncap
> uinput apm thermal processor fan button battery ac hdaps thinkpad_acpi
> hwmon nvram af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base
> hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
> snd_timer snd soundcore snd_page_alloc ipw2200 ieee80211
> ieee80211_crypt firmware_class ide_cd cdrom nsc_ircc irda crc_ccitt
> e1000 yenta_socket rsrc_nonstatic pcmcia_core psmouse ehci_hcd
> intel_agp agpgart uhci_hcd usbcore i2c_i801 rtc pcspkr unix evdev ext3
> jbd ext2 mbcache loop ide_disk piix ide_core
> CPU:    0
> EIP:    0060:[<c01555c0>]    Tainted: P        VLI
> EFLAGS: 00010296   (2.6.23-gentoo-r1 #1)
> EIP is at put_page+0x10/0xf0
> eax: 00000000   ebx: 00000000   ecx: f7075b58   edx: c1fe2c40
> esi: 00000001   edi: c1fc4480   ebp: c1fc4480   esp: f7f7bdb8
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process syslog-ng (pid: 6451, ti=f7f7a000 task=f7d1bab0 task.ti=f7f7a000)
> Stack: 0000000c 00000001 c1fc4480 c025893d c1fc4480 0000002f c1fc44a0 c02586d8
>        df9e60c0 f886ab59 00100100 00200200 f7f7be24 c1fc44a0 df9e6200 df9e6120
>        f7f7be9c f67970c0 00000000 0000002f 00000001 00000001 ffffffa1 00000000
> Call Trace:
>  [<c025893d>] skb_release_data+0x7d/0xa0
>  [<c02586d8>] kfree_skbmem+0x8/0x80
>  [<f886ab59>] unix_stream_recvmsg+0x1d9/0x610 [unix]
>  [<c0119670>] default_wake_function+0x0/0x10
>  [<c0251d68>] sock_aio_read+0x118/0x140
>  [<c014fd6f>] generic_file_aio_write+0x5f/0xd0
>  [<c016d906>] do_sync_read+0xc6/0x110
>  [<c012fb50>] autoremove_wake_function+0x0/0x50
>  [<c016e28b>] vfs_read+0x14b/0x160
>  [<c016e641>] sys_read+0x41/0x70
>  [<c01040ae>] sysenter_past_esp+0x5f/0x85
>  =======================
> Code: 90 90 90 90 90 90 90 90 90 90 90 e8 8b ff ff ff 31 c0 c3 90 8d
> b4 26 00 00 00 00 83 ec 0c 89 1c 24 89 c3 89 74 24 04 89 7c 24 08 <8b>
> 00 f6 c4 40 0f 85 b8 00 00 00 ff 4b 04 0f 94 c0 84 c0 0f 84
> EIP: [<c01555c0>] put_page+0x10/0xf0 SS:ESP 0068:f7f7bdb8
> general protection fault: 0000 [#2]
> PREEMPT
> Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
> ppp_async vmnet(P) vmmon(P) radeon drm ipv6 autofs4 snd_pcm_oss
> snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp
> ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG
> xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter
> ip_tables x_tables rfcomm l2cap sd_mod scsi_mod ppp_generic slhc
> ioatdma cfq_iosched cpufreq_powersave cpufreq_ondemand
> cpufreq_conservative acpi_cpufreq freq_table ecryptfs dazuko commoncap
> uinput apm thermal processor fan button battery ac hdaps thinkpad_acpi
> hwmon nvram af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base
> hci_usb bluetooth pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
> snd_timer snd soundcore snd_page_alloc ipw2200 ieee80211
> ieee80211_crypt firmware_class ide_cd cdrom nsc_ircc irda crc_ccitt
> e1000 yenta_socket rsrc_nonstatic pcmcia_core psmouse ehci_hcd
> intel_agp agpgart uhci_hcd usbcore i2c_i801 rtc pcspkr unix evdev ext3
> jbd ext2 mbcache loop ide_disk piix ide_core
> CPU:    0
> EIP:    0060:[<c01c575b>]    Tainted: P      D VLI
> EFLAGS: 00010202   (2.6.23-gentoo-r1 #1)
> EIP is at _atomic_dec_and_lock+0xb/0x40
> eax: fffffffe   ebx: fffffffe   ecx: 00000000   edx: f65da000
> esi: fffffffe   edi: dff803c0   ebp: dffefac8   esp: f65dbe50
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process pppd (pid: 7271, ti=f65da000 task=f7c61ab0 task.ti=f65da000)
> Stack: c017f8bc f7bf6868 c01ab7cd 00000000 ffffffff ffffffff fffffffe f7859824
>        00000000 fffffffe 00000000 c1d16c80 f7bf6868 dff803c0 c02fb514 c01c6c7b
>        f7009440 c02fb514 dff803c0 f7009440 f7009440 00000000 f7bf6800 00000000
> Call Trace:
>  [<c017f8bc>] dput+0x1c/0x160
>  [<c01ab7cd>] sysfs_move_dir+0x15d/0x1d0
>  [<c01c6c7b>] kobject_move+0x9b/0x120
>  [<c0238191>] device_move+0x51/0x110
>  [<f9b18981>] rfcomm_tty_close+0x51/0xa0 [rfcomm]
>  [<c01dd646>] release_dev+0x146/0x6a0
>  [<c0125c5a>] recalc_sigpending+0xa/0x20
>  [<c013313d>] ktime_get_ts+0x1d/0x50
>  [<c01ddbaf>] tty_release+0xf/0x20
>  [<c016eac1>] __fput+0x91/0x190
>  [<c016bdf7>] filp_close+0x47/0x80
>  [<c016d298>] sys_close+0x78/0xe0
>  [<c0104116>] syscall_call+0x7/0xb
>  [<c0193180>] bio_fs_destructor+0x0/0x10
>  =======================
> Code: 39 f5 7f b6 8d 46 ff 8b 14 24 89 02 8b 44 24 04 83 c4 08 5b 5e
> 5f 5d c3 90 90 90 90 90 90 90 90 89 e2 81 e2 00 e0 ff ff ff 42 14 <ff>
> 08 0f 94 c2 84 d2 b9 01 00 00 00 74 07 89 c8 c3 8d 74 26 00
> EIP: [<c01c575b>] _atomic_dec_and_lock+0xb/0x40 SS:ESP 0068:f65dbe50
> note: pppd[7271] exited with preempt_count 1
> usb 3-2: USB disconnect, address 3
> usb 3-1: new full speed USB device using uhci_hcd and address 4
> usb 3-1: configuration #1 chosen from 1 choice
> usb 3-2: new full speed USB device using uhci_hcd and address 5
> usb 3-2: configuration #1 chosen from 1 choice
> usb 2-1: new full speed USB device using uhci_hcd and address 4
> swsusp: Basic memory bitmaps freed
> usb 2-1: configuration #1 chosen from 1 choice
> fbcondecor: console 1 using theme 'livecd-2007.0'
> fbcondecor: switched decor state to 'on' on console 1
>
