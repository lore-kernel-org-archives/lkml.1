Return-Path: <linux-kernel-owner+w=401wt.eu-S937763AbXG3TbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937763AbXG3TbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762861AbXG3TbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:31:10 -0400
Received: from mail.balticom.lv ([82.193.64.9]:37766 "EHLO mail.balticom.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869AbXG3TbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:31:08 -0400
X-Greylist: delayed 1933 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 15:31:07 EDT
From: Inguna <inguna@sten.lv>
Organization: Sten Systems inc
To: linux-kernel@vger.kernel.org
Subject: problem with huawei e630 data card
Date: Mon, 30 Jul 2007 21:58:39 +0300
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707302158.42100.inguna@sten.lv>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello
i use a kernel 2.6.22.1 (last stabile kernel from kernel.org)
i have a huewei e630 hsdpa/umts/edge/gprs/gsm data card, who set in pcmcia 
slot on notebook ( acer 2413 travelmate, linux mandriva 2007.
there is dmesg output:

pccard: CardBus card inserted into slot 0
yenta EnE: chaning testregister 0xC9, 04 -> 04
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device 0000:07:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 22 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:07:00.0 to 64
ohci_hcd 0000:07:00.0: OHCI Host Controller
ohci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 6
ohci_hcd 0000:07:00.0: irq 16, io mem 0x38000000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 1 port detected
PCI: Enabling device 0000:07:00.1 (0000 -> 0002)
ACPI: PCI Interrupt 0000:07:00.1[B] -> GSI 22 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:07:00.1 to 64
ohci_hcd 0000:07:00.1: OHCI Host Controller
ohci_hcd 0000:07:00.1: new USB bus registered, assigned bus number 7
ohci_hcd 0000:07:00.1: irq 16, io mem 0x38001000
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 1 port detected
usb 6-1: new full speed USB device using ohci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
pl2303 6-1:1.0: pl2303 converter detected
usb 6-1: pl2303 converter now attached to ttyUSB0
pl2303 6-1:1.1: pl2303 converter detected
usb 6-1: pl2303 converter now attached to ttyUSB1
pl2303 6-1:1.2: pl2303 converter detected
usb 6-1: pl2303 converter now attached to ttyUSB2
usbcore: registered new interface driver pl2303
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for GSM modem 
(1-port)
usbcore: registered new interface driver option
drivers/usb/serial/option.c: USB Driver for GSM modems: v0.7.1
BUG: unable to handle kernel NULL pointer dereference at virtual address 
0000001c
 printing eip:
e05a58e6
*pde = 00000000
Oops: 0002 [#1]
SMP
Modules linked in: option pl2303 usbserial ohci_hcd nls_cp437 nls_iso8859_1 
smbfs i915 drm snd_seq_dummy nfsd snd_seq_oss snd_seq_midi_event exportfs 
snd_seq lockd snd_seq_device nfs_acl sunrpc snd_pcm_oss snd_mixer_oss 
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd 
soundcore ipv6 8139too mii af_packet ide_cd loop nls_utf8 ntfs dm_mod video 
thermal processor fan container button battery ac pcmcia yenta_socket 
rsrc_nonstatic pcmcia_core intel_agp agpgart nvram ehci_hcd uhci_hcd usbcore 
evdev joydev tsdev
CPU:    0
EIP:    0060:[<e05a58e6>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22.1 #2)
EIP is at pl2303_open+0x456/0x9e0 [pl2303]
eax: 00000000   ebx: 00000000   ecx: 00000000   edx: c6493800
esi: c9606440   edi: ccba4800   ebp: cc2b7e70   esp: cc2b7e14
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process hald-probe-seri (pid: 22697, ti=cc2b6000 task=cc0ca560 
task.ti=cc2b6000)
Stack: 00000040 00000009 00000000 00000000 00000000 00000064 cc2b7e4c c0120b80
       ceb1b3a0 00000000 00000003 00000000 c0921000 ca255e00 cc2b7e58 c025f24a
       00000000 cc2b7e9c c025ff0f c9606440 ccba4800 c9606440 c0921000 cc2b7e9c
Call Trace:
 [<c01050aa>] show_trace_log_lvl+0x1a/0x30
 [<c0105171>] show_stack_log_lvl+0xb1/0xe0
 [<c0105372>] show_registers+0x1d2/0x2e0
 [<c0105594>] die+0x114/0x270
 [<c011f09b>] do_page_fault+0x2cb/0x5d0
 [<c033cdea>] error_code+0x72/0x78
 [<e06952cc>] serial_open+0xfc/0x150 [usbserial]
 [<c0262f5b>] tty_open+0x14b/0x2e0
 [<c017f653>] chrdev_open+0xa3/0x190
 [<c017b2ab>] __dentry_open+0xab/0x1a0
 [<c017b445>] nameidata_to_filp+0x35/0x40
 [<c017b499>] do_filp_open+0x49/0x50
 [<c017b4e7>] do_sys_open+0x47/0xd0
 [<c017b5ac>] sys_open+0x1c/0x20
 [<c0104086>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 1c 8b 47 44 ba d0 00 00 00 e8 f7 70 ab ff 85 c0 89 c3 0f 85 24 05 00 00 
8b 0d 80 99 5a e0 85 c9 0f 85 37 04 00 00 8b 47 24 8b 16 <89> 50 1c 8b 47 24 
ba d0 00 00 00 e8 ca 70 ab ff 89 c3 31 c0 85
EIP: [<e05a58e6>] pl2303_open+0x456/0x9e0 [pl2303] SS:ESP 0068:cc2b7e14
BUG: unable to handle kernel NULL pointer dereference at virtual address 
0000001c
 printing eip:
e05a58e6
*pde = 00000000
Oops: 0002 [#2]
SMP
Modules linked in: option pl2303 usbserial ohci_hcd nls_cp437 nls_iso8859_1 
smbfs i915 drm snd_seq_dummy nfsd snd_seq_oss snd_seq_midi_event exportfs 
snd_seq lockd snd_seq_device nfs_acl sunrpc snd_pcm_oss snd_mixer_oss 
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd 
soundcore ipv6 8139too mii af_packet ide_cd loop nls_utf8 ntfs dm_mod video 
thermal processor fan container button battery ac pcmcia yenta_socket 
rsrc_nonstatic pcmcia_core intel_agp agpgart nvram ehci_hcd uhci_hcd usbcore 
evdev joydev tsdev
CPU:    0
EIP:    0060:[<e05a58e6>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22.1 #2)
EIP is at pl2303_open+0x456/0x9e0 [pl2303]
eax: 00000000   ebx: 00000000   ecx: 00000000   edx: c6493800
esi: c9606500   edi: c25f7a00   ebp: cc2e1e70   esp: cc2e1e14
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process hald-probe-seri (pid: 22733, ti=cc2e0000 task=cfdbfa90 
task.ti=cc2e0000)
Stack: 00000040 00000009 00000000 00000000 00000000 00000064 cc2e1e4c c0120b80
       dcf2ba20 00000000 00000003 00000000 c0922000 ca255e00 cc2e1e58 c025f24a
       00000000 cc2e1e9c c025ff0f c9606500 c25f7a00 c9606500 c0922000 cc2e1e9c
Call Trace:
 [<c01050aa>] show_trace_log_lvl+0x1a/0x30
 [<c0105171>] show_stack_log_lvl+0xb1/0xe0
 [<c0105372>] show_registers+0x1d2/0x2e0
 [<c0105594>] die+0x114/0x270
 [<c011f09b>] do_page_fault+0x2cb/0x5d0
 [<c033cdea>] error_code+0x72/0x78
 [<e06952cc>] serial_open+0xfc/0x150 [usbserial]
 [<c0262f5b>] tty_open+0x14b/0x2e0
 [<c017f653>] chrdev_open+0xa3/0x190
 [<c017b2ab>] __dentry_open+0xab/0x1a0
 [<c017b445>] nameidata_to_filp+0x35/0x40
 [<c017b499>] do_filp_open+0x49/0x50
 [<c017b4e7>] do_sys_open+0x47/0xd0
 [<c017b5ac>] sys_open+0x1c/0x20
 [<c0104086>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 1c 8b 47 44 ba d0 00 00 00 e8 f7 70 ab ff 85 c0 89 c3 0f 85 24 05 00 00 
8b 0d 80 99 5a e0 85 c9 0f 85 37 04 00 00 8b 47 24 8b 16 <89> 50 1c 8b 47 24 
ba d0 00 00 00 e8 ca 70 ab ff 89 c3 31 c0 85
EIP: [<e05a58e6>] pl2303_open+0x456/0x9e0 [pl2303] SS:ESP 0068:cc2e1e14


there is lsmod:

[root@localhost gazella]# lsmod
Module                  Size  Used by
option                 12544  0
pl2303                 22916  2
usbserial              33256  6 option,pl2303
ohci_hcd               23172  0
nls_cp437               9728  3
nls_iso8859_1           8064  3
smbfs                  61432  3
i915                   25856  2
drm                    75668  3 i915
snd_seq_dummy           6788  0
nfsd                  213488  17
snd_seq_oss            33152  0
snd_seq_midi_event     10240  1 snd_seq_oss
exportfs                8704  1 nfsd
snd_seq                50256  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
lockd                  63624  2 nfsd
snd_seq_device         10636  3 snd_seq_dummy,snd_seq_oss,snd_seq
nfs_acl                 7040  1 nfsd
sunrpc                151932  12 nfsd,lockd,nfs_acl
snd_pcm_oss            42272  0
snd_mixer_oss          17920  1 snd_pcm_oss
snd_intel8x0           32796  1
snd_ac97_codec         99620  1 snd_intel8x0
ac97_bus                6144  1 snd_ac97_codec
snd_pcm                72068  3 snd_pcm_oss,snd_intel8x0,snd_ac97_codec
snd_timer              22660  2 snd_seq,snd_pcm
snd_page_alloc         11656  2 snd_intel8x0,snd_pcm
snd                    48100  11 
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
soundcore               9952  1 snd
ipv6                  249892  18
8139too                25728  0
mii                     8704  1 8139too
af_packet              24200  2
ide_cd                 38688  1
loop                   17412  0
nls_utf8                5888  3
ntfs                  101568  1
dm_mod                 51264  0
video                  18440  0
thermal                14856  0
processor              29160  1 thermal
fan                     7684  0
container               7424  0
button                 10128  0
battery                12292  0
ac                      7940  0
pcmcia                 36780  0
yenta_socket           26892  2
rsrc_nonstatic         14848  1 yenta_socket
pcmcia_core            36756  3 pcmcia,yenta_socket,rsrc_nonstatic
intel_agp              25364  1
agpgart                31048  3 drm,intel_agp
nvram                  11400  0
ehci_hcd               33548  0
uhci_hcd               25872  0
usbcore               121224  7 
option,pl2303,usbserial,ohci_hcd,ehci_hcd,uhci_hcd
evdev                  11904  2
joydev                 12352  0
tsdev                  10560  0
[root@localhost gazella]# 


there - lspci

00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express 
Processor to DRAM Controller (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML 
Express Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express 
Graphics Controller (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/FW/FRW 
(ICH6 Family) AC'97 Audio Controller (rev 03)
00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 
Modem Controller (rev 03)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge 
(rev 03)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
IDE Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus 
Controller (rev 03)
06:05.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 
802.11g Wireless LAN Controller (rev 02)
06:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
06:09.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 01)
07:00.0 USB Controller: NEC Corporation USB (rev 43)
07:00.1 USB Controller: NEC Corporation USB (rev 43)

i also a serrch in internet,and i found, this problem is
http://lists.debian.org/debian-kernel/2007/06/msg00013.html
i e a kernel 2.6.18 also have a this problem. 

