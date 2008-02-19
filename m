Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYBSThK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYBSThK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYBSTg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:36:57 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:36156 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYBSTgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:36:52 -0500
Subject: snd_bt87x crash with kernel 2.6.24.2 on amd64
From: Andreas Matthus <matthus@nexgo.de>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-GHemltd02lZeHImCXDDs"
Date: Tue, 19 Feb 2008 20:36:38 +0100
Message-Id: <1203449798.9669.19.camel@mahome1.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GHemltd02lZeHImCXDDs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[1.] summary: snd_bt87x crash with kernel 2.6.24.2 on amd64  =20
[2.] Full description of the problem/report:
	after upgrade from kernel 2.6.23.12 tu 2.6.24.2 on my amd64 the boot-proce=
ss stop by loading snd_bt87x=20
	When I move this kernel-modul on another place, booting is OK.=20
	Then I remove snd-bt87x.ko and call
	depmod -ae
	modprobe snd-bt87x
	and the terminal hung (see output from /var/log/messages below)

[3.] module: snd_bt87x=20
[4.] Kernel version 2.6.24.6
[5.] Output from /var/log/messages
Feb 19 19:17:01 mahome1 kernel: Pid: 9383, comm: rmmod Tainted: P        2.=
6.24.2mahome #1
Feb 19 19:17:01 mahome1 kernel: RIP: 0010:[<ffffffff88486a52>]  [<ffffffff8=
8486a52>] :snd_bt87x:snd_bt87x_interrupt+0x13/0x1b8
Feb 19 19:17:01 mahome1 kernel: RSP: 0000:ffff81000b285d28  EFLAGS: 0001009=
6
Feb 19 19:17:01 mahome1 kernel: RAX: 0000000000000000 RBX: ffff81000b66ce40=
 RCX: 0000000000000004
Feb 19 19:17:01 mahome1 kernel: RDX: ffffc200006b0000 RSI: ffff81000b66ce40=
 RDI: 0000000000000011
Feb 19 19:17:01 mahome1 kernel: RBP: ffff81003eaa3580 R08: 0000000000000213=
 R09: ffff810001c00000
Feb 19 19:17:01 mahome1 kernel: R10: 00007fff34158670 R11: ffffffff80268831=
 R12: 0000000000000011
Feb 19 19:17:01 mahome1 kernel: R13: ffffffff805a3090 R14: 0000000000000213=
 R15: ffff81000b66ce40
Feb 19 19:17:01 mahome1 kernel: FS:  00002b7676ec86e0(0000) GS:ffff81003f80=
1700(0000) knlGS:0000000000000000
Feb 19 19:17:01 mahome1 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080=
05003b
Feb 19 19:17:01 mahome1 kernel: CR2: ffffc200006b0100 CR3: 000000001023e000=
 CR4: 00000000000006e0
Feb 19 19:17:01 mahome1 kernel: DR0: 0000000000000000 DR1: 0000000000000000=
 DR2: 0000000000000000
Feb 19 19:17:01 mahome1 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0=
 DR7: 0000000000000400
Feb 19 19:17:01 mahome1 kernel: Process rmmod (pid: 9383, threadinfo ffff81=
000b284000, task ffff8100130130c0)
Feb 19 19:17:01 mahome1 kernel: Stack:  ffffffff805a3040 ffffffff804744be f=
fffffff805a3090 0000000000000282
Feb 19 19:17:01 mahome1 kernel:  ffff81003eaa3580 0000000000000011 ffffffff=
805a3090 ffffffff80262739
Feb 19 19:17:01 mahome1 kernel:  0000000000000880 ffff81000b66ce40 ffff8100=
138e5000 0000000000002fff
Feb 19 19:17:01 mahome1 kernel: Call Trace:
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff804744be>] _spin_unlock_irqresto=
re+0x16/0x31
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff80262739>] free_irq+0xf6/0x141
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff884861f2>] :snd_bt87x:snd_bt87x_=
free+0x34/0x52
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8806bbcc>] :snd:snd_device_free+=
0x68/0xa6
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8806bc3e>] :snd:snd_device_free_=
all+0x34/0x56
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff88067746>] :snd:snd_card_do_free=
+0x5f/0xb4
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff88068116>] :snd:snd_card_free+0x=
8f/0x9d
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff804744ee>] _spin_unlock_irq+0x15=
/0x30
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff804723f2>] wait_for_common+0x140=
/0x150
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff884860ac>] :snd_bt87x:snd_bt87x_=
remove+0x10/0x1d
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8032ded7>] pci_device_remove+0x2=
4/0x47
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8038b3f2>] __device_release_driv=
er+0x8e/0xb0
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8038b88e>] driver_detach+0x8f/0x=
d1
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8038af2e>] bus_remove_driver+0x7=
d/0xa0
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8032e060>] pci_unregister_driver=
+0x17/0x6b
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff80257ad3>] sys_delete_module+0x1=
a8/0x1d7
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff80320078>] radix_tree_gang_looku=
p_tag+0xd/0x1b4
Feb 19 19:17:01 mahome1 kernel:  [<ffffffff8020bede>] system_call+0x7e/0x83
Feb 19 19:17:01 mahome1 kernel:
Feb 19 19:17:01 mahome1 kernel:
Feb 19 19:17:01 mahome1 kernel: Code: 44 8b a2 00 01 00 00 44 89 e5 23 ae 8=
4 00 00 00 0f 84 84 01
Feb 19 19:17:01 mahome1 kernel:  RSP <ffff81000b285d28>
Feb 19 19:17:01 mahome1 kernel: ---[ end trace 72a9aa20c00f4bdd ]---

[7.2.] /proc/cpuinfo:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 43
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping        : 1
cpu MHz         : 2210.057
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3=
dnowext 3dnow rep_good pni lahf_lm cmp_legacy
bogomips        : 4421.60
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 43
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping        : 1
cpu MHz         : 2210.057
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3=
dnowext 3dnow rep_good pni lahf_lm cmp_legacy
bogomips        : 4420.13
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

[7.3.] Module information (from /proc/modules):
snd_bt87x 18404 0 - Unloading 0xffffffff88486000
fcpci 643956 1 - Live 0xffffffff883e7000 (P)
tun 12928 2 - Live 0xffffffff881cb000
snd_ens1371 29408 1 - Live 0xffffffff883de000
snd_seq_dummy 4868 0 - Live 0xffffffff881c8000
snd_seq_oss 33664 0 - Live 0xffffffff881ba000
snd_seq_midi 9984 0 - Live 0xffffffff881b6000
snd_seq_midi_event 8896 2 snd_seq_oss,snd_seq_midi, Live 0xffffffff881b2000
snd_seq 56160 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, =
Live 0xffffffff881a3000
snd_rawmidi 27904 2 snd_ens1371,snd_seq_midi, Live 0xffffffff8819b000
snd_seq_device 9300 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq,snd_ra=
wmidi, Live 0xffffffff88197000
snd_intel8x0 37544 1 - Live 0xffffffff88157000
snd_ac97_codec 113432 2 snd_ens1371,snd_intel8x0, Live 0xffffffff8812b000
ac97_bus 3328 1 snd_ac97_codec, Live 0xffffffff880b4000
snd_pcm_oss 43968 0 - Live 0xffffffff88118000
snd_mixer_oss 18304 1 snd_pcm_oss, Live 0xffffffff88112000
snd_pcm 86792 5 snd_bt87x,snd_ens1371,snd_intel8x0,snd_ac97_codec,snd_pcm_o=
ss, Live 0xffffffff880fb000
snd_timer 25736 2 snd_seq,snd_pcm, Live 0xffffffff880dd000
snd 64872 16 snd_bt87x,snd_ens1371,snd_seq_oss,snd_seq,snd_rawmidi,snd_seq_=
device,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_ti=
mer, Live 0xffffffff88067000
soundcore 10272 1 snd, Live 0xffffffff88048000
snd_page_alloc 11536 3 snd_bt87x,snd_intel8x0,snd_pcm, Live 0xffffffff88044=
000
xt_length 2944 0 - Live 0xffffffff883dc000
ipt_ttl 2816 0 - Live 0xffffffff883da000
iptable_mangle 3840 0 - Live 0xffffffff881d2000
xt_multiport 4160 0 - Live 0xffffffff883d7000
xt_limit 4032 0 - Live 0xffffffff881c4000
ipt_tos 2560 0 - Live 0xffffffff88195000
ipt_REJECT 5632 0 - Live 0xffffffff883d4000
ipt_MASQUERADE 4800 1 - Live 0xffffffff883d1000
iptable_nat 8452 1 - Live 0xffffffff883cd000
nf_nat 21676 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffff883c6000
nf_conntrack_ipv4 19856 2 iptable_nat, Live 0xffffffff883c0000
ppdev 10184 0 - Live 0xffffffff883bc000
lp 13700 0 - Live 0xffffffff883b7000
xt_TCPMSS 5504 1 - Live 0xffffffff883b4000
xt_tcpmss 3200 1 - Live 0xffffffff880db000
xt_tcpudp 4288 14 - Live 0xffffffff883b1000
iptable_filter 4032 1 - Live 0xffffffff88092000
ip_tables 20776 3 iptable_mangle,iptable_nat,iptable_filter, Live 0xfffffff=
f883aa000
x_tables 21896 12 xt_length,ipt_ttl,xt_multiport,xt_limit,ipt_tos,ipt_REJEC=
T,ipt_MASQUERADE,iptable_nat,xt_TCPMSS,xt_tcpmss,xt_tcpudp,ip_tables, Live =
0xffffffff883a3000
pppoe 15680 2 - Live 0xffffffff8839e000
pppox 5592 1 pppoe, Live 0xffffffff8839b000
ppp_generic 30688 6 pppoe,pppox, Live 0xffffffff88392000
ipv6 278664 34 - Live 0xffffffff8834c000
deflate 4800 0 - Live 0xffffffff88349000
zlib_deflate 20440 1 deflate, Live 0xffffffff88343000
twofish 7744 0 - Live 0xffffffff88340000
twofish_common 38528 1 twofish, Live 0xffffffff88335000
serpent 19392 0 - Live 0xffffffff8832f000
aes_x86_64 26408 0 - Live 0xffffffff88327000
aes_generic 27328 0 - Live 0xffffffff8831f000
blowfish 9600 0 - Live 0xffffffff8831b000
des_generic 17728 0 - Live 0xffffffff88315000
ecb 4608 0 - Live 0xffffffff88312000
sha256_generic 9664 0 - Live 0xffffffff8830e000
sha1_generic 3648 0 - Live 0xffffffff88059000
crypto_null 3648 0 - Live 0xffffffff88042000
af_key 37460 0 - Live 0xffffffff88303000
dm_snapshot 18464 0 - Live 0xffffffff882fd000
dm_mirror 24448 0 - Live 0xffffffff882f6000
dm_mod 62000 2 dm_snapshot,dm_mirror, Live 0xffffffff882e5000
it87 24912 0 - Live 0xffffffff882dd000
hwmon_vid 3776 1 it87, Live 0xffffffff88032000
eeprom 9104 0 - Live 0xffffffff882d9000
uhci_hcd 26584 0 - Live 0xffffffff882d1000
usb_storage 79168 0 - Live 0xffffffff882bc000
sbp2 26248 0 - Live 0xffffffff882b4000
ac 7688 0 - Live 0xffffffff882b1000
container 6208 0 - Live 0xffffffff882ae000
fan 6216 0 - Live 0xffffffff882ab000
video 22036 0 - Live 0xffffffff882a4000
output 5056 1 video, Live 0xffffffff882a1000
rsrc_nonstatic 12480 0 - Live 0xffffffff8829c000
pcmcia_core 43620 1 rsrc_nonstatic, Live 0xffffffff88290000
capidrv 31248 1 - Live 0xffffffff88287000
isdn 137184 5 capidrv, Live 0xffffffff88264000
slhc 7104 2 ppp_generic,isdn, Live 0xffffffff88261000
capi 19904 0 - Live 0xffffffff8825b000
capifs 7312 2 capi, Live 0xffffffff88258000
kernelcapi 46496 3 fcpci,capidrv,capi, Live 0xffffffff8824b000
crc_ccitt 3008 0 - Live 0xffffffff88026000
sk98lin 142688 0 - Live 0xffffffff88227000
ac97_codec 19480 0 - Live 0xffffffff88221000
autofs4 25416 0 - Live 0xffffffff88219000
bt878 12616 0 - Live 0xffffffff88214000
tuner 44512 0 - Live 0xffffffff88208000
tea5767 6852 1 tuner, Live 0xffffffff88205000
tda8290 12740 1 tuner, Live 0xffffffff88200000
tuner_simple 9032 1 tuner, Live 0xffffffff881fc000
mt20xx 13192 1 tuner, Live 0xffffffff881f7000
tea5761 6084 1 tuner, Live 0xffffffff881f4000
usblp 16512 0 - Live 0xffffffff881ee000
tvaudio 26204 0 - Live 0xffffffff881e6000
msp3400 31456 0 - Live 0xffffffff881dd000
usbhid 31648 0 - Live 0xffffffff881d4000
bttv 201844 1 bt878, Live 0xffffffff88162000
firmware_class 11968 1 bttv, Live 0xffffffff88153000
ir_common 38916 1 bttv, Live 0xffffffff88148000
compat_ioctl32 9536 1 bttv, Live 0xffffffff88127000
i2c_algo_bit 7364 1 bttv, Live 0xffffffff88124000
parport_pc 38824 1 - Live 0xffffffff880f0000
videobuf_dma_sg 15364 1 bttv, Live 0xffffffff880eb000
videobuf_core 20036 2 bttv,videobuf_dma_sg, Live 0xffffffff880e5000
btcx_risc 5832 1 bttv, Live 0xffffffff880af000
parport 42060 3 ppdev,lp,parport_pc, Live 0xffffffff880cf000
ohci1394 33332 0 - Live 0xffffffff880c5000
tveeprom 18704 1 bttv, Live 0xffffffff880bf000
videodev 29120 1 bttv, Live 0xffffffff880b6000
pcspkr 4096 0 - Live 0xffffffff880b2000
floppy 63144 0 - Live 0xffffffff8809e000
analog 11744 0 - Live 0xffffffff8809a000
gameport 17552 2 snd_ens1371,analog, Live 0xffffffff88094000
ieee1394 99224 2 sbp2,ohci1394, Live 0xffffffff88078000
v4l2_common 20672 6 tuner,tvaudio,msp3400,bttv,compat_ioctl32,videodev, Liv=
e 0xffffffff88060000
v4l1_compat 12740 2 bttv,videodev, Live 0xffffffff8805b000
sky2 48516 0 - Live 0xffffffff8804c000
forcedeth 49868 0 - Live 0xffffffff88034000
ehci_hcd 35724 0 - Live 0xffffffff88028000
ohci_hcd 24708 0 - Live 0xffffffff8801e000
i2c_nforce2 7552 0 - Live 0xffffffff8801b000
thermal 19104 0 - Live 0xffffffff88015000
button 10336 0 - Live 0xffffffff88011000
processor 42120 1 thermal, Live 0xffffffff88005000
evdev 14016 1 - Live 0xffffffff88000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:0f.0
  0170-0177 : ide1
01f0-01f7 : 0000:00:0f.0
0376-0376 : 0000:00:0f.0
  0376-0376 : ide1
0378-037a : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:0f.0
03f7-03f7 : floppy DIR
03f8-03ff : serial
04d0-04d1 : pnp 00:09
0500-057f : pnp 00:09
  0500-0503 : ACPI PM1a_EVT_BLK
  0504-0505 : ACPI PM1a_CNT_BLK
  0508-050b : ACPI PM_TMR
  0520-0527 : ACPI GPE0_BLK
0580-05ff : pnp 00:09
0600-063f : 0000:00:0a.1
  0600-063f : nForce2_smbus
0700-073f : 0000:00:0a.1
  0700-073f : nForce2_smbus
0778-077a : parport0
0800-080f : pnp 00:09
0880-08ff : pnp 00:09
0900-097f : pnp 00:09
0980-09ff : pnp 00:09
0a20-0a2f : pnp 00:0d
0a30-0a3f : pnp 00:0d
0c00-0c0f : pnp 00:0d
0cf8-0cff : PCI conf1
0d00-0d0f : pnp 00:0d
  0d05-0d06 : it87
    0d05-0d06 : it87
5010-5015 : ACPI CPU throttle
9000-9fff : PCI Bus #01
  9c00-9c7f : 0000:01:00.0
a000-afff : PCI Bus #02
  a800-a8ff : 0000:02:00.0
    a800-a8ff : sky2
b000-bfff : PCI Bus #04
  b880-b8bf : 0000:04:07.0
    b880-b8bf : Ensoniq AudioPCI
  bc00-bc1f : 0000:04:06.0
    bc00-bc1f : fcpci
c480-c487 : 0000:00:13.0
  c480-c487 : forcedeth
c800-c80f : 0000:00:11.0
  c800-c80f : libata
c880-c883 : 0000:00:11.0
  c880-c883 : libata
cc00-cc07 : 0000:00:11.0
  cc00-cc07 : libata
d000-d003 : 0000:00:11.0
  d000-d003 : libata
d080-d087 : 0000:00:11.0
  d080-d087 : libata
d400-d40f : 0000:00:10.0
  d400-d40f : libata
d480-d483 : 0000:00:10.0
  d480-d483 : libata
d800-d807 : 0000:00:10.0
  d800-d807 : libata
d880-d883 : 0000:00:10.0
  d880-d883 : libata
dc00-dc07 : 0000:00:10.0
  dc00-dc07 : libata
e000-e0ff : 0000:00:0d.0
  e000-e0ff : NVidia CK804
e400-e4ff : 0000:00:0d.0
  e400-e4ff : NVidia CK804
ec00-ec1f : 0000:00:0a.1
ffa0-ffaf : 0000:00:0f.0
  ffa0-ffa7 : ide0
  ffa8-ffaf : ide1

cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000c0000-000cffff : pnp 00:0f
000e5000-000fffff : reserved
00100000-3ffaffff : System RAM
  00200000-004771e0 : Kernel code
  004771e1-005a1a4f : Kernel data
  00615000-006944f7 : Kernel bss
3ffb0000-3ffbdfff : ACPI Tables
3ffbe000-3ffdffff : ACPI Non-volatile Storage
3ffe0000-3fffffff : reserved
bfe00000-dfdfffff : PCI Bus #03
  c0000000-cfffffff : 0000:03:00.0
dfe00000-dfefffff : PCI Bus #04
  dfefe000-dfefefff : 0000:04:08.0
    dfefe000-dfefefff : bttv0
  dfeff000-dfefffff : 0000:04:08.1
    dfeff000-dfefffff : Bt87x audio
e0000000-efffffff : pnp 00:0e
f4600000-f47fffff : PCI Bus #01
  f4700000-f477ffff : 0000:01:00.0
  f47f8000-f47fbfff : 0000:01:00.0
    f47f8000-f47fbfff : sata_sil24
  f47ffc00-f47ffc7f : 0000:01:00.0
    f47ffc00-f47ffc7f : sata_sil24
f4800000-f48fffff : PCI Bus #02
  f48c0000-f48dffff : 0000:02:00.0
  f48fc000-f48fffff : 0000:02:00.0
    f48fc000-f48fffff : sky2
f4900000-fe9fffff : PCI Bus #03
  f8000000-fbffffff : 0000:03:00.0
  fd000000-fdffffff : 0000:03:00.0
  fe9e0000-fe9fffff : 0000:03:00.0
fea00000-feafffff : PCI Bus #04
  feaf8000-feafbfff : 0000:04:0b.0
  feaff000-feaff7ff : 0000:04:0b.0
    feaff000-feaff7ff : ohci1394
  feaffc00-feaffc1f : 0000:04:06.0
febfa000-febfafff : 0000:00:13.0
  febfa000-febfafff : forcedeth
febfb000-febfbfff : 0000:00:11.0
  febfb000-febfbfff : sata_nv
febfc000-febfcfff : 0000:00:10.0
  febfc000-febfcfff : sata_nv
febfd000-febfdfff : 0000:00:0d.0
  febfd000-febfdfff : NVidia CK804
febfe000-febfefff : 0000:00:0b.0
  febfe000-febfefff : ohci_hcd
febffc00-febffcff : 0000:00:0b.1
  febffc00-febffcff : ehci_hcd
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : reserved
fee00000-fee00fff : Local APIC
fee01000-feefffff : pnp 00:09
fefff000-feffffff : pnp 00:09
ff700000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=3D0 UnitCnt=3D15 MastHost- DefDir- DUL-
                Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <C=
RCErr=3D0 IsocEn- LSEn+ ExtCTL- 64b-
                Link Config 0: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- L=
WI=3D16bit DwFcInEn- LWO=3D16bit DwFcOutEn-
                Link Control 1: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <C=
RCErr=3D0 IsocEn+ LSEn+ ExtCTL- 64b-
                Link Config 1: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- L=
WI=3D16bit DwFcInEn- LWO=3D16bit DwFcOutEn-
                Revision ID: 1.03
                Link Frequency 0: 1.0GHz
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz=
+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UI=
DRD-
                Link Frequency 1: 1.0GHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz+ 300MHz+ 400MHz+ 500MHz=
+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SE=
RRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [e0] HyperTransport: MSI Mapping

00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0

00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [44] #00 [0000]

00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81d2
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (pro=
g-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0
        I/O behind bridge: 00009000-00009fff
        Memory behind bridge: f4600000-f47fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Subsystem: nVidia Corporation Unknown device 000=
0
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g-
                Device: Latency L0s <512ns, L1 <4us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 2
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpis=
e-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (pro=
g-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
0
        I/O behind bridge: 0000a000-0000afff
        Memory behind bridge: f4800000-f48fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Subsystem: nVidia Corporation Unknown device 000=
0
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g-
                Device: Latency L0s <512ns, L1 <4us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpis=
e-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (pro=
g-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f4900000-fe9fffff
        Prefetchable memory behind bridge: 00000000bfe00000-00000000dfdffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [40] Subsystem: nVidia Corporation Unknown device 000=
0
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g-
                Device: Latency L0s <512ns, L1 <4us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 0
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x16
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpis=
e-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:09.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev =
a4)
        Subsystem: ASUSTeK Computer Inc. Unknown device 815a
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=3D9 UnitCnt=3D15 MastHost- DefDir- DUL-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <C=
RCErr=3D0 IsocEn+ LSEn- ExtCTL- 64b-
                Link Config 0: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- L=
WI=3D16bit DwFcInEn- LWO=3D16bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <C=
RCErr=3D0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=3D8bit DwFcIn- MLWO=3D8bit DwFcOut- LWI=
=3D8bit DwFcInEn- LWO=3D8bit DwFcOutEn-
                Revision ID: 1.03
                Link Frequency 0: 1.0GHz
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz=
+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UI=
DRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz=
- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SE=
RRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [e0] HyperTransport: MSI Mapping

00:0a.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a4)
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0

00:0a.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at ec00 [size=3D32]
        Region 4: I/O ports at 0600 [size=3D64]
        Region 5: I/O ports at 0700 [size=3D64]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0b.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) (p=
rog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at febfe000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0b.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a4) (p=
rog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin B routed to IRQ 23
        Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=3D256=
]
        Capabilities: [44] Debug port
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0d.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio C=
ontroller (rev a2)
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0 (500ns min, 1250ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at e400 [size=3D256]
        Region 1: I/O ports at e000 [size=3D256]
        Region 2: Memory at febfd000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0f.0 IDE interface: nVidia Corporation CK804 IDE (rev f3) (prog-if 8a [M=
aster SecP PriP])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [=
disabled] [size=3D8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [=
disabled] [size=3D1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [=
disabled] [size=3D8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [=
disabled] [size=3D1]
        Region 4: I/O ports at ffa0 [size=3D16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:10.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev =
f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 815a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 23
        Region 0: I/O ports at dc00 [size=3D8]
        Region 1: I/O ports at d880 [size=3D4]
        Region 2: I/O ports at d800 [size=3D8]
        Region 3: I/O ports at d480 [size=3D4]
        Region 4: I/O ports at d400 [size=3D16]
        Region 5: Memory at febfc000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:11.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev =
f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at d080 [size=3D8]
        Region 1: I/O ports at d000 [size=3D4]
        Region 2: I/O ports at cc00 [size=3D8]
        Region 3: I/O ports at c880 [size=3D4]
        Region 4: I/O ports at c800 [size=3D16]
        Region 5: Memory at febfb000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:12.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if 0=
1 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D=
64
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: dfe00000-dfefffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR+
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:13.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at febfa000 (32-bit, non-prefetchable) [size=3D4K]
        Region 1: I/O ports at c480 [size=3D8]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=3D0 DScale=3D0 PME-

00:16.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if =
00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g-
                Device: Latency L0s <512ns, L1 <4us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 1
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x8
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpis=
e-
                Slot: Number 2, PowerLimit 25.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:17.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if =
00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ffff=
f
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g-
                Device: Latency L0s <512ns, L1 <4us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 0
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x16
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpis=
e-
                Slot: Number 1, PowerLimit 75.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Hyp=
erTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Capabilities: [80] HyperTransport: Host or Secondary Interface
                !!! Possibly incomplete decoding
                Command: WarmRst+ DblEnd-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRC=
Err=3D0
                Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16=
bit
                Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Add=
ress Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Mis=
cellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-

01:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid I=
I Controller (rev 01)
        Subsystem: ASUSTeK Computer Inc. Unknown device 8177
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f47ffc00 (64-bit, non-prefetchable) [size=3D128=
]
        Region 2: Memory at f47f8000 (64-bit, non-prefetchable) [size=3D16K=
]
        Region 4: I/O ports at 9c00 [size=3D128]
        Expansion ROM at f4700000 [disabled] [size=3D512K]
        Capabilities: [54] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, ExtT=
ag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gi=
gabit Ethernet Controller (rev 15)
        Subsystem: ASUSTeK Computer Inc. Marvell 88E8053 Gigabit Ethernet c=
ontroller PCIe (Asus)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f48fc000 (64-bit, non-prefetchable) [size=3D16K=
]
        Region 2: I/O ports at a800 [size=3D256]
        Expansion ROM at f48c0000 [disabled] [size=3D128K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g-
                Device: Latency L0s unlimited, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1
                Link: Latency L0s <256ns, L1 unlimited
                Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

03:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 6600] (=
rev a2) (prog-if 00 [VGA])
        Subsystem: Giga-byte Technology GV-NX66128DP Turbo Force Edition
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=3D64M=
]
        Region 1: Memory at c0000000 (64-bit, prefetchable) [size=3D256M]
        Region 3: Memory at fd000000 (64-bit, non-prefetchable) [size=3D16M=
]
        Expansion ROM at fe9e0000 [disabled] [size=3D128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTa=
g-
                Device: Latency L0s <512ns, L1 <4us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port=
 0
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x16

04:06.0 Network controller: AVM Audiovisuelles MKTG & Computer System GmbH =
Fritz!PCI v2.0 ISDN (rev 02)
        Subsystem: AVM Audiovisuelles MKTG & Computer System GmbH Fritz!PCI=
 v2.0 ISDN
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at feaffc00 (32-bit, non-prefetchable) [size=3D32]
        Region 1: I/O ports at bc00 [size=3D32]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=3D55mA PME(D0-,D1-,D=
2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

04:07.0 Multimedia audio controller: Ensoniq 5880 AudioPCI (rev 02)
        Subsystem: Ensoniq Creative Sound Blaster AudioPCI128
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <T=
Abort+ <MAbort- >SERR- <PERR-
        Latency: 64 (3000ns min, 32000ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at b880 [size=3D64]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI+ D1- D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

04:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capt=
ure (rev 11)
        Subsystem: Hauppauge computer works Inc. WinTV Series
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at dfefe000 (32-bit, prefetchable) [size=3D4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

04:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (r=
ev 11)
        Subsystem: Hauppauge computer works Inc. WinTV Series
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at dfeff000 (32-bit, prefetchable) [size=3D4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2=
-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

04:0b.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000=
 Controller (PHY/Link) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-=
 Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at feaff000 (32-bit, non-prefetchable) [size=3D2K]
        Region 1: Memory at feaf8000 (32-bit, non-prefetchable) [size=3D16K=
]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME+


[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG SP2504C  Rev: VT10
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[X.] I think, I don't need this module - all I testing (radio, television) =
from my btx-card run properly.

with regards
Andreas Matthus

--=20
Andreas Matthus <matthus@nexgo.de>

--=-GHemltd02lZeHImCXDDs
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIII/zCCAtow
ggJDoAMCAQICEFspEm+sWtV26Rr0rllvxvcwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDkxMjE1NDkxN1oXDTA4MDkxMTE1NDkx
N1owQjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEfMB0GCSqGSIb3DQEJARYQbWF0
dGh1c0BuZXhnby5kZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMoqx2+JCfu48KQp
4jLV7Zno34j8iQYRcv5pBTRT9MHHnMMc8ZQfmKi28RAPmAP1zazlCvtKnr05wM5pePwBIoOVOZ17
EMfSbVSp5jM44GHcJH5iyeWJAcvFKaJDuDPmIvRLq8KUUTEAJ/XJjb0xcpEa926ck9s9dpkvMQaL
juzDW2P7Ez8HR0xCJx0UfAOiYseswxy1M6NZG8gXdgxh+gLdQnM2Ch34QDA4VrOP14+vIY4wTk/A
Z+w9ob/JID4z3Km8uN5fUFKVH2VbFf5QdF7S+7O+IhxRuQnY8+/i4ArB2xWkW2zI2NMufgnozZfu
qliTD4rYWQP74lNlDBBrasECAwEAAaMtMCswGwYDVR0RBBQwEoEQbWF0dGh1c0BuZXhnby5kZTAM
BgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAH2A9LZ8BLBUL6ZCBW9qmilzaEUi7/Zzkm85
uvYQxgiwGtKIJfQxWlTmi7mjICdPzKMY2IFiXC9TGBqF4Pcz5Sj3aZXBR9p6AKbYAnTcK6vUqw2F
5x/s6OlJL+wWEoZm9cUwpaSbMvy1wlotLe3SE7/upOu23MLFkMfVrY527WQgMIIC2jCCAkOgAwIB
AgIQWykSb6xa1XbpGvSuWW/G9zANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJaQTElMCMGA1UE
ChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0EwHhcNMDcwOTEyMTU0OTE3WhcNMDgwOTExMTU0OTE3WjBCMR8w
HQYDVQQDExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMR8wHQYJKoZIhvcNAQkBFhBtYXR0aHVzQG5l
eGdvLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyirHb4kJ+7jwpCniMtXtmejf
iPyJBhFy/mkFNFP0wcecwxzxlB+YqLbxEA+YA/XNrOUK+0qevTnAzml4/AEig5U5nXsQx9JtVKnm
MzjgYdwkfmLJ5YkBy8UpokO4M+Yi9EurwpRRMQAn9cmNvTFykRr3bpyT2z12mS8xBouO7MNbY/sT
PwdHTEInHRR8A6Jix6zDHLUzo1kbyBd2DGH6At1CczYKHfhAMDhWs4/Xj68hjjBOT8Bn7D2hv8kg
PjPcqby43l9QUpUfZVsV/lB0XtL7s74iHFG5Cdjz7+LgCsHbFaRbbMjY0y5+CejNl+6qWJMPithZ
A/viU2UMEGtqwQIDAQABoy0wKzAbBgNVHREEFDASgRBtYXR0aHVzQG5leGdvLmRlMAwGA1UdEwEB
/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAfYD0tnwEsFQvpkIFb2qaKXNoRSLv9nOSbzm69hDGCLAa
0ogl9DFaVOaLuaMgJ0/MoxjYgWJcL1MYGoXg9zPlKPdplcFH2noAptgCdNwrq9SrDYXnH+zo6Ukv
7BYShmb1xTClpJsy/LXCWi0t7dITv+6k67bcwsWQx9WtjnbtZCAwggM/MIICqKADAgECAgENMA0G
CSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYD
VQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0
aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcN
MDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhh
d3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5o
wHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH
5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7
AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8v
Y3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYw
KQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUA
A4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZ
Ohl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NW
IXiC3CEZNd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZy
ZWVtYWlsIElzc3VpbmcgQ0ECEFspEm+sWtV26Rr0rllvxvcwCQYFKw4DAhoFAKCCAW8wGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMjE5MTkzNjM1WjAjBgkqhkiG
9w0BCQQxFgQUN/vwTS60mm8ANSccD26y33isAlcwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1Ro
YXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhBbKRJvrFrVduka9K5Zb8b3MIGHBgsq
hkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5n
IChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENB
AhBbKRJvrFrVduka9K5Zb8b3MA0GCSqGSIb3DQEBAQUABIIBADdwl01yn6BvldX4d9S2xfy0bIpW
JzKMWH1YANvqmBeryj5PU5OC/6JOSmlTWHbxycfG5yAAGn/nwFCH6Q49oOknVjG5NtLqr8m2PrNu
mM6a/GV1d+r2EZAQcVM7ima7QOphDOvSpfhPBV+4liQrt9s8VcwvuKdMAcoCoQu/T66wmycJCxQg
JxBUEz+QN//VrpRWxODY5fNrygz5CL6RHHaBMsrDDzv6laiISrYAMuyJy8qjkvPvg5SVQfxcnZuV
jF8AlcZm08uOjwCKhYapGuHpXStsv2ajaCfJpsV0diWeHerQkbTa/2QzCZPnZISsLtflDWJM4U0r
OzYAgTqiVcsAAAAAAAA=


--=-GHemltd02lZeHImCXDDs--

