Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbZACSku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbZACSku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbZACSkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:40:40 -0500
Received: from webmail.oviknet.se ([85.11.197.11]:4441 "EHLO
	webmail.oviknet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbZACSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:40:37 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jan 2009 13:40:36 EST
Message-ID: <495FAF88.30506@oviknet.com>
Date: Sat, 03 Jan 2009 19:33:44 +0100
From: Matti L <mattil@oviknet.com>
Reply-To: mattil@oviknet.com
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Kernel 2.6.28 -- BUG: soft lockup - CPU#0 stuck for 61s! [Xorg:8528]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

1. I could not decide which part of my home brewed kernel 2.6.28 screwed 
up, but it caused a complete lockup.
    I had to use the power button to restart (desktop computer).

2. Crash when surfing with Firefox v3.0.5 (probably not repeatable)

3. Kernel 2.6.28, BUG: soft lockup - CPU#0 stuck for 61s! [Xorg:8528]

4. Linux version 2.6.28-20081225 (root@galadriel) (gcc version 4.3.2 
(Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Thu Dec 25 16:19:53 CET 2008

.5 Hmm.

.6 Don't know how to trigger this BUG

7.1 ./scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux galadriel 2.6.28-20081225 #1 SMP Thu Dec 25 16:19:53 CET 2008 i686 
GNU/Linux

Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.93.20081009
util-linux             2.14
mount                  support
module-init-tools      3.3-pre11
e2fsprogs              1.41.3
reiserfsprogs          3.6.19
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.8.90
Dynamic linker (ldd)   2.8.90
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.14.1
Sh-utils               6.10
udev                   124
wireless-tools         29
Modules Loaded         ipv6 af_packet binfmt_misc bridge stp bnep sco 
rfcomm l2cap bluetooth ppdev speedstep_lib cpufreq_powersave 
cpufreq_ondemand cpufreq_stats freq_table cpufreq_conservative 
cpufreq_userspace pci_slot wmi container video output sbs rfkill 
input_polldev sbshc battery iptable_filter ip_tables x_tables 
nls_iso8859_1 nls_cp437 vfat fat ext2 ac sbp2 lp snd_emu10k1_synth 
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss saa7134_alsa serio_raw 
pcspkr snd_pcm tuner_simple tuner_types snd_page_alloc snd_util_mem 
snd_hwdep tea5767 tda9887 snd_seq_dummy evdev tda8290 snd_seq_oss 
snd_seq_midi tuner snd_rawmidi snd_seq_midi_event snd_seq saa7134 
snd_timer snd_seq_device snd ir_common videodev v4l1_compat 
compat_ioctl32 v4l2_common videobuf_dma_sg videobuf_core tveeprom 
parport_pc parport soundcore nvidia i2c_core button iTCO_wdt 
iTCO_vendor_support shpchp pci_hotplug intel_agp agpgart ext3 jbd 
usb_storage libusual sd_mod crc_t10dif usbhid hid sr_mod cdrom sg 
pata_acpi ata_generic ata_piix ohci1394 libata 8139cp ieee1394 8139too 
mii scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse


7.2 Processor information
/proc/cpuinfo                                                                                                    

processor       : 
0                                                                                                                                  

vendor_id       : 
GenuineIntel                                                                                                                       

cpu family      : 
15                                                                                                                                 

model           : 
2                                                                                                                                  

model name      : Intel(R) Pentium(R) 4 CPU 
3.20GHz                                                                                                  

stepping        : 
9                                                                                                                                  

cpu MHz         : 
3199.969                                                                                                                           

cache size      : 512 
KB                                                                                                                             

physical id     : 
0                                                                                                                                  

siblings        : 
2                                                                                                                                  

core id         : 
0                                                                                                                                  

cpu cores       : 
1                                                                                                                                  

apicid          : 
0                                                                                                                                  

initial apicid  : 
0                                                                                                                                  

fdiv_bug        : 
no                                                                                                                                 

hlt_bug         : 
no                                                                                                                                 

f00f_bug        : 
no                                                                                                                                 

coma_bug        : 
no                                                                                                                                 

fpu             : 
yes                                                                                                                                

fpu_exception   : 
yes                                                                                                                                

cpuid level     : 
2                                                                                                                                  

wp              : 
yes                                                                                                                                

flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs 
bts cid xtpr
bogomips        : 6399.93
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping        : 9
cpu MHz         : 3199.969
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs 
bts cid xtpr
bogomips        : 6400.63
clflush size    : 64
power management:


7.3 Module information
/proc/modules
ipv6 258420 10 - Live 0xf800f000                
af_packet 25344 2 - Live 0xf7f50000             
binfmt_misc 16776 1 - Live 0xf7f3e000           
bridge 56212 0 - Live 0xf7f26000                
stp 10756 1 bridge, Live 0xf7ecc000             
bnep 20352 2 - Live 0xf7f1f000                  
sco 18180 2 - Live 0xf7f18000                   
rfcomm 43280 0 - Live 0xf7ebf000                
l2cap 29952 6 bnep,rfcomm, Live 0xf7eb5000      
bluetooth 61412 6 bnep,sco,rfcomm,l2cap, Live 0xf7ea4000
ppdev 15620 0 - Live 0xf7f38000                        
speedstep_lib 12932 0 - Live 0xf7d5b000                
cpufreq_powersave 9856 0 - Live 0xf80c2000             
cpufreq_ondemand 15372 0 - Live 0xf820d000             
cpufreq_stats 13316 0 - Live 0xf80bc000                
freq_table 12800 2 cpufreq_ondemand,cpufreq_stats, Live 0xf80b6000
cpufreq_conservative 14472 0 - Live 0xf80b0000                   
cpufreq_userspace 11396 0 - Live 0xf8006000                      
pci_slot 12680 0 - Live 0xf8054000                               
wmi 14760 0 - Live 0xf7fd7000                                    
container 11648 0 - Live 0xf7ed7000                              
video 24976 0 - Live 0xf7f5d000                                  
output 11136 1 video, Live 0xf7dba000                            
sbs 19464 0 - Live 0xf7ed0000                                    
rfkill 19020 0 - Live 0xf7d54000                                 
input_polldev 12040 0 - Live 0xf7cb0000                          
sbshc 13440 1 sbs, Live 0xf7d4e000                               
battery 18436 0 - Live 0xf7d47000                                
iptable_filter 11008 0 - Live 0xf9941000                         
ip_tables 19472 1 iptable_filter, Live 0xf990a000                
x_tables 23044 1 ip_tables, Live 0xf98c5000                      
nls_iso8859_1 12160 1 - Live 0xf9889000                          
nls_cp437 13824 1 - Live 0xf986c000                              
vfat 18816 1 - Live 0xf8f60000                                   
fat 58400 1 vfat, Live 0xf8f1f000                                
ext2 71816 2 - Live 0xf8f08000                                   
ac 12420 0 - Live 0xf8eff000                                     
sbp2 30092 0 - Live 0xf8cc2000                                   
lp 17156 0 - Live 0xf8c76000                                     
snd_emu10k1_synth 14592 0 - Live 0xf8c44000                      
snd_emux_synth 40704 1 snd_emu10k1_synth, Live 0xf8bcc000        
snd_seq_virmidi 13568 1 snd_emux_synth, Live 0xf8af6000          
snd_seq_midi_emul 14592 1 snd_emux_synth, Live 0xf8709000        
snd_emu10k1 145440 2 snd_emu10k1_synth, Live 0xf8648000          
snd_ac97_codec 112164 1 snd_emu10k1, Live 0xf8600000             
ac97_bus 9984 1 snd_ac97_codec, Live 0xf83ea000                  
snd_pcm_oss 46208 0 - Live 0xf8310000                            
snd_mixer_oss 22656 1 snd_pcm_oss, Live 0xf82d7000               
saa7134_alsa 20000 1 - Live 0xf80e3000                           
serio_raw 13572 0 - Live 0xf80dd000                              
pcspkr 10752 0 - Live 0xf7f68000                                 
snd_pcm 82692 4 snd_emu10k1,snd_ac97_codec,snd_pcm_oss,saa7134_alsa, 
Live 0xf80c6000
tuner_simple 22416 1 - Live 
0xf7fe6000                                             
tuner_types 22528 1 tuner_simple, Live 
0xf7fde000                                  
snd_page_alloc 17160 2 snd_emu10k1,snd_pcm, Live 
0xf7eea000                        
snd_util_mem 12544 2 snd_emux_synth,snd_emu10k1, Live 
0xf7ee4000                   
snd_hwdep 15364 2 snd_emux_synth,snd_emu10k1, Live 
0xf7ede000                      
tea5767 15108 0 - Live 
0xf7e5f000                                                  
tda9887 18692 1 - Live 
0xf7e58000                                                  
snd_seq_dummy 11012 0 - Live 
0xf7e50000                                            
evdev 17696 10 - Live 
0xf7def000                                                   
tda8290 20740 0 - Live 
0xf7de7000                                                  
snd_seq_oss 38016 0 - Live 
0xf7dd8000                                              
snd_seq_midi 14464 0 - Live 
0xf7d70000                                             
tuner 32964 0 - Live 
0xf7dcd000                                                    
snd_rawmidi 29696 3 snd_seq_virmidi,snd_emu10k1,snd_seq_midi, Live 
0xf7d66000      
snd_seq_midi_event 15360 3 snd_seq_virmidi,snd_seq_oss,snd_seq_midi, 
Live 0xf7d3c000
snd_seq 57008 9 
snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, 
Live 0xf7d2c000
saa7134 152404 1 saa7134_alsa, Live 
0xf82e8000                                                                                             

snd_timer 29320 3 snd_emu10k1,snd_pcm,snd_seq, Live 
0xf80f1000                                                                             

snd_seq_device 15244 8 
snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, 
Live 0xf80eb000
snd 62500 18 
snd_emux_synth,snd_seq_virmidi,snd_emu10k1,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,saa7134_alsa,snd_pcm,snd_hwdep,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, 
Live 
0xf805a000                                                                                                 

ir_common 52356 1 saa7134, Live 
0xf7ff7000                                                                                                           

videodev 41728 2 tuner,saa7134, Live 
0xf7f74000                                                                                                      

v4l1_compat 21892 1 videodev, Live 
0xf7f6c000                                                                                                        

compat_ioctl32 9472 1 saa7134, Live 
0xf7f0c000                                                                                                       

v4l2_common 21120 2 tuner,saa7134, Live 
0xf7f04000                                                                                                   

videobuf_dma_sg 20612 2 saa7134_alsa,saa7134, Live 
0xf7efc000                                                                                        

videobuf_core 26372 2 saa7134,videobuf_dma_sg, Live 
0xf7ef3000                                                                                       

tveeprom 20356 1 saa7134, Live 
0xf7e8f000                                                                                                            

parport_pc 40100 1 - Live 
0xf7e80000                                                                                                                 

parport 42476 3 ppdev,lp,parport_pc, Live 
0xf7e70000                                                                                                 

soundcore 15456 1 snd, Live 
0xf7e67000                                                                                                               

nvidia 7103560 34 - Live 0xf8f6b000 
(P)                                                                                                              

i2c_core 32020 9 
tuner_simple,tea5767,tda9887,tda8290,tuner,saa7134,v4l2_common,tveeprom,nvidia, 
Live 0xf7df5000                                    
button 14352 0 - Live 
0xf7d7c000                                                                                                                     

iTCO_wdt 19236 0 - Live 
0xf7d75000                                                                                                                   

iTCO_vendor_support 11780 1 iTCO_wdt, Live 0xf7d42000
shpchp 40340 0 - Live 0xf7d20000
pci_hotplug 34720 1 shpchp, Live 0xf7d15000
intel_agp 34108 1 - Live 0xf8710000
agpgart 42440 2 nvidia,intel_agp, Live 0xf86c6000
ext3 133128 2 - Live 0xf8625000
jbd 55188 1 ext3, Live 0xf83fb000
usb_storage 81984 0 - Live 0xf8320000
libusual 30484 1 usb_storage, Live 0xf80ff000
sd_mod 41880 10 - Live 0xf806d000
crc_t10dif 10112 1 sd_mod, Live 0xf800a000
usbhid 31968 0 - Live 0xf7fed000
hid 49152 1 usbhid, Live 0xf7f81000
sr_mod 22212 0 - Live 0xf7f10000
cdrom 42784 1 sr_mod, Live 0xf7e97000
sg 36404 0 - Live 0xf7daf000
pata_acpi 12416 0 - Live 0xf7d02000
ata_generic 13060 0 - Live 0xf7cfc000
ata_piix 29700 7 - Live 0xf7c8a000
ohci1394 38448 0 - Live 0xf7cf0000
libata 179872 3 pata_acpi,ata_generic,ata_piix, Live 0xf7d81000
8139cp 27904 0 - Live 0xf7ce7000
ieee1394 93764 2 sbp2,ohci1394, Live 0xf7cb7000
8139too 31488 0 - Live 0xf7c80000
mii 13568 2 8139cp,8139too, Live 0xf7c7a000
scsi_mod 158996 6 sbp2,usb_storage,sd_mod,sr_mod,sg,libata, Live 0xf7c4e000
ehci_hcd 43276 0 - Live 0xf7ca3000
uhci_hcd 30864 0 - Live 0xf7c96000
usbcore 152336 6 usb_storage,libusual,usbhid,ehci_hcd,uhci_hcd, Live 
0xf7c26000
thermal 23580 0 - Live 0xf7e02000
processor 48812 1 thermal, Live 0xf7dbf000
fan 12676 0 - Live 0xf7d0f000
fuse 59548 3 - Live 0xf7cd6000

7.4 Loaded drivers and hardware
/proc/ioports
0000-001f : dma1                                
0020-0021 : pic1                                
0040-0043 : timer0                              
0050-0053 : timer1                              
0060-0060 : keyboard                            
0064-0064 : keyboard                            
0070-0071 : rtc0                                
0080-008f : dma page reg                        
00a0-00a1 : pic2                                
00c0-00df : dma2                                
00f0-00ff : fpu                                 
0170-0177 : 0000:00:1f.1                        
  0170-0177 : ata_piix                          
01f0-01f7 : 0000:00:1f.1                        
  01f0-01f7 : ata_piix                          
0376-0376 : 0000:00:1f.1                        
  0376-0376 : ata_piix                          
0378-037a : parport0                            
037b-037f : parport0                            
03c0-03df : vga+                                
03f6-03f6 : 0000:00:1f.1                        
  03f6-03f6 : ata_piix                          
03f8-03ff : serial                              
0400-041f : 0000:00:1f.3                        
  0400-041f : pnp 00:08                         
0480-04bf : 0000:00:1f.0                        
  0480-04bf : pnp 00:08                         
04d0-04d1 : pnp 00:08                           
0680-06ff : pnp 00:07                           
0800-087f : 0000:00:1f.0
  0800-087f : pnp 00:08
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0828-082f : ACPI GPE0_BLK
0cf8-0cff : PCI conf1
b000-bfff : PCI Bus 0000:02
  b400-b4ff : 0000:02:0f.0
    b400-b4ff : 8139too
  b800-b83f : 0000:02:0b.0
    b800-b83f : EMU10K1
  bc00-bc07 : 0000:02:03.0
cc00-cc0f : 0000:00:1f.2
  cc00-cc0f : ata_piix
d000-d003 : 0000:00:1f.2
  d000-d003 : ata_piix
d400-d407 : 0000:00:1f.2
  d400-d407 : ata_piix
d800-d803 : 0000:00:1f.2
  d800-d803 : ata_piix
dc00-dc07 : 0000:00:1f.2
  dc00-dc07 : ata_piix
e000-e01f : 0000:00:1d.0
  e000-e01f : uhci_hcd
e400-e41f : 0000:00:1d.1
  e400-e41f : uhci_hcd
e800-e81f : 0000:00:1d.2
  e800-e81f : uhci_hcd
ec00-ec1f : 0000:00:1d.3
  ec00-ec1f : uhci_hcd
fc00-fc0f : 0000:00:1f.1
  fc00-fc0f : ata_piix

/proc/iomem
00000000-0000ffff : reserved                  
00010000-0009fbff : System RAM                
0009fc00-0009ffff : reserved                  
000a0000-000bffff : Video RAM area            
000c0000-000cf3ff : Video ROM                 
000e8000-000fffff : reserved                  
  000f0000-000fffff : System ROM              
00100000-7ffbffff : System RAM
  00100000-003aefc0 : Kernel code
  003aefc1-0054279b : Kernel data
  005bd000-00679adf : Kernel bss
7ffc0000-7ffcefff : ACPI Tables
7ffcf000-7ffeffff : ACPI Non-volatile Storage
7fff0000-7fffffff : reserved
88000000-880003ff : 0000:00:1f.1
d7f00000-f7efffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:01:00.0
f8000000-fbffffff : 0000:00:00.0
fc900000-fe9fffff : PCI Bus 0000:01
  fd000000-fdffffff : 0000:01:00.0
    fd000000-fdffffff : nvidia
  fe9e0000-fe9fffff : 0000:01:00.0
fea00000-feafffff : PCI Bus 0000:02
  feae8000-feaebfff : 0000:02:0e.0
  feaef000-feaef7ff : 0000:02:0e.0
    feaef000-feaef7ff : ohci1394
  feaef800-feaef8ff : 0000:02:0f.0
    feaef800-feaef8ff : 8139too
  feaefc00-feaeffff : 0000:02:0a.0
    feaefc00-feaeffff : saa7134[0]
  feaf0000-feafffff : 0000:02:03.0
febffc00-febfffff : 0000:00:1d.7
  febffc00-febfffff : ehci_hcd
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:09
fed20000-fed8ffff : pnp 00:08
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:09
ffb80000-ffffffff : reserved
  fff80000-ffffffff : pnp 00:08

7.5 PCI information
sudo lspci -vvv
[sudo] password for xxxxx:                    
00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM 
Controller/Host-Hub Interface (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 
80a5                                         
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 
0                                                                                           

        Region 0: Memory at f8000000 (32-bit, prefetchable) 
[size=64M]                                      
        Capabilities: [e4] Vendor Specific Information 
<?>                                                  
        Capabilities: [a0] AGP version 
3.0                                                                  
                Status: RQ=32 Iso- ArqSz=2 Cal=2 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3+ Rate=x4,x8   
                Command: RQ=1 ArqSz=0 Cal=2 SBA+ AGP+ GART64- 64bit- FW- 
Rate=x8                            
        Kernel driver in use: 
agpgart-intel                                                                  

        Kernel modules: 
intel-agp                                                                            


00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller 
(rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
64                                                                                          

        Bus: primary=00, secondary=01, subordinate=01, 
sec-latency=64                                       
        I/O behind bridge: 
0000f000-00000fff                                                                 

        Memory behind bridge: 
fc900000-fe9fffff                                                              

        Prefetchable memory behind bridge: 
d7f00000-f7efffff                                                
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-    
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- 
FastB2B-                                       
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                         
        Kernel modules: 
shpchp                                                                               


00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #1 (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                                            
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Interrupt: pin A routed to IRQ 
16                                                                    
        Region 4: I/O ports at e000 
[size=32]                                                                
        Kernel driver in use: 
uhci_hcd                                                                        

        Kernel modules: 
uhci-hcd                                                                              


00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #2 (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                                            
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Interrupt: pin B routed to IRQ 
19                                                                    
        Region 4: I/O ports at e400 
[size=32]                                                                
        Kernel driver in use: 
uhci_hcd                                                                        

        Kernel modules: 
uhci-hcd                                                                              


00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #3 (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                                            
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Interrupt: pin C routed to IRQ 
18                                                                    
        Region 4: I/O ports at e800 
[size=32]                                                                
        Kernel driver in use: 
uhci_hcd                                                                        

        Kernel modules: 
uhci-hcd                                                                              


00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #4 (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                                            
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Interrupt: pin A routed to IRQ 
16                                                                    
        Region 4: I/O ports at ec00 
[size=32]                                                                
        Kernel driver in use: 
uhci_hcd                                                                        

        Kernel modules: 
uhci-hcd                                                                              


00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 
EHCI Controller (rev 02) (prog-if 20)
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                                                       
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Interrupt: pin D routed to IRQ 
23                                                                    
        Region 0: Memory at febffc00 (32-bit, non-prefetchable) 
[size=1K]                                    
        Capabilities: [50] Power Management version 
2                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                 
                Status: D0 PME-Enable- DSel=0 DScale=0 
PME-                                                  
        Capabilities: [58] Debug port: BAR=1 
offset=00a0                                                     
        Kernel driver in use: 
ehci_hcd                                                                        

        Kernel modules: 
ehci-hcd                                                                              


00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                           

        Bus: primary=00, secondary=02, subordinate=02, 
sec-latency=64                                       
        I/O behind bridge: 
0000b000-0000bfff                                                                 

        Memory behind bridge: 
fea00000-feafffff                                                              

        Prefetchable memory behind bridge: 
fff00000-000fffff                                                
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-    
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- 
FastB2B-                                       
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                         
        Kernel modules: 
shpchp                                                                               


00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC 
Interface Bridge (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Kernel modules: iTCO_wdt, 
intel-rng                                                                  

00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                                                                   
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-          
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-         
        Latency: 
0                                                                                                      

        Interrupt: pin A routed to IRQ 
18                                                                               

        Region 0: I/O ports at 01f0 
[size=8]                                                                            

        Region 1: I/O ports at 03f4 
[size=1]                                                                            

        Region 2: I/O ports at 0170 
[size=8]                                                                            

        Region 3: I/O ports at 0374 
[size=1]                                                                            

        Region 4: I/O ports at fc00 
[size=16]                                                                           

        Region 5: Memory at 88000000 (32-bit, non-prefetchable) 
[size=1K]                                              
        Kernel driver in use: 
ata_piix                                                                                  

        Kernel modules: 
ata_piix                                                                                        


00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller 
(rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                                                                     
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-            
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-           
        Latency: 
0                                                                                                        

        Interrupt: pin A routed to IRQ 
18                                                                                 

        Region 0: I/O ports at dc00 
[size=8]                                                                              

        Region 1: I/O ports at d800 
[size=4]                                                                              

        Region 2: I/O ports at d400 
[size=8]                                                                              

        Region 3: I/O ports at d000 
[size=4]                                                                              

        Region 4: I/O ports at cc00 
[size=16]                                                                             

        Kernel driver in use: 
ata_piix                                                                                    

        Kernel modules: 
ata_piix                                                                                          


00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus 
Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 
80a6                             
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 
10                                                                    
        Region 4: I/O ports at 0400 
[size=32]                                                                
        Kernel modules: 
i2c-i801                                                                              


01:00.0 VGA compatible controller: nVidia Corporation NV35 [GeForce FX 
5900 Ultra] (rev a1)
        Subsystem: ASUSTeK Computer Inc. Device 
0313                                      
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 248 (1250ns min, 250ns 
max)                                                                 
        Interrupt: pin A routed to IRQ 
16                                                                    
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) 
[size=16M]                                   
        Region 1: Memory at e0000000 (32-bit, prefetchable) 
[size=256M]                                      
        [virtual] Expansion ROM at fe9e0000 [disabled] 
[size=128K]                                           
        Capabilities: [60] Power Management version 
2                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)                   
                Status: D0 PME-Enable- DSel=0 DScale=0 
PME-                                                  
        Capabilities: [44] AGP version 
3.0                                                                   
                Status: RQ=32 Iso- ArqSz=0 Cal=3 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3+ Rate=x4,x8    
                Command: RQ=32 ArqSz=2 Cal=0 SBA+ AGP+ GART64- 64bit- 
FW- Rate=x8                            
        Kernel driver in use: 
nvidia                                                                          

        Kernel modules: nvidiafb, 
nvidia                                                                     

02:03.0 Communication controller: Conexant Systems, Inc. HSF 56k HSFi 
Modem (rev 01)
        Subsystem: GVC Corporation Device 
8d85                                     
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
64                                                                                           

        Interrupt: pin A routed to IRQ 
255                                                                   
        Region 0: Memory at feaf0000 (32-bit, non-prefetchable) 
[size=64K]                                   
        Region 1: I/O ports at bc00 
[size=8]                                                                 
        Capabilities: [40] Power Management version 
2                                                        
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)                   
                Status: D0 PME-Enable- DSel=0 DScale=0 
PME-                                                  

02:0a.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL 
Video Broadcast Decoder (rev 01)
        Subsystem: ASUSTeK Computer Inc. Device 
4840                                                   
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (63750ns min, 63750ns 
max)                                                               
        Interrupt: pin A routed to IRQ 
22                                                                    
        Region 0: Memory at feaefc00 (32-bit, non-prefetchable) 
[size=1K]                                    
        Capabilities: [40] Power Management version 
1                                                        
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)                   
                Status: D0 PME-Enable- DSel=0 DScale=3 
PME-                                                  
        Kernel driver in use: 
saa7134                                                                         

        Kernel modules: 
saa7134                                                                               


02:0b.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
        Subsystem: Creative Labs Device 1009                        
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (500ns min, 5000ns 
max)                                                                  
        Interrupt: pin A routed to IRQ 
23                                                                    
        Region 0: I/O ports at b800 
[size=64]                                                                
        Capabilities: [dc] Power Management version 
2                                                        
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: EMU10K1_Audigy
        Kernel modules: snd-emu10k1

02:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A 
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10)
        Subsystem: ASUSTeK Computer Inc. Device 808b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (750ns min, 1000ns max), Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at feaef000 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at feae8000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Kernel driver in use: ohci1394
        Kernel modules: ohci1394

02:0f.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: ASUSTeK Computer Inc. Device 80b3
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at b400 [size=256]
        Region 1: Memory at feaef800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: 8139too
        Kernel modules: 8139too, 8139cp

7.6 SCSI information
/proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500BB-22G Rev: 08.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: MAXTOR STM325082 Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: CD/DVDW SH-S182M Rev: SB05
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3160828AS      Rev: 3.02
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: USB SD Reader    Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi4 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic  Model: USB CF Reader    Rev: 1.01
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi4 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic  Model: USB SM Reader    Rev: 1.02
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi4 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic  Model: USB MS Reader    Rev: 1.03
  Type:   Direct-Access                    ANSI  SCSI revision: 00

7.7 Other information
I'm not a developer, just a curious user.

Kubuntu 8.10 with home brewed kernel (kernel settings from ubuntu 
vmlinuz-2.6.27-11-generic + some ext4 settings for future tests)

Please cc me at "matti AT oviknet DOT com"

Best Regards
Matti Långvall
