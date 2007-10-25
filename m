Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbXJYIqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbXJYIqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXJYIpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:45:55 -0400
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:28739 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXJYIpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:45:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkZAHrzH0fEAmHFRmdsb2JhbACOUAEBARIEBgkGDA4
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: linux-kernel@vger.kernel.org
Subject: irq 21: nobody cared 2.6.24-rc1
Date: Thu, 25 Oct 2007 10:45:36 +0200
User-Agent: KMail/1.9.8
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251045.37040.bonganilinux@mweb.co.za>
X-Original-Subject: irq 21: nobody cared 2.6.24-rc1
X-Spam-Score: 0.1 (/)
X-Spam-Score-Int: 1
X-Spam-Report: Spam detection software, running on the system "wbs-smtp-out-02.jhb.wbs.co.za", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	Postmaster for details.
	Content preview:  Booting with irqpoll works ls /proc/irq/21/ (with irqpoll)
	ehci_hcd:usb1/ smp_affinity uhci_hcd:usb2/ uhci_hcd:usb3/ uhci_hcd:usb4/
	irq 21: nobody cared (try booting with the "irqpoll" option) [...] 
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	0.1 RDNS_DYNAMIC           Delivered to trusted network by host with
	dynamic-looking rDNS
X-Scan-Signature: d30fa25732aaeaa5fd391cee9e2642cd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting with irqpoll works

ls /proc/irq/21/ (with irqpoll)
ehci_hcd:usb1/  smp_affinity  uhci_hcd:usb2/  uhci_hcd:usb3/  uhci_hcd:usb4/

irq 21: nobody cared (try booting with the "irqpoll" option)

 Call Trace:
  <IRQ>  [__report_bad_irq+56/124] __report_bad_irq+0x38/0x7c
  <IRQ>  [<ffffffff802622eb>] __report_bad_irq+0x38/0x7c
  [note_interrupt+546/617] note_interrupt+0x222/0x269
  [<ffffffff80262551>] note_interrupt+0x222/0x269
  [handle_fasteoi_irq+179/221] handle_fasteoi_irq+0xb3/0xdd
  [<ffffffff80262bfa>] handle_fasteoi_irq+0xb3/0xdd
  [do_IRQ+246/361] do_IRQ+0xf6/0x169
  [<ffffffff8020e271>] do_IRQ+0xf6/0x169
  [ret_from_intr+0/10] ret_from_intr+0x0/0xa
  [<ffffffff8020be41>] ret_from_intr+0x0/0xa
  <EOI>  [unmap_vmas+665/1878] unmap_vmas+0x299/0x756
  <EOI>  [<ffffffff802728fc>] unmap_vmas+0x299/0x756
  [unmap_vmas+1838/1878] unmap_vmas+0x72e/0x756
  [<ffffffff80272d91>] unmap_vmas+0x72e/0x756
  [exit_mmap+137/295] exit_mmap+0x89/0x127
 > [<ffffffff80276592>] exit_mmap+0x89/0x127
  [mmput+40/164] mmput+0x28/0xa4
 [<ffffffff802314dc>] mmput+0x28/0xa4
  [flush_old_exec+1543/2268] flush_old_exec+0x607/0x8dc
  [<ffffffff8028fafe>] flush_old_exec+0x607/0x8dc
  [load_elf_binary+0/7165] load_elf_binary+0x0/0x1bfd
  [<ffffffff802bb46b>] load_elf_binary+0x0/0x1bfd
  [load_elf_binary+0/7165] load_elf_binary+0x0/0x1bfd
  [<ffffffff802bb46b>] load_elf_binary+0x0/0x1bfd
  [load_elf_binary+1337/7165] load_elf_binary+0x539/0x1bfd
  [<ffffffff802bb9a4>] load_elf_binary+0x539/0x1bfd
  [__strnlen_user+33/45] __strnlen_user+0x21/0x2d
  [<ffffffff80313be1>] __strnlen_user+0x21/0x2d
  [put_arg_page+9/11] put_arg_page+0x9/0xb
  [<ffffffff8028e81b>] put_arg_page+0x9/0xb
  [load_elf_binary+0/7165] load_elf_binary+0x0/0x1bfd
  [<ffffffff802bb46b>] load_elf_binary+0x0/0x1bfd
  [search_binary_handler+227/565] search_binary_handler+0xe3/0x235
  [<ffffffff8028ec71>] search_binary_handler+0xe3/0x235
  [do_execve+357/451] do_execve+0x165/0x1c3
  [<ffffffff80290293>] do_execve+0x165/0x1c3
  [sys_execve+54/145] sys_execve+0x36/0x91
  [<ffffffff8020a42f>] sys_execve+0x36/0x91
  [stub_execve+103/176] stub_execve+0x67/0xb0
  [<ffffffff8020bcf7>] stub_execve+0x67/0xb0

 handlers:
 [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
 [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
 [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
 [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
 [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
 [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
 [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
 [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
 Disabling IRQ #21

---

lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host Bridge 
(rev 01)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 
South]
00:05.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
00:05.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
00:08.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
00:08.1 Input device controller: Creative Labs SB Audigy Game Port (rev 04)
00:08.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)
00:0b.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5705 Gigabit 
Ethernet (rev 03)
00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID 
Controller (rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge 
[KT600/K8T800/K8T890 South]
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation NV36 [GeForce FX 5700LE] 
(rev a1)

----

./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux bongani64 2.6.24-rc1 #1 SMP PREEMPT Wed Oct 24 20:22:00 SAST 2007 x86_64 
AMD Opteron(tm) Processor 244 GNU/Linux

Gnu C                  4.2.2
Gnu make               3.81
binutils               2.17.50.0.12
util-linux             2.13
mount                  2.13
module-init-tools      3.3-pre11
e2fsprogs              1.40.2
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   114
Modules Loaded         snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
usbhid binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs dm_mod thermal 
processor fan container button pcspkr snd_pcm_oss snd_mixer_oss tuner tea5767 
tda8290 tuner_simple snd_emu10k1 ehci_hcd snd_rawmidi uhci_hcd usbcore 
snd_ac97_codec ac97_bus snd_pcm mt20xx ide_cd bttv ir_common compat_ioctl32 
videobuf_dma_sg firewire_ohci videobuf_core i2c_viapro snd_seq_device 
snd_timer snd_page_alloc snd_util_mem firewire_core crc_itu_t btcx_risc 
snd_hwdep tveeprom videodev emu10k1_gp v4l2_common sg snd v4l1_compat 
ohci1394 gameport evdev tg3 sr_mod ieee1394 soundcore cdrom
