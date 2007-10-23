Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXJWRuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXJWRuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXJWRun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:50:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:23925 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXJWRum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LdgSPxTpWjYLBXF6bBsA84k4xitwrVsPboUMm840hmGk+v3Kf5/fXSP+hQ0LjEVIdjpnnqddPSH9npwdhuyEGgsYFj2Jn7h21pwP6ryTByjcqD0oKPRT7+v76jqjmAUYnob9BPYnuMVTO65kpnei/d/6lVxicpsdbslfOdi1EYw=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] rfcomm]
Date: Tue, 23 Oct 2007 19:50:28 +0200
User-Agent: KMail/1.9.7
Cc: bluez-devel@lists.sourceforge.net, marcel@holtmann.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710231950.31313.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have this issue for long time (At least from linux-2.6.18).
I think it is about time I report this... :)

When coming out of suspend (uswsusp or suspend2) if rfcomm was
active it creates this dump.

If you need any more info I will be glad to provide.

Best Regards,
Alon Bar-Lev.

---

Oct 23 17:51:33 alon1 acpid: received event "button/power PWRF 00000080 00000001"
Oct 23 17:51:33 alon1 acpid: notifying client 7903[0:0]
Oct 23 17:51:33 alon1 acpid: notifying client 7804[0:0]
Oct 23 17:51:33 alon1 acpid: executing action "/etc/acpi/default.sh button/power PWRF 00000080 00000001"
Oct 23 17:52:13 alon1 ntpd[8186]: synchronized to 192.115.25.179, stratum 2
Oct 23 17:52:16 alon1 swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
Oct 23 17:52:16 alon1 swsusp: Basic memory bitmaps created
Oct 23 19:41:22 alon1 pppd[25041]: Hangup (SIGHUP)
Oct 23 19:41:22 alon1 pppd[25041]: Modem hangup
Oct 23 19:41:22 alon1 pppd[25041]: Connect time 384.5 minutes.
Oct 23 19:41:22 alon1 pppd[25041]: Sent 512470 bytes, received 1546102 bytes.
Oct 23 19:41:22 alon1 pppd[25041]: Connection terminated.
Oct 23 19:41:40 alon1 Stopping tasks ... done.
Oct 23 19:41:40 alon1 Shrinking memory...   - \ | / - \ | / - \ | / - \ | / - \ | / - \ | / - \ | / - \ | / - \ | / - \ | done (224831 pages freed)
Oct 23 19:41:40 alon1 Freed 899324 kbytes in 14.70 seconds (61.17 MB/s)
Oct 23 19:41:40 alon1 Suspending console(s)
Oct 23 19:41:40 alon1 usbfs 2-2:1.0: no suspend for driver usbfs?
Oct 23 19:41:40 alon1 pnp: Device 00:0c disabled.
Oct 23 19:41:40 alon1 eth0: Going into suspend...
Oct 23 19:41:40 alon1 ACPI: PCI interrupt for device 0000:02:02.0 disabled
Oct 23 19:41:40 alon1 ACPI handle has no context!
Oct 23 19:41:40 alon1 ACPI: PCI interrupt for device 0000:02:01.0 disabled
Oct 23 19:41:40 alon1 ACPI handle has no context!
Oct 23 19:41:40 alon1 radeonfb (0000:01:00.0): suspending for event: 1...
Oct 23 19:41:40 alon1 ACPI: PCI interrupt for device 0000:00:1f.5 disabled
Oct 23 19:41:40 alon1 ACPI: PCI interrupt for device 0000:00:1d.7 disabled
Oct 23 19:41:40 alon1 ACPI: PCI interrupt for device 0000:00:1d.2 disabled
Oct 23 19:41:40 alon1 ACPI: PCI interrupt for device 0000:00:1d.1 disabled
Oct 23 19:41:40 alon1 ACPI: PCI interrupt for device 0000:00:1d.0 disabled
Oct 23 19:41:40 alon1 swsusp: critical section: 
Oct 23 19:41:40 alon1 swsusp: Need to copy 126188 pages
Oct 23 19:41:40 alon1 Intel machine check architecture supported.
Oct 23 19:41:40 alon1 Intel machine check reporting enabled on CPU#0.
Oct 23 19:41:40 alon1 ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:40 alon1 PCI: Setting latency timer of device 0000:00:1d.0 to 64
Oct 23 19:41:40 alon1 usb usb1: root hub lost power or was reset
Oct 23 19:41:40 alon1 ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:40 alon1 PCI: Setting latency timer of device 0000:00:1d.1 to 64
Oct 23 19:41:40 alon1 usb usb2: root hub lost power or was reset
Oct 23 19:41:40 alon1 ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:40 alon1 PCI: Setting latency timer of device 0000:00:1d.2 to 64
Oct 23 19:41:40 alon1 usb usb3: root hub lost power or was reset
Oct 23 19:41:40 alon1 ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:40 alon1 PCI: Setting latency timer of device 0000:00:1d.7 to 64
Oct 23 19:41:40 alon1 usb usb4: root hub lost power or was reset
Oct 23 19:41:40 alon1 ehci_hcd 0000:00:1d.7: debug port 1
Oct 23 19:41:40 alon1 PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Oct 23 19:41:40 alon1 PCI: Setting latency timer of device 0000:00:1e.0 to 64
Oct 23 19:41:40 alon1 ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:42 alon1 PM: Writing back config space on device 0000:00:1f.5 at offset 1 (was 2900007, writing 2900003)
Oct 23 19:41:42 alon1 ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:42 alon1 PCI: Setting latency timer of device 0000:00:1f.5 to 64
Oct 23 19:41:42 alon1 radeonfb (0000:01:00.0): resuming from state: 1...
Oct 23 19:41:42 alon1 PM: Writing back config space on device 0000:02:00.0 at offset f (was 3c0010b, writing 5c0010b)
Oct 23 19:41:42 alon1 PM: Writing back config space on device 0000:02:00.0 at offset 3 (was 824008, writing 82a810)
Oct 23 19:41:42 alon1 PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 2100107, writing 2100007)
Oct 23 19:41:42 alon1 PM: Writing back config space on device 0000:02:00.1 at offset f (was 3c0020b, writing 5c0020b)
Oct 23 19:41:42 alon1 PM: Writing back config space on device 0000:02:00.1 at offset 3 (was 824008, writing 82a810)
Oct 23 19:41:42 alon1 PM: Writing back config space on device 0000:02:00.1 at offset 1 (was 2100107, writing 2100007)
Oct 23 19:41:42 alon1 ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:42 alon1 eth0: Coming out of suspend...
Oct 23 19:41:42 alon1 ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Oct 23 19:41:42 alon1 pnp: Device 00:0c activated.
Oct 23 19:41:42 alon1 ipw2200: Radio disabled by module parameter.
Oct 23 19:41:42 alon1 hda: selected mode 0x45
Oct 23 19:41:42 alon1 hdc: selected mode 0x42
Oct 23 19:41:42 alon1 Restarting tasks ... <6>usb 2-2: USB disconnect, address 4
Oct 23 19:41:42 alon1 done.
Oct 23 19:41:42 alon1 usb 3-1: USB disconnect, address 4
Oct 23 19:41:42 alon1 usb 3-2: USB disconnect, address 3
Oct 23 19:41:42 alon1 usb 3-1: new full speed USB device using uhci_hcd and address 5
Oct 23 19:41:42 alon1 usb 3-1: configuration #1 chosen from 1 choice
Oct 23 19:41:42 alon1 usb 3-2: new full speed USB device using uhci_hcd and address 6
Oct 23 19:41:42 alon1 usb 3-2: configuration #1 chosen from 1 choice
Oct 23 19:41:42 alon1 general protection fault: 0000 [#1]
Oct 23 19:41:42 alon1 PREEMPT 
Oct 23 19:41:42 alon1 hcid[7849]: HCI dev 0 down
Oct 23 19:41:42 alon1 Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async hci_usb vmnet(P) vmmon(P) rfcomm l2cap radeon drm ipv6 autofs4 nf_nat_irc nf_nat_ftp nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp ipt_LOG xt_limit xt_state nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables aes crypto_algapi ieee80211_crypt_ccmp snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device sd_mod scsi_mod bluetooth ppp_generic slhc ioatdma cfq_iosched cpufreq_powersave cpufreq_ondemand cpufreq_conservative acpi_cpufreq freq_table ecryptfs dazuko commoncap apm thermal processor fan button battery ac hdaps thinkpad_acpi hwmon nvram af_packet nls_cp1255 nls_iso8859_1 nls_utf8 nls_base pcmcia ipw2200 ieee80211 ieee80211_crypt firmware_class e1000 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore yenta_socket snd_page_alloc rsrc_nonstatic pcmcia_core nsc_ircc ide_cd irda crc_ccitt ehci_hcd cdrom uhci_hcd intel_agp agpgart psmouse usbcore i2c_i801 rtc unix evdev ext3 jbd ext2 mbcache loop ide_disk piix ide_core
Oct 23 19:41:42 alon1 CPU:    0
Oct 23 19:41:42 alon1 EIP:    0060:[<c01c575b>]    Tainted: P        VLI
Oct 23 19:41:42 alon1 EFLAGS: 00210202   (2.6.23-gentoo #4)
Oct 23 19:41:42 alon1 EIP is at _atomic_dec_and_lock+0xb/0x40
Oct 23 19:41:42 alon1 eax: fffffffe   ebx: fffffffe   ecx: 00000000   edx: e1ae8000
Oct 23 19:41:42 alon1 esi: fffffffe   edi: f672aec0   ebp: dffefac8   esp: e1ae9e50
Oct 23 19:41:42 alon1 ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Oct 23 19:41:42 alon1 Process pppd (pid: 25041, ti=e1ae8000 task=f61bbab0 task.ti=e1ae8000)
Oct 23 19:41:42 alon1 Stack: c017f8bc f65f5468 c01ab7cd 00000000 ffffffff ffffffff fffffffe f4c32754 
Oct 23 19:41:42 alon1 00000000 fffffffe 00000000 df7244c0 f65f5468 f672aec0 c02fb514 c01c6c7b 
Oct 23 19:41:42 alon1 f67f37c0 c02fb514 f672aec0 f67f37c0 f67f37c0 00000000 f65f5400 00000000 
Oct 23 19:41:42 alon1 Call Trace:
Oct 23 19:41:42 alon1 [<c017f8bc>] dput+0x1c/0x160
Oct 23 19:41:42 alon1 [<c01ab7cd>] sysfs_move_dir+0x15d/0x1d0
Oct 23 19:41:42 alon1 [<c01c6c7b>] kobject_move+0x9b/0x120
Oct 23 19:41:42 alon1 [<c0238191>] device_move+0x51/0x110
Oct 23 19:41:42 alon1 [<f9c4ed91>] rfcomm_tty_close+0x51/0xa0 [rfcomm]
Oct 23 19:41:42 alon1 [<c01dd646>] release_dev+0x146/0x6a0
Oct 23 19:41:42 alon1 [<c015bd60>] handle_mm_fault+0x160/0x6b0
Oct 23 19:41:42 alon1 [<c01ddbaf>] tty_release+0xf/0x20
Oct 23 19:41:42 alon1 [<c016eac1>] __fput+0x91/0x190
Oct 23 19:41:42 alon1 [<c016bdf7>] filp_close+0x47/0x80
Oct 23 19:41:42 alon1 [<c016d298>] sys_close+0x78/0xe0
Oct 23 19:41:42 alon1 [<c01040ae>] sysenter_past_esp+0x5f/0x85
Oct 23 19:41:42 alon1 =======================
Oct 23 19:41:42 alon1 Code: 39 f5 7f b6 8d 46 ff 8b 14 24 89 02 8b 44 24 04 83 c4 08 5b 5e 5f 5d c3 90 90 90 90 90 90 90 90 89 e2 81 e2 00 e0 ff ff ff 42 14 <ff> 08 0f 94 c2 84 d2 b9 01 00 00 00 74 07 89 c8 c3 8d 74 26 00 
Oct 23 19:41:42 alon1 EIP: [<c01c575b>] _atomic_dec_and_lock+0xb/0x40 SS:ESP 0068:e1ae9e50
Oct 23 19:41:42 alon1 note: pppd[25041] exited with preempt_count 1
Oct 23 19:41:42 alon1 swsusp: Basic memory bitmaps freed
Oct 23 19:41:42 alon1 usb 2-2: new full speed USB device using uhci_hcd and address 5
Oct 23 19:41:42 alon1 usb 2-2: configuration #1 chosen from 1 choice
Oct 23 19:41:42 alon1 pcscd[8214]: segfault at 00000000 eip b7fb07ff esp b760fe30 error 4
Oct 23 19:41:42 alon1 /etc/init.d/net.ppp0[2070]: status: crashed
Oct 23 19:41:45 alon1 hcid[7849]: Stopping security manager 0
Oct 23 19:41:45 alon1 hcid[7849]: Device hci0 has been disabled
Oct 23 19:41:45 alon1 hcid[7849]: HCI dev 0 unregistered
Oct 23 19:41:45 alon1 hcid[7849]: Unregister path: /org/bluez/hci0
Oct 23 19:41:49 alon1 /etc/init.d/bluetooth[2135]: status: crashed
Oct 23 19:41:54 alon1 fbcondecor: console 1 using theme 'livecd-2007.0'
Oct 23 19:41:54 alon1 fbcondecor: switched decor state to 'on' on console 1
Oct 23 19:42:00 alon1 agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
Oct 23 19:42:00 alon1 agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
Oct 23 19:42:00 alon1 agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
Oct 23 19:42:00 alon1 [drm] Loading R300 Microcode
Oct 23 19:42:06 alon1 acpid: action exited with status 0
Oct 23 19:42:06 alon1 acpid: completed event "button/power PWRF 00000080 00000001"
Oct 23 19:42:06 alon1 acpid: client connected from 7804[0:0]
Oct 23 19:42:06 alon1 acpid: 1 client rule loaded
