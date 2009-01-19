Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbZASNjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbZASNjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbZASNiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:38:14 -0500
Received: from mout5.freenet.de ([195.4.92.95]:43102 "EHLO mout5.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760190AbZASNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:38:05 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 08:38:05 EST
From: wolfgang <mail@rohrmoser-engineering.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28 bug occured during losetup -d /dev/loop0
Date: Mon, 19 Jan 2009 14:29:02 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fAIdJLTz760Ltp9"
Message-Id: <200901191429.03404.mail@rohrmoser-engineering.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_fAIdJLTz760Ltp9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

losetup -d /dev/loop0 was hanging and I got
the the messages appended in dmesg.out.

I hope this information might be useful. If
it happends again I will try to collect
more information.

regards

  W. Rohrmoser


 

--Boundary-00=_fAIdJLTz760Ltp9
Content-Type: text/plain;
  charset="iso 8859-15";
  name="ver_linux.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ver_linux.out"

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux medion 2.6.28-medion #1 PREEMPT Sun Jan 18 14:45:17 CET 2009 i686 GNU/Linux
 
Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.3
reiserfsprogs          3.6.19
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         loop xt_multiport iptable_filter ip_tables x_tables binfmt_misc nvidia i2c_core ppdev lp nfsd exportfs nfs lockd sunrpc deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 aes_generic xcbc rmd160 sha256_generic sha1_generic md5 crypto_null ext3 jbd fuse dm_crypt dm_snapshot dm_mirror dm_region_hash dm_log dm_mod snd_pcm_oss snd_mixer_oss usbhid gspca_zc3xx gspca_main videodev v4l1_compat snd_cmipci snd_pcm snd_page_alloc snd_opl3_lib snd_hwdep snd_mpu401 snd_mpu401_uart snd_seq_midi snd_rawmidi snd_seq_dummy rtc_cmos rtc_core rtc_lib snd_seq_oss snd_seq_midi_event pcspkr snd_seq snd_timer snd_seq_device snd uhci_hcd soundcore ohci_hcd ohci1394 ehci_hcd 8139too mii ieee1394 sym53c8xx scsi_transport_spi usbcore ide_cd_mod fan 8250_pnp 8250 serial_core parport_pc parport thermal processor button thermal_sys intel_agp agpgart

--Boundary-00=_fAIdJLTz760Ltp9
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.out"

lp0: using parport0 (interrupt-driven).
lp0: console ready
ppdev: user-space parallel port driver
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
nvidia: module license 'NVIDIA' taints kernel.
nvidia 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
NVRM: loading NVIDIA Linux x86 Kernel Module  96.43.09  Mon Oct 27 14:23:30 PST 2008
agpgart-intel 0000:00:00.0: AGP 2.0 bridge
agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
nvidia 0000:01:00.0: putting AGP V2 device into 4x mode
ip_tables: (C) 2000-2006 Netfilter Core Team
loop: module loaded
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c0141c1e>] mempool_free+0xa/0x81
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:00.1/pools
Modules linked in: loop xt_multiport iptable_filter ip_tables x_tables binfmt_misc nvidia(P) i2c_core ppdev lp nfsd exportfs nfs lockd sunrpc deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 aes_generic xcbc rmd160 sha256_generic sha1_generic md5 crypto_null ext3 jbd fuse dm_crypt dm_snapshot dm_mirror dm_region_hash dm_log dm_mod snd_pcm_oss snd_mixer_oss usbhid gspca_zc3xx gspca_main videodev v4l1_compat snd_cmipci snd_pcm snd_page_alloc snd_opl3_lib snd_hwdep snd_mpu401 snd_mpu401_uart snd_seq_midi snd_rawmidi snd_seq_dummy rtc_cmos rtc_core rtc_lib snd_seq_oss snd_seq_midi_event pcspkr snd_seq snd_timer snd_seq_device snd uhci_hcd soundcore ohci_hcd ohci1394 ehci_hcd 8139too mii ieee1394 sym53c8xx scsi_transport_spi usbcore ide_cd_mod fan 8250_pnp 8250 serial_core parport_pc parport thermal processor button thermal_sys intel_agp agpgart

Pid: 27368, comm: loop0 Tainted: P           (2.6.28-medion #1)  
EIP: 0060:[<c0141c1e>] EFLAGS: 00010286 CPU: 0
EIP is at mempool_free+0xa/0x81
EAX: c75069c0 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: c75069c0 EDI: 00101800 EBP: 00000000 ESP: d0a0bf5c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process loop0 (pid: 27368, ti=d0a0a000 task=e36d83b0 task.ti=d0a0a000)
Stack:
 f0f5661a 00000000 c017b558 00000000 f0ebe917 d0a0bfb4 d2b7a908 d2b7a800
 c3370480 00001000 00000000 c77b751c f0ebe3ed 00000000 00000001 00000001
 00000000 00000000 00000000 d0a0bfb4 00145400 00000000 d2b7a800 c11fa900
Call Trace:
 [<f0f5661a>] crypt_endio+0x0/0xc7 [dm_crypt]
 [<c017b558>] bio_endio+0x27/0x29
 [<f0ebe917>] loop_thread+0x3ac/0x3e2 [loop]
 [<f0ebe3ed>] do_lo_send_aops+0x0/0x17e [loop]
 [<f0ebe56b>] loop_thread+0x0/0x3e2 [loop]
 [<c012570c>] kthread+0x36/0x5a
 [<c01256d6>] kthread+0x0/0x5a
 [<c0104423>] kernel_thread_helper+0x7/0x10
Code: 53 9d 89 e0 25 00 e0 ff ff ff 48 14 f6 40 08 08 74 05 e8 67 c0 17 00 31 c0 83 c4 0c 5b 5e 5f 5d c3 56 53 89 c6 89 d3 85 c0 74 74 <8b> 42 04 3b 02 7d 65 9c 59 fa 89 e0 25 00 e0 ff ff ff 40 14 8b 
EIP: [<c0141c1e>] mempool_free+0xa/0x81 SS:ESP 0068:d0a0bf5c
---[ end trace f619812d1cd509ee ]---

--Boundary-00=_fAIdJLTz760Ltp9--
