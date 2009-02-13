Return-Path: <linux-kernel-owner+w=401wt.eu-S1760381AbZBMSpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbZBMSpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZBMSp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:45:27 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:52447 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZBMSpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:45:24 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: cannot get stable system since 2.6.28 kernel
Date: Fri, 13 Feb 2009 19:44:56 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.10-phiphi; KDE/4.2.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131944.56634.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] I cannot get a stable system with new kernel 2.6.28.* and 2.6.29-rc*
****************************************************
[2] I'm on Debian/Unstable with custom 2.6.27.10 kernel from kernel.org
With the exact same config file, kernel 2.6.28.* won't boot (stalls in "booting 
the kernel ..."), and 2.6.29-rc* boot but system freeze randomly sometimes 
after 20s, sometimes 2 minutes, and I need to "hard reboot" the system...
After some "googling", I tried to disable the "Max CPUID Value Limit" in my 
bios : this will get 2.6.28* to boot a bit more but cannot find filesystem. 
2.6.29-rc* stalls randomly and even 2.6.27.10 will stall randomly with this 
setting disabled in the bios.
****************************************************
[3] kernel ; boot 
****************************************************
[4] cat /proc/version
Linux version 2.6.27.10-phiphi (root@debian) (gcc version 4.3.3 20090110 
(prerelease) (Debian 4.3.2-2) ) #1 SMP PREEMPT Thu Jan 15 19:46:14 CET 2009
****************************************************
[5] 
[6]
[7]
****************************************************
[7.1] output of ver_linux :
Gnu C                  4.3.3
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      found
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         nls_cp437 vfat fat usb_storage nls_utf8 cifs nls_base 
nvidia binfmt_misc uinput ipv6 coretempsbp2 loop joydev usbhid hid 
snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd ohci1394 i2c_i801 
soundcore skge sky2 ehci_hcd snd_page_alloc uhci_hcd pcspkr i2c_core ieee1394 
sg intel_agp button sr_mod evdev cdrom sd_mod thermal processor fan 
thermal_sys ahci pata_marvell libata scsi_mod dock
****************************************************
[7.2] cat /proc/cpuinfo 
processor       : 0                
vendor_id       : GenuineIntel     
cpu family      : 6                
model           : 23               
model name      : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping        : 10
cpu MHz         : 2999.630
cache size      : 6144 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc pebs bts rep_good nopl pni monitor ds_cpl vmx smx est tm2 ssse3 
cx16xtpr sse4_1 lahf_lm
bogomips        : 5999.26
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping        : 10
cpu MHz         : 2999.630
cache size      : 6144 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc pebs bts rep_good nopl pni monitor ds_cpl vmx smx est tm2 ssse3 
cx16xtpr sse4_1 lahf_lm
bogomips        : 5999.08
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:
****************************************************
[7.3]  cat /proc/modules 
nls_cp437 7168 0 - Live 0xffffffffa0a74000
vfat 10816 0 - Live 0xffffffffa0a70000    
fat 48952 1 vfat, Live 0xffffffffa0a63000 
usb_storage 99104 0 - Live 0xffffffffa0a49000
nls_utf8 2240 4 - Live 0xffffffffa008d000    
cifs 235136 4 - Live 0xffffffffa0a0e000      
nls_base 9284 5 nls_cp437,vfat,fat,nls_utf8,cifs, Live 0xffffffffa0a0a000
nvidia 8102304 36 - Live 0xffffffffa024e000 (P)
binfmt_misc 9548 1 - Live 0xffffffffa024a000
uinput 8000 2 - Live 0xffffffffa0247000
ipv6 287592 24 - Live 0xffffffffa01ff000
coretemp 6912 0 - Live 0xffffffffa01fc000
sbp2 21964 0 - Live 0xffffffffa01f5000
loop 15756 0 - Live 0xffffffffa01f0000
joydev 11008 0 - Live 0xffffffffa01ec000
usbhid 20484 0 - Live 0xffffffffa01e5000
hid 38224 1 usbhid, Live 0xffffffffa01da000
snd_hda_intel 437888 3 - Live 0xffffffffa016e000
snd_pcm_oss 36832 0 - Live 0xffffffffa0164000
snd_mixer_oss 15168 1 snd_pcm_oss, Live 0xffffffffa015f000
snd_pcm 77064 2 snd_hda_intel,snd_pcm_oss, Live 0xffffffffa014b000
snd_seq_dummy 3396 0 - Live 0xffffffffa0149000
snd_seq_oss 29248 0 - Live 0xffffffffa0140000
snd_seq_midi_event 7808 1 snd_seq_oss, Live 0xffffffffa013d000
snd_seq 50352 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 
0xffffffffa012f000
snd_timer 21968 2 snd_pcm,snd_seq, Live 0xffffffffa0128000
snd_seq_device 7764 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xffffffffa0125000
snd 60024 14 
snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_seq,snd_timer,snd_seq_device, 
Live 0xffffffffa0115000
ohci1394 28852 0 - Live 0xffffffffa010a000
i2c_i801 9820 0 - Live 0xffffffffa0106000
soundcore 8464 1 snd, Live 0xffffffffa0102000
skge 38544 0 - Live 0xffffffffa00f7000
sky2 45572 0 - Live 0xffffffffa00ea000
ehci_hcd 33612 0 - Live 0xffffffffa00e0000
snd_page_alloc 9040 2 snd_hda_intel,snd_pcm, Live 0xffffffffa00dc000
uhci_hcd 21792 0 - Live 0xffffffffa00d3000
pcspkr 3072 0 - Live 0xffffffffa00cf000
i2c_core 25056 2 nvidia,i2c_i801, Live 0xffffffffa00c7000
ieee1394 87592 2 sbp2,ohci1394, Live 0xffffffffa00b0000
sg 32336 4 - Live 0xffffffffa00a7000
intel_agp 28080 0 - Live 0xffffffffa009f000
button 7712 0 - Live 0xffffffffa009a000
sr_mod 15540 0 - Live 0xffffffffa0095000
evdev 10832 11 - Live 0xffffffffa008f000
cdrom 33768 1 sr_mod, Live 0xffffffffa0083000
sd_mod 26920 8 - Live 0xffffffffa007b000
thermal 18848 0 - Live 0xffffffffa0075000
processor 39928 1 thermal, Live 0xffffffffa006a000
fan 5512 0 - Live 0xffffffffa0067000
thermal_sys 13312 3 thermal,processor,fan, Live 0xffffffffa0062000
ahci 32012 10 - Live 0xffffffffa0059000
pata_marvell 4800 0 - Live 0xffffffffa0056000
libata 167808 2 ahci,pata_marvell, Live 0xffffffffa002c000
scsi_mod 157656 6 usb_storage,sbp2,sg,sr_mod,sd_mod,libata, Live 
0xffffffffa0004000
dock 10080 1 libata, Live 0xffffffffa0000000
****************************************************
|7.4] cat /proc/ioports 
0000-001f : dma1                   
0020-0021 : pic1                   
0040-0043 : timer0                 
0050-0053 : timer1                 
0060-0060 : keyboard               
0064-0064 : keyboard               
0080-008f : dma page reg           
00a0-00a1 : pic2                   
00c0-00df : dma2                   
00f0-00ff : fpu                    
0290-029f : pnp 00:07              
03c0-03df : vesafb                 
03f8-03ff : serial                 
0400-041f : 0000:00:1f.3           
  0400-041f : i801_smbus           
04d0-04d1 : pnp 00:08              
0500-057f : pnp 00:08
0800-087f : pnp 00:08
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-082f : ACPI GPE0_BLK
  0850-0850 : ACPI PM2_CNT_BLK
0cf8-0cff : PCI conf1
9400-941f : 0000:00:1f.2
  9400-941f : ahci
9480-9483 : 0000:00:1f.2
  9480-9483 : ahci
9800-9807 : 0000:00:1f.2
  9800-9807 : ahci
9880-9883 : 0000:00:1f.2
  9880-9883 : ahci
9c00-9c07 : 0000:00:1f.2
  9c00-9c07 : ahci
a080-a09f : 0000:00:1d.0
  a080-a09f : uhci_hcd
a400-a41f : 0000:00:1d.1
  a400-a41f : uhci_hcd
a480-a49f : 0000:00:1d.2
  a480-a49f : uhci_hcd
a800-a81f : 0000:00:1a.0
  a800-a81f : uhci_hcd
a880-a89f : 0000:00:1a.1
  a880-a89f : uhci_hcd
ac00-ac1f : 0000:00:1a.2
  ac00-ac1f : uhci_hcd
b000-bfff : PCI Bus 0000:01
  bc00-bc7f : 0000:01:00.0
c000-cfff : PCI Bus 0000:02
  c800-c8ff : 0000:02:00.0
    c800-c8ff : sky2
d000-dfff : PCI Bus 0000:03
  d400-d40f : 0000:03:00.0
    d400-d40f : pata_marvell
  d480-d483 : 0000:03:00.0
    d480-d483 : pata_marvell
  d800-d807 : 0000:03:00.0
    d800-d807 : pata_marvell
  d880-d883 : 0000:03:00.0
    d880-d883 : pata_marvell
  dc00-dc07 : 0000:03:00.0
    dc00-dc07 : pata_marvell
e000-efff : PCI Bus 0000:05
  e800-e8ff : 0000:05:02.0
    e800-e8ff : skge
****************************************************
cat /proc/iomem 
00000000-0000ffff : reserved     
00010000-0009bbff : System RAM   
0009bc00-0009ffff : reserved     
000c0000-000cffff : pnp 00:10    
000e4000-000fffff : reserved     
00100000-7ff6ffff : System RAM   
  00200000-004692ad : Kernel code
  004692ae-005812f7 : Kernel data
  0060f000-006a6397 : Kernel bss
7ff70000-7ff7dfff : ACPI Tables
7ff7e000-7ffcffff : ACPI Non-volatile Storage
7ffd0000-7fffffff : reserved
88000000-880fffff : PCI Bus 0000:05
  88000000-8801ffff : 0000:05:02.0
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : pnp 00:0f
f8f00000-f8ffffff : PCI Bus 0000:04
f9ff8000-f9ffbfff : 0000:00:1b.0
  f9ff8000-f9ffbfff : ICH HD audio
f9ffe800-f9ffefff : 0000:00:1f.2
  f9ffe800-f9ffefff : ahci
f9fff400-f9fff4ff : 0000:00:1f.3
f9fff800-f9fffbff : 0000:00:1d.7
  f9fff800-f9fffbff : ehci_hcd
f9fffc00-f9ffffff : 0000:00:1a.7
  f9fffc00-f9ffffff : ehci_hcd
fa000000-fe8fffff : PCI Bus 0000:01
  fa000000-fbffffff : 0000:01:00.0
    fb000000-fbdfffff : vesafb
  fd000000-fdffffff : 0000:01:00.0
    fd000000-fdffffff : nvidia
  fe880000-fe8fffff : 0000:01:00.0
fe900000-fe9fffff : PCI Bus 0000:02
  fe9c0000-fe9dffff : 0000:02:00.0
  fe9fc000-fe9fffff : 0000:02:00.0
    fe9fc000-fe9fffff : sky2
fea00000-feafffff : PCI Bus 0000:03
  feaffc00-feafffff : 0000:03:00.0
feb00000-febfffff : PCI Bus 0000:05
  febfb000-febfbfff : 0000:05:03.0
    febfb000-febfb7ff : ohci1394
  febfc000-febfffff : 0000:05:02.0
    febfc000-febfffff : skge
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:0d
fed00000-fed003ff : HPET 0
fed08000-fed08fff : pnp 00:08
fed14000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:08
fed20000-fed3ffff : pnp 00:08
fed50000-fed8ffff : pnp 00:08
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffc00000-ffdfffff : pnp 00:0b
ffe00000-ffffffff : reserved
****************************************************
[7.5]  root # lspci -vvv                                                                               
/home/phiphi/kernel
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (rev 
02)                                    
        Subsystem: ASUSTeK Computer Inc. Device 82d3                                                                
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-       
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-        
        Latency: 0                                                                                                  
        Capabilities: [e0] Vendor Specific Information <?>                                                          
        Kernel modules: intel-agp                                                                                   

00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express Root Port 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+     
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-      
        Latency: 0, Cache Line Size: 32 bytes                                                                     
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0                                              
        I/O behind bridge: 0000b000-0000bfff                                                                      
        Memory behind bridge: fa000000-fe8fffff                                                                   
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff                                      
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-            
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-                                             
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-                                               
        Capabilities: [88] Subsystem: ASUSTeK Computer Inc. Device 82d3                                           
        Capabilities: [80] Power Management version 3                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                        
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                       
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+                           
                Address: fee0300c  Data: 4159                                                                     
        Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00                                                 
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us                             
                        ExtTag- RBE+ FLReset-                                                                     
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+                                
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-                                              
                        MaxPayload 128 bytes, MaxReadReq 128 bytes                                                
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-                               
                LnkCap: Port #2, Speed 5GT/s, Width x16, ASPM L0s, Latency L0 
<256ns, L1 <4us                     
                        ClockPM- Suprise- LLActRep- BwNot+                                                        
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+                                   
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                            
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt-                 
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surpise-                                 
                        Slot #  0, PowerLimit 75.000000; Interlock- NoCompl-                                      
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-                           
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                               
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-                              
                        Changed: MRL- PresDet+ LinkState-                                                         
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-                           
                RootCap: CRSVisible-                                                                              
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-                                                   
        Capabilities: [100] Virtual Channel <?>                                                                   
        Capabilities: [140] Root Complex Link <?>                                                                 
        Kernel driver in use: pcieport-driver                                                                     

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI 
Controller #4 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                       
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin A routed to IRQ 16                                                                     
        Region 4: I/O ports at a800 [size=32]                                                                 
        Capabilities: [50] Vendor Specific Information <?>                                                    
        Kernel driver in use: uhci_hcd                                                                        
        Kernel modules: uhci-hcd                                                                              

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI 
Controller #5 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                       
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin B routed to IRQ 21                                                                     
        Region 4: I/O ports at a880 [size=32]                                                                 
        Capabilities: [50] Vendor Specific Information <?>                                                    
        Kernel driver in use: uhci_hcd                                                                        
        Kernel modules: uhci-hcd                                                                              

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI 
Controller #6 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                       
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin C routed to IRQ 18                                                                     
        Region 4: I/O ports at ac00 [size=32]                                                                 
        Capabilities: [50] Vendor Specific Information <?>                                                    
        Kernel driver in use: uhci_hcd                                                                        
        Kernel modules: uhci-hcd                                                                              

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI 
Controller #2 (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                        
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin C routed to IRQ 18                                                                     
        Region 0: Memory at f9fffc00 (32-bit, non-prefetchable) [size=1K]                                     
        Capabilities: [50] Power Management version 2                                                         
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                  
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                   
        Capabilities: [58] Debug port: BAR=1 offset=00a0                                                      
        Capabilities: [98] Vendor Specific Information <?>                                                    
        Kernel driver in use: ehci_hcd                                                                        
        Kernel modules: ehci-hcd                                                                              

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio 
Controller
        Subsystem: ASUSTeK Computer Inc. Device 8311                              
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 32 bytes                                                                
        Interrupt: pin A routed to IRQ 22                                                                    
        Region 0: Memory at f9ff8000 (64-bit, non-prefetchable) [size=16K]                                   
        Capabilities: [50] Power Management version 2                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                  
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                  
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-                      
                Address: 0000000000000000  Data: 0000                                                        
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 
00                             
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us                        
                        ExtTag- RBE- FLReset+                                                                
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                           
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+                                         
                        MaxPayload 128 bytes, MaxReadReq 128 bytes                                           
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                          
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us            
                        ClockPM- Suprise- LLActRep- BwNot-                                                   
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-                                           
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                       
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-           
        Capabilities: [100] Virtual Channel <?>                                                              
        Capabilities: [130] Root Complex Link <?>                                                            
        Kernel driver in use: HDA Intel                                                                      
        Kernel modules: snd-hda-intel                                                                        

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 
1 (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 32 bytes                                                                
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0                                         
        I/O behind bridge: 0000f000-00000fff                                                                 
        Memory behind bridge: fff00000-000fffff                                                              
        Prefetchable memory behind bridge: 00000000f8f00000-00000000f8ffffff                                 
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-       
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-                                        
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-                                          
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00                                            
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us                        
                        ExtTag- RBE+ FLReset-                                                                
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+                           
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-                                         
                        MaxPayload 128 bytes, MaxReadReq 128 bytes                                           
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                          
                LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency 
L0 <256ns, L1 <4us            
                        ClockPM- Suprise- LLActRep+ BwNot-                                                   
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+                              
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                       
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-           
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                            
                        Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-                                 
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-                      
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                          
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-                         
                        Changed: MRL- PresDet- LinkState-                                                    
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-                      
                RootCap: CRSVisible-                                                                         
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-                                              
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+                      
                Address: fee0300c  Data: 4161                                                                
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 82d4                                      
        Capabilities: [a0] Power Management version 2                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                   
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                  
        Capabilities: [100] Virtual Channel <?>                                                              
        Capabilities: [180] Root Complex Link <?>                                                            
        Kernel driver in use: pcieport-driver                                                                

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 
5 (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 32 bytes                                                                
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0                                         
        I/O behind bridge: 0000d000-0000dfff                                                                 
        Memory behind bridge: fea00000-feafffff                                                              
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff                                 
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-       
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-                                        
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-                                          
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00                                            
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us                        
                        ExtTag- RBE+ FLReset-                                                                
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+                           
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-                                         
                        MaxPayload 128 bytes, MaxReadReq 128 bytes                                           
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                          
                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <256ns, L1 <4us            
                        ClockPM- Suprise- LLActRep+ BwNot-                                                   
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+                              
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                       
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-           
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                            
                        Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-                                 
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-                      
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                          
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-                         
                        Changed: MRL- PresDet+ LinkState+                                                    
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-                      
                RootCap: CRSVisible-                                                                         
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-                                              
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+                      
                Address: fee0300c  Data: 4169                                                                
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 82d4                                      
        Capabilities: [a0] Power Management version 2                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                   
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                  
        Capabilities: [100] Virtual Channel <?>                                                              
        Capabilities: [180] Root Complex Link <?>                                                            
        Kernel driver in use: pcieport-driver                                                                

00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 
6 (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 32 bytes                                                                
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0                                         
        I/O behind bridge: 0000c000-0000cfff                                                                 
        Memory behind bridge: fe900000-fe9fffff                                                              
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff                                 
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-       
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-                                        
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-                                          
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00                                            
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us                        
                        ExtTag- RBE+ FLReset-                                                                
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+                           
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-                                         
                        MaxPayload 128 bytes, MaxReadReq 128 bytes                                           
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                          
                LnkCap: Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <256ns, L1 <4us            
                        ClockPM- Suprise- LLActRep+ BwNot-                                                   
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+                              
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                       
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-           
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                            
                        Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-                                 
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-                      
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                          
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-                         
                        Changed: MRL- PresDet+ LinkState+                                                    
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-                      
                RootCap: CRSVisible-                                                                         
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-                                              
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+                      
                Address: fee0300c  Data: 4171                                                                
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 82d4                                      
        Capabilities: [a0] Power Management version 2                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                   
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                  
        Capabilities: [100] Virtual Channel <?>                                                              
        Capabilities: [180] Root Complex Link <?>                                                            
        Kernel driver in use: pcieport-driver                                                                

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI 
Controller #1 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                       
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin A routed to IRQ 23                                                                     
        Region 4: I/O ports at a080 [size=32]                                                                 
        Capabilities: [50] Vendor Specific Information <?>                                                    
        Kernel driver in use: uhci_hcd                                                                        
        Kernel modules: uhci-hcd                                                                              

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI 
Controller #2 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                       
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin B routed to IRQ 19                                                                     
        Region 4: I/O ports at a400 [size=32]                                                                 
        Capabilities: [50] Vendor Specific Information <?>                                                    
        Kernel driver in use: uhci_hcd                                                                        
        Kernel modules: uhci-hcd                                                                              

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI 
Controller #3 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                       
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin C routed to IRQ 18                                                                     
        Region 4: I/O ports at a480 [size=32]                                                                 
        Capabilities: [50] Vendor Specific Information <?>                                                    
        Kernel driver in use: uhci_hcd                                                                        
        Kernel modules: uhci-hcd                                                                              

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI 
Controller #1 (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                        
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin A routed to IRQ 23                                                                     
        Region 0: Memory at f9fff800 (32-bit, non-prefetchable) [size=1K]                                     
        Capabilities: [50] Power Management version 2                                                         
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                  
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                   
        Capabilities: [58] Debug port: BAR=1 offset=00a0                                                      
        Capabilities: [98] Vendor Specific Information <?>                                                    
        Kernel driver in use: ehci_hcd                                                                        
        Kernel modules: ehci-hcd                                                                              

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01 
[Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0                                                                                           
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32                                        
        I/O behind bridge: 0000e000-0000efff                                                                 
        Memory behind bridge: feb00000-febfffff                                                              
        Prefetchable memory behind bridge: 0000000088000000-00000000880fffff                                 
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-     
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-                                        
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-                                          
        Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 82d4                                      

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface 
Controller
        Subsystem: ASUSTeK Computer Inc. Device 82d4                            
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Capabilities: [e0] Vendor Specific Information <?>                                                    

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI 
Controller (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 82d4                                                          
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+ 
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0                                                                                            
        Interrupt: pin B routed to IRQ 379                                                                    
        Region 0: I/O ports at 9c00 [size=8]                                                                  
        Region 1: I/O ports at 9880 [size=4]                                                                  
        Region 2: I/O ports at 9800 [size=8]                                                                  
        Region 3: I/O ports at 9480 [size=4]                                                                  
        Region 4: I/O ports at 9400 [size=32]                                                                 
        Region 5: Memory at f9ffe800 (32-bit, non-prefetchable) [size=2K]                                     
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/4 Enable+                       
                Address: fee0300c  Data: 4181                                                                 
        Capabilities: [70] Power Management version 3                                                         
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)                    
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                   
        Capabilities: [a8] SATA HBA <?>                                                                       
        Capabilities: [b0] Vendor Specific Information <?>                                                    
        Kernel driver in use: ahci                                                                            
        Kernel modules: ahci                                                                                  

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
        Subsystem: ASUSTeK Computer Inc. Device 82d4                    
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 18                                                                     
        Region 0: Memory at f9fff400 (64-bit, non-prefetchable) [size=256]                                    
        Region 4: I/O ports at 0400 [size=32]                                                                 
        Kernel driver in use: i801_smbus                                                                      
        Kernel modules: i2c-i801                                                                              

01:00.0 VGA compatible controller: nVidia Corporation G94 [GeForce 9600 GT] 
(rev a1) (prog-if 00 [VGA controller])
        Subsystem: Giga-byte Technology GV-NX96T512HP                                                             
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-     
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-      
        Latency: 0                                                                                                
        Interrupt: pin A routed to IRQ 16                                                                         
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]                                        
        Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]                                           
        Region 3: Memory at fa000000 (64-bit, non-prefetchable) [size=32M]                                        
        Region 5: I/O ports at bc00 [size=128]                                                                    
        [virtual] Expansion ROM at fe880000 [disabled] [size=512K]                                                
        Capabilities: [60] Power Management version 3                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)                        
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                       
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-                           
                Address: 0000000000000000  Data: 0000                                                             
        Capabilities: [78] Express (v2) Endpoint, MSI 00                                                          
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, 
L1 <4us                            
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-                                           
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+                                              
                        MaxPayload 128 bytes, MaxReadReq 512 bytes                                                
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-                               
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency 
L0 <256ns, L1 <1us                  
                        ClockPM- Suprise- LLActRep- BwNot-                                                        
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- 
CommClk+                                  
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                            
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-                 
        Capabilities: [b4] Vendor Specific Information <?>                                                        
        Capabilities: [100] Virtual Channel <?>                                                                   
        Capabilities: [128] Power Budgeting <?>                                                                   
        Capabilities: [600] Vendor Specific Information <?>                                                       
        Kernel driver in use: nvidia                                                                              
        Kernel modules: nvidia, nvidiafb                                                                          

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E 
Gigabit Ethernet Controller (rev 12)
        Subsystem: ASUSTeK Computer Inc. Device 81f8                                                         
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 32 bytes                                                                
        Interrupt: pin A routed to IRQ 378                                                                   
        Region 0: Memory at fe9fc000 (64-bit, non-prefetchable) [size=16K]                                   
        Region 2: I/O ports at c800 [size=256]                                                               
        Expansion ROM at fe9c0000 [disabled] [size=128K]                                                     
        Capabilities: [48] Power Management version 3                                                        
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)                   
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-                                                  
        Capabilities: [50] Vital Product Data <?>                                                            
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable+                      
                Address: 00000000fee0300c  Data: 4199                                                        
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00                                              
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited               
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-                                      
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                           
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-                                         
                        MaxPayload 128 bytes, MaxReadReq 512 bytes                                           
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-                          
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <256ns, L1 unlimited       
                        ClockPM+ Suprise- LLActRep- BwNot-                                                   
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- 
CommClk-                             
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                       
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-           
        Capabilities: [100] Advanced Error Reporting <?>                                                     
        Kernel driver in use: sky2                                                                           
        Kernel modules: sky2                                                                                 

03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II 
Controller (rev b1) (prog-if 8f [Master SecP SecO PriP PriO])                                                                                                       
        Subsystem: ASUSTeK Computer Inc. Device 8212                                                                 
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-        
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-         
        Latency: 0, Cache Line Size: 32 bytes                                                                        
        Interrupt: pin A routed to IRQ 16                                                                            
        Region 0: I/O ports at dc00 [size=8]                                                                         
        Region 1: I/O ports at d880 [size=4]                                                                         
        Region 2: I/O ports at d800 [size=8]                                                                         
        Region 3: I/O ports at d480 [size=4]                                                                         
        Region 4: I/O ports at d400 [size=16]                                                                        
        Region 5: Memory at feaffc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 
<256ns, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: pata_marvell
        Kernel modules: pata_marvell, ahci

05:02.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit 
Ethernet Controller (rev 14)
        Subsystem: ASUSTeK Computer Inc. Marvell 88E8001 Gigabit Ethernet 
Controller (Asus)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (5750ns min, 7750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at febfc000 (32-bit, non-prefetchable) [size=16K]
        Region 1: I/O ports at e800 [size=256]
        Expansion ROM at 88000000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data <?>
        Kernel driver in use: skge
        Kernel modules: skge

05:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 8294
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (3000ns min, 6000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at febfb000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Kernel driver in use: ohci1394
        Kernel modules: ohci1394
****************************************************
[7.6]  phiphi > cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: PIONEER  Model: DVD-RW  DVR-107D Rev: 1.10
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250620AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250823AS      Rev: 3.03
  Type:   Direct-Access                    ANSI  SCSI revision: 05
****************************************************
[7.7] 

Hope this can help, since I'm no developper, I'm only basic user who only 
understands how to compile kernel from kernel.org ;-)

I'm not in the list, maybe you'll need to CC me if any more info is needed... 
I can also try to test some things if needed. 

Philippe
