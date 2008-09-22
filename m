Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYIVVuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYIVVuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYIVVuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:50:12 -0400
Received: from cp-out2.libero.it ([212.52.84.102]:36857 "EHLO
	cp-out2.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYIVVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:50:09 -0400
Date: Mon, 22 Sep 2008 23:50:06 +0200
Message-Id: <K7M9ZI$69A44BBF23D86D612A80B0EA98EEEE6B@libero.it>
Subject: OOPS bug KERNEL LINUX- Version 2.6.26
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1222120206.2A.251568.42.31374.52.42.007.1498538285"
From: "andrea_monta\@inwind\.it" <andrea_monta@inwind.it>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
X-XaM3-API-Version: 4.3 (R1) (B3pl25)
X-SenderIP: 84.222.124.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--_=__=_XaM3_.1222120206.2A.251568.42.31374.52.42.007.1498538285
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi everyone I ll try to send you the bug/error I met working with the ker=
nel 2.6.26 
I attached a file named bug.txt

Here you can find all inside.

Thank you all all you do for linux! 

Greetings 

Andrea Montagnana
andrea_monta@inwind.it


--_=__=_XaM3_.1222120206.2A.251568.42.31374.52.42.007.1498538285
Content-Type: text/plain;
	name="=?iso-8859-1?Q?bug.txt?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?bug.txt?="

1. Problem with usb-wireless-key =0A2. I can't find my device typing ifco=
nfig -a or iwconfig I don't find any wireless attached device. But I have=
 my usb wireless connected. A belkin usb wireless key.Before, with the ke=
rnel 2.6.25 all worked well=0A3. nothing=0A4. Linux version 2.6.26 (root@=
clementino) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #=
1 PREEMPT Mon Sep 22 15:57:45 CEST 2008=0A5.=0ABUG: unable to handle kern=
el NULL pointer dereference at 0000001c=0AIP: [<c01406d3>] __lock_acquire=
+0x1d3/0xfd0=0A*pde =3D 00000000=0AOops: 0000 [#1] PREEMPT=0AModules link=
ed in: rt73usb(+) crc_itu_t rt2x00usb rt2x00lib rfkill led_class input_po=
lldev usbhid p54usb p54common mac80211 cfg80211 snd_via82xx i2c_viapro ga=
meport snd_ac97_codec ac97_bus snd_mpu401_uart tuner_simple tuner_types s=
nd_rawmidi tuner tvaudio via_rhine msp3400 snd_bt87x snd_pcm_oss snd_mixe=
r_oss bttv videodev v4l1_compat ir_common snd_pcm compat_ioctl32 i2c_algo=
_bit uhci_hcd via_ircc v4l2_common videobuf_dma_sg videobuf_core ehci_hcd=
 btcx_risc irda thermal button snd_timer snd_page_alloc tveeprom usbcore =
i2c_core shpchp pci_hotplug via_agp evdev=0A=0APid: 2137, comm: modprobe =
Not tainted (2.6.26 #1)=0AEIP: 0060:[<c01406d3>] EFLAGS: 00010046 CPU: 0=0A=
EIP is at __lock_acquire+0x1d3/0xfd0=0AEAX: 00000000 EBX: 00000246 ECX: 0=
0000000 EDX: 00000018=0AESI: 00000000 EDI: 00000000 EBP: edc07cb4 ESP: ed=
c07c48=0A DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068=0AProcess modprobe=
 (pid: 2137, ti=3Dedc06000 task=3Def9fe030 task.ti=3Dedc06000)=0AStack: e=
f9fe030 c049283a 00000246 00000000 00000213 c068b262 ee9cf374 00000043=0A=
       00000000 00000000 00000018 00000004 ef9fe030 edc07c84 c04928d8 edc=
07cb4=0A       f0a766a4 00003000 edc07cf4 00001618 ee9cf160 00000002 edc0=
7cb4 c011fa5b=0ACall Trace:=0A [<c049283a>] ? __mutex_unlock_slowpath+0xa=
a/0x140=0A [<c04928d8>] ? mutex_unlock+0x8/0x10=0A [<f0a766a4>] ? rt2x00u=
sb_vendor_request_buff+0x64/0x80 [rt2x00usb]=0A [<c011fa5b>] ? printk+0x1=
b/0x20=0A [<c0141548>] ? lock_acquire+0x78/0xa0=0A [<c012f6e0>] ? flush_w=
orkqueue+0x0/0x60=0A [<c012f715>] ? flush_workqueue+0x35/0x60=0A [<c012f6=
e0>] ? flush_workqueue+0x0/0x60=0A [<f0a7b2b3>] ? rt2x00lib_remove_dev+0x=
33/0x60 [rt2x00lib]=0A [<f0a7bbda>] ? rt2x00lib_probe_dev+0x5a/0x3e0 [rt2=
x00lib]=0A [<f0a760ac>] ? rt2x00usb_alloc_reg+0x4c/0xa0 [rt2x00usb]=0A [<=
c0135483>] ? __mutex_init+0x43/0x60=0A [<f0a76b0b>] ? rt2x00usb_probe+0xc=
b/0x150 [rt2x00usb]=0A [<f087b97a>] ? usb_match_one_id+0x2a/0xb0 [usbcore=
]=0A [<f087c719>] ? usb_probe_interface+0x69/0xe0 [usbcore]=0A [<c0341ebb=
>] ? driver_sysfs_add+0x5b/0x80=0A [<c0341fe3>] ? driver_probe_device+0x8=
3/0x180=0A [<c0494409>] ? _spin_unlock_irqrestore+0x39/0x70=0A [<c0342155=
>] ? __driver_attach+0x75/0x80=0A [<c0341693>] ? bus_for_each_dev+0x43/0x=
70=0A [<c0341e59>] ? driver_attach+0x19/0x20=0A [<c03420e0>] ? __driver_a=
ttach+0x0/0x80=0A [<c0341aef>] ? bus_add_driver+0xaf/0x220=0A [<c03422ef>=
] ? driver_register+0x4f/0x130=0A [<c02c5cc2>] ? __spin_lock_init+0x32/0x=
60=0A [<f087c2a2>] ? usb_register_driver+0x82/0x100 [usbcore]=0A [<f08ae0=
17>] ? rt73usb_init+0x17/0x19 [rt73usb]=0A [<c0147e03>] ? sys_init_module=
+0x123/0x1a10=0A [<f0a7c710>] ? rt2x00mac_bss_info_changed+0x0/0x100 [rt2=
x00lib]=0A [<c0104189>] ? sysenter_past_esp+0x6a/0xb1=0A =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0ACode: 24 a4 82 56 c=
0 e8 8e f3 fd ff 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 31 d2 83 c4 60=
 89 d0 5b 5e 5f 5d c3 8d 74 26 00 8b 55 bc <8b> 7a 04 85 ff 0f 84 7a fe f=
f ff ff 87 c0 00 00 00 89 f8 e8 95=0AEIP: [<c01406d3>] __lock_acquire+0x1=
d3/0xfd0 SS:ESP 0068:edc07c48=0A---[ end trace 69bb391af1abff2a ]---=0Aet=
h0: link up, 100Mbps, full-duplex, lpa 0x45E1=0ANET: Registered protocol =
family 17=0ANET: Registered protocol family 10=0Alo: Disabled Privacy Ext=
ensions=0Awarning: `avahi-daemon' uses 32-bit capabilities (legacy suppor=
t in use)=0Aeth0: no IPv6 routers present=0A6.=0A7. Linux debian=0A7.2 pr=
ocessor       : 0=0Avendor_id       : GenuineIntel=0Acpu family      : 15=
=0Amodel           : 2=0Amodel name      : Intel(R) Celeron(R) CPU 2.60GH=
z=0Astepping        : 9=0Acpu MHz         : 2599.925=0Acache size      : =
128 KB=0Afdiv_bug        : no=0Ahlt_bug         : no=0Af00f_bug        : =
no=0Acoma_bug        : no=0Afpu             : yes=0Afpu_exception   : yes=
=0Acpuid level     : 2=0Awp              : yes=0Aflags           : fpu vm=
e de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush=
 dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr=0Abogomips    =
    : 5206.37=0Aclflush size    : 64=0Apower management:=0A7.3 modules=0A=
ipv6 269652 8 - Live 0xf0b26000=0Aaf_packet 16400 2 - Live 0xf0a95000=0Ar=
t73usb 25625 1 - Loading 0xf0a8d000=0Acrc_itu_t 2176 1 rt73usb, Live 0xf0=
964000=0Art2x00usb 10632 1 rt73usb, Live 0xf0a76000=0Art2x00lib 26032 2 r=
t73usb,rt2x00usb, Live 0xf0a7b000=0Arfkill 6812 1 rt2x00lib, Live 0xf082c=
000=0Aled_class 4108 1 rt2x00lib, Live 0xf0a6e000=0Ainput_polldev 4248 1 =
rt2x00lib, Live 0xf0a6b000=0Ausbhid 28608 0 - Live 0xf098f000=0Ap54usb 12=
680 0 - Live 0xf0977000=0Ap54common 11272 1 p54usb, Live 0xf097c000=0Amac=
80211 172716 4 rt2x00usb,rt2x00lib,p54usb,p54common, Live 0xf0aa2000=0Acf=
g80211 24344 2 rt2x00lib,mac80211, Live 0xf0988000=0Asnd_via82xx 23088 0 =
- Live 0xf0981000=0Ai2c_viapro 7956 0 - Live 0xf0923000=0Agameport 12312 =
1 snd_via82xx, Live 0xf08a2000=0Asnd_ac97_codec 98884 1 snd_via82xx, Live=
 0xf09da000=0Aac97_bus 1920 1 snd_ac97_codec, Live 0xf095d000=0Asnd_mpu40=
1_uart 7320 1 snd_via82xx, Live 0xf0927000=0Atuner_simple 13840 1 - Live =
0xf0972000=0Atuner_types 13952 1 tuner_simple, Live 0xf096d000=0Asnd_rawm=
idi 20672 1 snd_mpu401_uart, Live 0xf0966000=0Atuner 26440 0 - Live 0xf09=
1b000=0Atvaudio 22076 0 - Live 0xf0956000=0Avia_rhine 21784 0 - Live 0xf0=
8d9000=0Amsp3400 29644 0 - Live 0xf0908000=0Asnd_bt87x 12260 0 - Live 0xf=
0904000=0Asnd_pcm_oss 36800 0 - Live 0xf0911000=0Asnd_mixer_oss 13960 1 s=
nd_pcm_oss, Live 0xf08ff000=0Abttv 174580 0 - Live 0xf092a000=0Avideodev =
31648 3 tuner,msp3400,bttv, Live 0xf08b0000=0Av4l1_compat 14084 1 videode=
v, Live 0xf08d4000=0Air_common 40068 1 bttv, Live 0xf08e0000=0Asnd_pcm 72=
492 4 snd_via82xx,snd_ac97_codec,snd_bt87x,snd_pcm_oss, Live 0xf08ec000=0A=
compat_ioctl32 1280 1 bttv, Live 0xf08a7000=0Ai2c_algo_bit 6020 1 bttv, L=
ive 0xf08a9000=0Auhci_hcd 21652 0 - Live 0xf089b000=0Avia_ircc 18972 0 - =
Live 0xf085e000=0Av4l2_common 11264 4 tuner,tvaudio,msp3400,bttv, Live 0x=
f084e000=0Avideobuf_dma_sg 12420 1 bttv, Live 0xf0864000=0Avideobuf_core =
17932 2 bttv,videobuf_dma_sg, Live 0xf0895000=0Aehci_hcd 32404 0 - Live 0=
xf086a000=0Abtcx_risc 4616 1 bttv, Live 0xf085b000=0Airda 106476 1 via_ir=
cc, Live 0xf08b9000=0Athermal 15524 0 - Live 0xf0837000=0Abutton 6288 0 -=
 Live 0xf084b000=0Asnd_timer 21148 1 snd_pcm, Live 0xf0854000=0Asnd_page_=
alloc 8584 3 snd_via82xx,snd_bt87x,snd_pcm, Live 0xf083c000=0Atveeprom 12=
164 1 bttv, Live 0xf0847000=0Ausbcore 133808 7 rt73usb,rt2x00usb,usbhid,p=
54usb,uhci_hcd,ehci_hcd, Live 0xf0873000=0Ai2c_core 22672 9 i2c_viapro,tu=
ner_simple,tuner,tvaudio,msp3400,bttv,i2c_algo_bit,v4l2_common,tveeprom, =
Live 0xf0840000=0Ashpchp 31056 0 - Live 0xf0823000=0Apci_hotplug 27812 1 =
shpchp, Live 0xf082f000=0Avia_agp 8192 1 - Live 0xf0820000=0Aevdev 9760 0=
 - Live 0xf081c000=0A7.4 =0A0000-001f : dma1=0A0020-0021 : pic1=0A0040-00=
43 : timer0=0A0050-0053 : timer1=0A0060-0060 : keyboard=0A0064-0064 : key=
board=0A0070-0077 : rtc=0A0080-008f : dma page reg=0A00a0-00a1 : pic2=0A0=
0c0-00df : dma2=0A00f0-00ff : fpu=0A0170-0177 : 0000:00:11.1=0A  0170-017=
7 : VP_IDE=0A01f0-01f7 : 0000:00:11.1=0A  01f0-01f7 : VP_IDE=0A0376-0376 =
: 0000:00:11.1=0A  0376-0376 : VP_IDE=0A03c0-03df : vga+=0A03f2-03f5 : fl=
oppy=0A03f6-03f6 : 0000:00:11.1=0A  03f6-03f6 : VP_IDE=0A03f7-03f7 : flop=
py DIR=0A03f8-03ff : serial=0A0400-040f : 0000:00:11.0=0A  0400-0407 : vt=
596_smbus=0A0800-087f : 0000:00:11.0=0A  0800-0803 : ACPI PM1a_EVT_BLK=0A=
  0804-0805 : ACPI PM1a_CNT_BLK=0A  0808-080b : ACPI PM_TMR=0A  0810-0815=
 : ACPI CPU throttle=0A  0820-0823 : ACPI GPE0_BLK=0A0cf8-0cff : PCI conf=
1=0Adc00-dcff : 0000:00:12.0=0A  dc00-dcff : via-rhine=0Ae000-e0ff : 0000=
:00:11.5=0A  e000-e0ff : VIA8233=0Ae400-e41f : 0000:00:10.0=0A  e400-e41f=
 : uhci_hcd=0Ae800-e81f : 0000:00:10.1=0A  e800-e81f : uhci_hcd=0Aec00-ec=
1f : 0000:00:10.2=0A  ec00-ec1f : uhci_hcd=0Afc00-fc0f : 0000:00:11.1=0A =
 fc00-fc0f : VP_IDE=0A-------------------------------=0A00000000-0009fbff=
 : System RAM=0A0009fc00-0009ffff : reserved=0A000a0000-000bffff : Video =
RAM area=0A000c0000-000cf7ff : Video ROM=0A000d4000-000d9fff : reserved=0A=
000f0000-000fffff : System ROM=0A00100000-2ffeffff : System RAM=0A  00100=
000-00494ed6 : Kernel code=0A  00494ed7-0061f797 : Kernel data=0A  0067a0=
00-008c5f57 : Kernel bss=0A2fff0000-2fff7fff : ACPI Tables=0A2fff8000-2ff=
fffff : ACPI Non-volatile Storage=0Acdc00000-ddcfffff : PCI Bus 0000:01=0A=
  d0000000-d7ffffff : 0000:01:00.0=0Adddfe000-dddfefff : 0000:00:09.0=0A =
 dddfe000-dddfefff : bttv0=0Adddff000-dddfffff : 0000:00:09.1=0A  dddff00=
0-dddfffff : Bt87x audio=0Adde00000-dfefffff : PCI Bus 0000:01=0A  de0000=
00-deffffff : 0000:01:00.0=0A  dfee0000-dfefffff : 0000:01:00.0=0Adffffe0=
0-dffffeff : 0000:00:12.0=0A  dffffe00-dffffeff : via-rhine=0Adfffff00-df=
ffffff : 0000:00:10.3=0A  dfffff00-dfffffff : ehci_hcd=0Ae0000000-e3fffff=
f : 0000:00:00.0=0Afec00000-fec00fff : reserved=0Afee00000-fee00fff : res=
erved=0Afff80000-ffffffff : reserved=0A7.5 lspci -vvv=0A00:00.0 Host brid=
ge: VIA Technologies, Inc. P4M266 Host Bridge=0A        Subsystem: VIA Te=
chnologies, Inc. Unknown device 0000=0A        Control: I/O- Mem+ BusMast=
er+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-=0A    =
    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <T=
Abort- <MAbort+ >SERR- <PERR-=0A        Latency: 8=0A        Region 0: Me=
mory at e0000000 (32-bit, prefetchable) [size=3D64M]=0A        Capabiliti=
es: [a0] AGP version 2.0=0A                Status: RQ=3D32 Iso- ArqSz=3D0=
 Cal=3D0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=3Dx1,x2,x4=0A=
                Command: RQ=3D1 ArqSz=3D0 Cal=3D0 SBA- AGP- GART64- 64bit=
- FW- Rate=3D<none>=0A        Capabilities: [c0] Power Management version=
 2=0A                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-=
,D1-,D2-,D3hot-,D3cold-)=0A                Status: D0 PME-Enable- DSel=3D=
0 DScale=3D0 PME-=0A=0A00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 =
[Apollo Pro266 AGP] (prog-if 00 [Normal decode])=0A        Control: I/O+ =
Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ Fas=
tB2B-=0A        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium=
 >TAbort- <TAbort- <MAbort+ >SERR- <PERR-=0A        Latency: 0=0A        =
Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0=0A  =
      I/O behind bridge: 0000f000-00000fff=0A        Memory behind bridge=
: dde00000-dfefffff=0A        Prefetchable memory behind bridge: cdc00000=
-ddcfffff=0A        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfa=
st >TAbort- <TAbort- <MAbort- <SERR- <PERR-=0A        BridgeCtl: Parity- =
SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-=0A        Capabilities: [80] P=
ower Management version 2=0A                Flags: PMEClk- DSI- D1+ D2- A=
uxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A                Status:=
 D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=0A00:09.0 Multimedia video co=
ntroller: Brooktree Corporation Bt878 Video Capture (rev 02)=0A        Su=
bsystem: Hauppauge computer works Inc. WinTV Series=0A        Control: I/=
O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ =
FastB2B-=0A        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmed=
ium >TAbort- <TAbort- <MAbort- >SERR- <PERR-=0A        Latency: 32 (4000n=
s min, 10000ns max)=0A        Interrupt: pin A routed to IRQ 10=0A       =
 Region 0: Memory at dddfe000 (32-bit, prefetchable) [size=3D4K]=0A=0A00:=
09.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (re=
v 02)=0A        Subsystem: Hauppauge computer works Inc. WinTV Series=0A =
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR+ FastB2B-=0A        Status: Cap- 66MHz- UDF- FastB2B+ Pa=
rErr- DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- <PERR-=0A        =
Latency: 32 (1000ns min, 63750ns max)=0A        Interrupt: pin A routed t=
o IRQ 10=0A        Region 0: Memory at dddff000 (32-bit, prefetchable) [s=
ize=3D4K]=0A=0A00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx U=
HCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])=0A        Subsystem: =
VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller=0A        Contro=
l: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- S=
ERR- FastB2B-=0A        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3D=
medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-=0A        Latency: 32, Ca=
che Line Size: 32 bytes=0A        Interrupt: pin A routed to IRQ 11=0A   =
     Region 4: I/O ports at e400 [size=3D32]=0A        Capabilities: [80]=
 Power Management version 2=0A                Flags: PMEClk- DSI- D1+ D2+=
 AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A                Sta=
tus: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=0A00:10.1 USB Controller:=
 VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-=
if 00 [UHCI])=0A        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI =
USB 1.1 Controller=0A        Control: I/O+ Mem+ BusMaster+ SpecCycle- Mem=
WINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-=0A        Status: Cap+ 6=
6MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >S=
ERR- <PERR-=0A        Latency: 32, Cache Line Size: 32 bytes=0A        In=
terrupt: pin B routed to IRQ 10=0A        Region 4: I/O ports at e800 [si=
ze=3D32]=0A        Capabilities: [80] Power Management version 2=0A      =
          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,=
D3hot+,D3cold+)=0A                Status: D0 PME-Enable- DSel=3D0 DScale=3D=
0 PME-=0A=0A00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI=
 USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])=0A        Subsystem: VIA=
 Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller=0A        Control: =
I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR=
- FastB2B-=0A        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dm=
edium >TAbort- <TAbort- <MAbort- >SERR- <PERR-=0A        Latency: 32, Cac=
he Line Size: 32 bytes=0A        Interrupt: pin C routed to IRQ 5=0A     =
   Region 4: I/O ports at ec00 [size=3D32]=0A        Capabilities: [80] P=
ower Management version 2=0A                Flags: PMEClk- DSI- D1+ D2+ A=
uxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A                Statu=
s: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=0A00:10.3 USB Controller: V=
IA Technologies, Inc. USB 2.0 (rev 82) (prog-if 20 [EHCI])=0A        Subs=
ystem: VIA Technologies, Inc. USB 2.0=0A        Control: I/O+ Mem+ BusMas=
ter+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-=0A   =
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <=
TAbort- <MAbort- >SERR- <PERR-=0A        Latency: 32, Cache Line Size: 12=
8 bytes=0A        Interrupt: pin D routed to IRQ 12=0A        Region 0: M=
emory at dfffff00 (32-bit, non-prefetchable) [size=3D256]=0A        Capab=
ilities: [80] Power Management version 2=0A                Flags: PMEClk-=
 DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A      =
          Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=0A00:11.0 IS=
A bridge: VIA Technologies, Inc. VT8235 ISA Bridge=0A        Subsystem: V=
IA Technologies, Inc. Unknown device 0000=0A        Control: I/O+ Mem+ Bu=
sMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-=0A=
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-=0A        Latency: 0=0A        Capabili=
ties: [c0] Power Management version 2=0A                Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A           =
     Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=0A00:11.1 IDE int=
erface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC B=
us Master IDE (rev 06) (prog-if 8a [Master SecP PriP])=0A        Subsyste=
m: VIA Technologies, Inc. VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC =
Bus Master IDE=0A        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV=
- VGASnoop- ParErr- Stepping- SERR- FastB2B-=0A        Status: Cap+ 66MHz=
- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR-=
 <PERR-=0A        Latency: 32=0A        Interrupt: pin A routed to IRQ 25=
5=0A        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetcha=
ble) [size=3D8]=0A        Region 1: [virtual] Memory at 000003f0 (type 3,=
 non-prefetchable) [size=3D1]=0A        Region 2: [virtual] Memory at 000=
00170 (32-bit, non-prefetchable) [size=3D8]=0A        Region 3: [virtual]=
 Memory at 00000370 (type 3, non-prefetchable) [size=3D1]=0A        Regio=
n 4: I/O ports at fc00 [size=3D16]=0A        Capabilities: [c0] Power Man=
agement version 2=0A                Flags: PMEClk- DSI- D1- D2- AuxCurren=
t=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A                Status: D0 PME-=
Enable- DSel=3D0 DScale=3D0 PME-=0A=0A00:11.5 Multimedia audio controller=
: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 50=
)=0A        Subsystem: VIA Technologies, Inc. K7VT2 motherboard=0A       =
 Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B-=0A        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- =
DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- <PERR-=0A        Interr=
upt: pin C routed to IRQ 5=0A        Region 0: I/O ports at e000 [size=3D=
256]=0A        Capabilities: [c0] Power Management version 2=0A          =
      Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-=
,D3cold-)=0A                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PM=
E-=0A=0A00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine=
-II] (rev 74)=0A        Subsystem: VIA Technologies, Inc. VT6102 [Rhine I=
I] Embeded Ethernet Controller on VT8235=0A        Control: I/O+ Mem+ Bus=
Master+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-=0A=
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-=0A        Latency: 32 (750ns min, 2000n=
s max), Cache Line Size: 32 bytes=0A        Interrupt: pin A routed to IR=
Q 11=0A        Region 0: I/O ports at dc00 [size=3D256]=0A        Region =
1: Memory at dffffe00 (32-bit, non-prefetchable) [size=3D256]=0A        C=
apabilities: [40] Power Management version 2=0A                Flags: PME=
Clk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A    =
            Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=0A01:00.0 =
VGA compatible controller: nVidia Corporation NV34 [GeForce FX 5200] (rev=
 a1) (prog-if 00 [VGA])=0A        Subsystem: ASUSTeK Computer Inc. Unknow=
n device 8180=0A        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV-=
 VGASnoop- ParErr- Stepping- SERR- FastB2B-=0A        Status: Cap+ 66MHz+=
 UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- =
<PERR-=0A        Latency: 32 (1250ns min, 250ns max)=0A        Interrupt:=
 pin A routed to IRQ 11=0A        Region 0: Memory at de000000 (32-bit, n=
on-prefetchable) [size=3D16M]=0A        Region 1: Memory at d0000000 (32-=
bit, prefetchable) [size=3D128M]=0A        Expansion ROM at dfee0000 [dis=
abled] [size=3D128K]=0A        Capabilities: [60] Power Management versio=
n 2=0A                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0=
-,D1-,D2-,D3hot-,D3cold-)=0A                Status: D0 PME-Enable- DSel=3D=
0 DScale=3D0 PME-=0A        Capabilities: [44] AGP version 3.0=0A        =
        Status: RQ=3D32 Iso- ArqSz=3D0 Cal=3D0 SBA+ ITACoh- GART64- HTran=
s- 64bit- FW+ AGP3- Rate=3Dx1,x2,x4=0A                Command: RQ=3D1 Arq=
Sz=3D0 Cal=3D0 SBA- AGP- GART64- 64bit- FW- Rate=3D<none>=0A7.6 Nothing=0A=
7.7 nothing=0A =0A

--_=__=_XaM3_.1222120206.2A.251568.42.31374.52.42.007.1498538285--

