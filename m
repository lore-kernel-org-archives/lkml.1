Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXJNUoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXJNUoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXJNUoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:44:37 -0400
Received: from b.mail.sonic.net ([64.142.19.5]:60659 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbXJNUog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:44:36 -0400
Message-ID: <47127FA8.6040506@sonic.net>
Date: Sun, 14 Oct 2007 13:44:24 -0700
From: Scott Petler <scottp@sonic.net>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel panic
References: <47114B46.10403@sonic.net> <1192393469.7573.8.camel@heimdal.trondhjem.org>
In-Reply-To: <1192393469.7573.8.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond,

I'm not exactly sure how to go back to not using the nvidia driver and 
select the xorg one.  I do know that I wasn't able to use both monitors 
with the xorg driver, but I'm willing to try that to isolate the problem.

Scott

Output from /proc/mounts:
rootfs / rootfs rw 0 0
none /sys sysfs rw 0 0
none /proc proc rw 0 0
udev /dev tmpfs rw 0 0
/dev/sda2 / ext3 rw,data=ordered 0 0
/dev/sda2 /dev/.static/dev ext3 rw,data=ordered 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid 0 0
usbfs /proc/bus/usb usbfs rw,nosuid,nodev,noexec 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec 0 0
twin:/home /home nfs 
rw,vers=3,rsize=32768,wsize=32768,hard,intr,proto=tcp,timeo=600,retrans=2,sec=sys,addr=twin 
0 0
twin:/mp3 /mp3 nfs 
rw,vers=3,rsize=32768,wsize=32768,hard,intr,proto=tcp,timeo=600,retrans=2,sec=sys,addr=twin 
0 0


Trond Myklebust wrote:
> On Sat, 2007-10-13 at 15:48 -0700, Scott Petler wrote:
>   
>> Machine lockup with caps lock/num lock flashing or complete reboot/panic.
>>
>> I get various lockup issues with this kernel, (2.6.23 also similar 
>> problem).   I had problems getting e1000 lan module to work (it was fine 
>> in 2.6.21.5).  I disabled it and installed a different lan card that 
>> seems to work "better".
>>
>> Dual head machine 1GB RAM, nvidia driver x86-100.14.19
>>     
>
> Are you able to repeat this Oops _without_ the nvidia driver?
>
> Also, please provide the output from /proc/mounts
>
> Cheers
>   Trond
>
>
>   
>> Here is output of ver_linux:
>> ---------------------------------------------------------------------------------------------------------------------------------------------
>>
>> Linux zion 2.6.23-rc9 #3 Fri Oct 12 18:27:56 PDT 2007 i686 GNU/Linux
>>
>> Gnu C                  4.1.2
>> Gnu make               3.81
>> binutils               2.17
>> util-linux             2.12r
>> mount                  2.12r
>> module-init-tools      3.3-pre2
>> e2fsprogs              1.40-WIP
>> Linux C Library        3.6
>> Dynamic linker (ldd)   2.3.6
>> Procps                 3.2.7
>> Net-tools              1.60
>> Console-tools          0.2.3
>> Sh-utils               5.97
>> udev                   105
>> Modules Loaded         nfs lockd sunrpc nvidia i2c_core af_packet ipv6 
>> capability commoncap ppdev lp ac battery dm_mod e1000 loop snd_intel8x0 
>> snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer 
>> parport_pc button parport snd 8250_pnp 8250 serial_core soundcore shpchp 
>> pci_hotplug snd_page_alloc rng_core floppy intel_agp agpgart rtc sg 
>> evdev sr_mod usbhid sd_mod ata_piix 8139too ata_generic ehci_hcd 
>> uhci_hcd mii bitrev crc32 libata generic usbcore thermal processor fan 
>> unix ext3 jbd piix ide_disk ide_cd cdrom ide_scsi scsi_mod ide_core
>> ---------------------------------------------------------------------------------------------------------------------------------------------
>>
>> Here is output from syslog as it went down:
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: Oops: 0002 [#1]
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: CPU:    0
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: EIP:    0060:[<e1168fde>]    Tainted: P        VLI
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: EFLAGS: 00010206   (2.6.23-rc9 #3)
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: EIP is at 0xe1168fde
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: esi: f8f34700   edi: 00000000   ebp: 00000001   esp: e7cf3e00
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: Process firefox-bin (pid: 8397, ti=e7cf2000 task=f258ca90 
>> task.ti=e
>> 7cf2000)
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: Stack: f8f18eb7 c01367f6 e7cf3e48 000003e8 000003e8 
>> ed3e97c0 f1f6db
>> 9c f1f6db9c
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:        e7cf3f54 f8f60ec2 0004257b 00000000 00000000 
>> f1f037dc e7cf3f
>> 54 c01563d0
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:        019cc780 e7cf3eb0 c0155a63 dfff38c0 c014e001 
>> 019cc780 f1f037
>> dc dfe0ecf4
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel: Call Trace:
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<f8f18eb7>] rpcauth_lookupcred+0x63/0x87 [sunrpc]
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<c01367f6>] pagevec_lookup+0x1c/0x22
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<f8f60ec2>] nfs_permission+0xab/0x183 [nfs]
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<c01563d0>] __d_lookup+0x8b/0xbf
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<c0155a63>] dput+0x15/0xcb
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<f8f60e17>] nfs_permission+0x0/0x183 [nfs]
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<c014f648>] __link_path_walk+0x11c/0xa79
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<c0102ff8>] setup_sigcontext+0x104/0x187
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<c014ffe7>] link_path_walk+0x42/0xaf
>> Read from remote host 192.168.1.175: Connection reset by peer
>> Connection to 192.168.1.175 closed.
>>
>> Message from syslogd@zion at Sat Oct 13 15:22:34 2007 ...
>> zion kernel:  [<c014de5a>] permission+0x9e/0xdb
>>
>> ------------------------------------------------------------------------------------------------------------------------------------------------
>> /proc/cpuinfo
>>
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 15
>> model           : 2
>> model name      : Intel(R) Pentium(R) 4 CPU 2.40GHz
>> stepping        : 7
>> cpu MHz         : 2411.749
>> cache size      : 512 KB
>> fdiv_bug        : no
>> hlt_bug         : no
>> f00f_bug        : no
>> coma_bug        : no
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 2
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs 
>> bts sync_rdtsc cid xtpr
>> bogomips        : 4826.95
>> clflush size    : 64
>>
>> ----------------------------------------------------------------------------------------------------------------------------------------------------
>> /proc/modules
>>
>> nfs 120816 1 - Live 0xf8f3a000
>> lockd 59656 2 nfs, Live 0xf8d7a000
>> sunrpc 154524 6 nfs,lockd, Live 0xf8f13000
>> nvidia 6212112 24 - Live 0xf9448000 (P)
>> i2c_core 23312 1 nvidia, Live 0xf8d4a000
>> af_packet 20104 2 - Live 0xf8d51000
>> ipv6 222052 10 - Live 0xf8d8b000
>> capability 5000 0 - Live 0xf8d39000
>> commoncap 7296 1 capability, Live 0xf886a000
>> ppdev 8964 0 - Live 0xf8d35000
>> lp 11204 0 - Live 0xf8d31000
>> ac 5764 0 - Live 0xf89fa000
>> battery 12424 0 - Live 0xf89ff000
>> dm_mod 49728 0 - Live 0xf8d3c000
>> e1000 111424 0 - Live 0xf8a2c000
>> loop 16772 0 - Live 0xf89ee000
>> snd_intel8x0 31260 0 - Live 0xf8a05000
>> snd_ac97_codec 90784 1 snd_intel8x0, Live 0xf8a4a000
>> ac97_bus 2432 1 snd_ac97_codec, Live 0xf88ce000
>> snd_pcm_oss 38560 0 - Live 0xf8a21000
>> snd_mixer_oss 15360 1 snd_pcm_oss, Live 0xf89a5000
>> snd_pcm 68872 3 snd_intel8x0,snd_ac97_codec,snd_pcm_oss, Live 0xf8a0f000
>> snd_timer 19972 1 snd_pcm, Live 0xf89f4000
>> parport_pc 33572 1 - Live 0xf89ca000
>> button 8464 0 - Live 0xf89c6000
>> parport 33096 3 ppdev,lp,parport_pc, Live 0xf89e2000
>> snd 46820 6 
>> snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer, 
>> Live 0xf89d5000
>> 8250_pnp 9728 0 - Live 0xf89aa000
>> 8250 21748 1 8250_pnp, Live 0xf89bf000
>> serial_core 19072 1 8250, Live 0xf89b9000
>> soundcore 7392 1 snd, Live 0xf895d000
>> shpchp 30996 0 - Live 0xf89b0000
>> pci_hotplug 13960 1 shpchp, Live 0xf8963000
>> snd_page_alloc 10248 2 snd_intel8x0,snd_pcm, Live 0xf89a1000
>> rng_core 5252 0 - Live 0xf8960000
>> floppy 51876 0 - Live 0xf8971000
>> intel_agp 23572 1 - Live 0xf894d000
>> agpgart 31152 2 nvidia,intel_agp, Live 0xf8968000
>> rtc 11800 0 - Live 0xf8949000
>> sg 31644 0 - Live 0xf8954000
>> evdev 9600 1 - Live 0xf890b000
>> sr_mod 15140 0 - Live 0xf8906000
>> usbhid 26496 0 - Live 0xf8941000
>> sd_mod 26000 3 - Live 0xf8939000
>> ata_piix 17028 2 - Live 0xf8933000
>> 8139too 23552 0 - Live 0xf892c000
>> ata_generic 7812 0 - Live 0xf881b000
>> ehci_hcd 27916 0 - Live 0xf88f1000
>> uhci_hcd 21900 0 - Live 0xf88f9000
>> mii 5504 1 8139too, Live 0xf88ee000
>> bitrev 2176 1 8139too, Live 0xf88cc000
>> crc32 4224 1 8139too, Live 0xf886d000
>> libata 111796 2 ata_piix,ata_generic, Live 0xf890f000
>> generic 4996 0 [permanent], Live 0xf8867000
>> usbcore 122264 4 usbhid,ehci_hcd,uhci_hcd, Live 0xf88ad000
>> thermal 15644 0 - Live 0xf8878000
>> processor 21152 1 thermal, Live 0xf8830000
>> fan 5252 0 - Live 0xf881e000
>> unix 24880 654 - Live 0xf8870000
>> ext3 118024 1 - Live 0xf88d0000
>> jbd 49960 1 ext3, Live 0xf889f000
>> piix 8836 0 [permanent], Live 0xf882c000
>> ide_disk 16000 0 - Live 0xf8827000
>> ide_cd 36000 0 - Live 0xf885d000
>> cdrom 32800 2 sr_mod,ide_cd, Live 0xf8853000
>> ide_scsi 16392 0 - Live 0xf8821000
>> scsi_mod 132360 5 sg,sr_mod,sd_mod,libata,ide_scsi, Live 0xf887d000
>> ide_core 106704 5 generic,piix,ide_disk,ide_cd,ide_scsi, Live 0xf8837000
>>
>> ------------------------------------------------------------------------------------------------------------------------------------------------
>> /proc/ioports
>> 0000-001f : dma1
>> 0020-0021 : pic1
>> 0040-0043 : timer0
>> 0050-0053 : timer1
>> 0060-006f : keyboard
>> 0070-0077 : rtc
>> 0080-008f : dma page reg
>> 00a0-00a1 : pic2
>> 00c0-00df : dma2
>> 00f0-00ff : fpu
>> 0170-0177 : 0000:00:1f.2
>>   0170-0177 : libata
>> 01f0-01f7 : 0000:00:1f.2
>>   01f0-01f7 : libata
>> 02f8-02ff : serial
>> 0376-0376 : 0000:00:1f.2
>>   0376-0376 : libata
>> 0378-037a : parport0
>> 03c0-03df : vga+
>> 03f2-03f5 : floppy
>> 03f6-03f6 : 0000:00:1f.2
>>   03f6-03f6 : libata
>> 03f7-03f7 : floppy DIR
>> 03f8-03ff : serial
>> 0cf8-0cff : PCI conf1
>> 1000-107f : 0000:00:1f.0
>>   1000-1003 : ACPI PM1a_EVT_BLK
>>   1004-1005 : ACPI PM1a_CNT_BLK
>>   1008-100b : ACPI PM_TMR
>>   1028-102f : ACPI GPE0_BLK
>> 1080-10bf : 0000:00:1f.0
>> 1400-141f : 0000:00:1f.3
>> a000-afff : PCI Bus #02
>>   a000-a0ff : 0000:02:01.0
>>     a000-a0ff : 8139too
>> b000-b01f : 0000:00:1d.1
>>   b000-b01f : uhci_hcd
>> b400-b41f : 0000:00:1d.2
>>   b400-b41f : uhci_hcd
>> b800-b81f : 0000:00:1d.3
>>   b800-b81f : uhci_hcd
>> bc00-bc1f : 0000:00:1d.0
>>   bc00-bc1f : uhci_hcd
>> d800-d8ff : 0000:00:1f.5
>>   d800-d8ff : Intel ICH5
>> dc00-dc3f : 0000:00:1f.5
>>   dc00-dc3f : Intel ICH5
>> f000-f00f : 0000:00:1f.2
>>   f000-f00f : libata
>> -----------------------------------------------------------------------------------------------------------------------------------------------
>> /proc/iomem
>>
>> 00000000-0009f7ff : System RAM
>> 0009f800-0009ffff : reserved
>> 000a0000-000bffff : Video RAM area
>> 000c0000-000c7fff : Video ROM
>> 000d0000-000d7fff : pnp 00:00
>> 000f0000-000fffff : System ROM
>> 00100000-3ffeffff : System RAM
>>   00100000-00287ed7 : Kernel code
>>   00287ed8-003224df : Kernel data
>> 3fff0000-3fff2fff : ACPI Non-volatile Storage
>> 3fff3000-3fffffff : ACPI Tables
>> d0000000-dfffffff : PCI Bus #01
>>   d0000000-dfffffff : 0000:01:00.0
>> e0000000-e7ffffff : 0000:00:00.0
>> e8000000-ebffffff : PCI Bus #02
>>   e8000000-ebffffff : 0000:02:04.0
>> ec000000-eeffffff : PCI Bus #01
>>   ec000000-ecffffff : 0000:01:00.0
>>     ec000000-ecffffff : nvidia
>>   ed000000-edffffff : 0000:01:00.0
>>   ee000000-ee01ffff : 0000:01:00.0
>> ef000000-ef0fffff : PCI Bus #02
>>   ef000000-ef0000ff : 0000:02:01.0
>>     ef000000-ef0000ff : 8139too
>> ef100000-ef1003ff : 0000:00:1d.7
>>   ef100000-ef1003ff : ehci_hcd
>> ef101000-ef1011ff : 0000:00:1f.5
>>   ef101000-ef1011ff : Intel ICH5
>> ef102000-ef1020ff : 0000:00:1f.5
>>   ef102000-ef1020ff : Intel ICH5
>> fec00000-ffffffff : reserved
>> ~
>> ----------------------------------------------------------------------------------------------------------------------------------------------
>> lspci -vvv
>>
>> 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM 
>> Controller/Host-Hub Interface (rev 02)
>>         Subsystem: Giga-byte Technology GA-8IPE1000 Pro2 motherboard (865PE)
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR+ FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
>> <TAbort- <MAbort+ >SERR- <PERR-
>>         Latency: 0
>>         Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
>>         Capabilities: [e4] Vendor Specific Information
>>         Capabilities: [a0] AGP version 3.0
>>                 Status: RQ=32 Iso- ArqSz=2 Cal=2 SBA+ ITACoh- GART64- 
>> HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
>>                 Command: RQ=1 ArqSz=0 Cal=2 SBA+ AGP+ GART64- 64bit- FW- 
>> Rate=x8
>>
>> 00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller 
>> (rev 02) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 64
>>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: ec000000-eeffffff
>>         Prefetchable memory behind bridge: d0000000-dfffffff
>>         Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort+ <SERR- <PERR-
>>         BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
>>
>> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
>> UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Giga-byte Technology GA-8IPE1000/8KNXP motherboard
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 16
>>         Region 4: I/O ports at bc00 [size=32]
>>
>> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
>> UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Giga-byte Technology GA-8IPE1000 Pro2 motherboard (865PE)
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Interrupt: pin B routed to IRQ 17
>>         Region 4: I/O ports at b000 [size=32]
>>
>> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
>> UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Giga-byte Technology GA-8IPE1000 Pro2 motherboard (865PE)
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Interrupt: pin C routed to IRQ 18
>>         Region 4: I/O ports at b400 [size=32]
>>
>> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
>> UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Giga-byte Technology GA-8IPE1000 Pro2 motherboard (865PE)
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 16
>>         Region 4: I/O ports at b800 [size=32]
>> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 
>> EHCI Controller (rev 02) (prog-if 20 [EHCI])
>>         Subsystem: Giga-byte Technology GA-8IPE1000 Pro2 motherboard (865PE)
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Interrupt: pin D routed to IRQ 19
>>         Region 0: Memory at ef100000 (32-bit, non-prefetchable) [size=1K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>
>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if 
>> 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
>>         I/O behind bridge: 0000a000-0000afff
>>         Memory behind bridge: ef000000-ef0fffff
>>         Prefetchable memory behind bridge: e8000000-ebffffff
>>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>>
>> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC 
>> Interface Bridge (rev 02)
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>
>> 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller 
>> (rev 02) (prog-if 8a [Master SecP PriP])
>>         Subsystem: Giga-byte Technology GA-8IPE1000 Pro2 motherboard (865PE)
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 18
>>         Region 0: I/O ports at 01f0 [size=8]
>>         Region 1: I/O ports at 03f4 [size=1]
>>         Region 2: I/O ports at 0170 [size=8]
>>         Region 3: I/O ports at 0374 [size=1]
>>         Region 4: I/O ports at f000 [size=16]
>>
>> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus 
>> Controller (rev 02)
>>         Subsystem: Giga-byte Technology GA-8IPE1000 Pro2 motherboard (865PE)
>>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Interrupt: pin B routed to IRQ 9
>>         Region 4: I/O ports at 1400 [size=32]
>>
>> 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER 
>> (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
>>         Subsystem: Giga-byte Technology GA-8IPE1000/8KNXP motherboard
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0
>>         Interrupt: pin B routed to IRQ 21
>>         Region 0: I/O ports at d800 [size=256]
>>         Region 1: I/O ports at dc00 [size=64]
>>         Region 2: Memory at ef101000 (32-bit, non-prefetchable) [size=512]
>>         Region 3: Memory at ef102000 (32-bit, non-prefetchable) [size=256]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>> 01:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 
>> 6600/GeForce 6600 GT] (rev a2) (prog-if 00 [VGA])
>>         Subsystem: XFX Pine Group Inc. GeForce 6600 GT AGP 128MB DDR3 
>> DUAL DVI TV
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 248 (1250ns min, 250ns max)
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: Memory at ec000000 (32-bit, non-prefetchable) [size=16M]
>>         Region 1: Memory at d0000000 (32-bit, prefetchable) [size=256M]
>>         Region 2: Memory at ed000000 (32-bit, non-prefetchable) [size=16M]
>>         [virtual] Expansion ROM at ee000000 [disabled] [size=128K]
>>         Capabilities: [60] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [44] AGP version 3.0
>>                 Status: RQ=256 Iso- ArqSz=0 Cal=3 SBA+ ITACoh- GART64- 
>> HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
>>                 Command: RQ=32 ArqSz=2 Cal=0 SBA+ AGP+ GART64- 64bit- 
>> FW- Rate=x8
>>
>> 02:01.0 Ethernet controller: D-Link System Inc RTL8139 Ethernet (rev 10)
>>         Subsystem: D-Link System Inc DFE-530TX+ 10/100 Ethernet Adapter
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 64 (8000ns min, 16000ns max)
>>         Interrupt: pin A routed to IRQ 20
>>         Region 0: I/O ports at a000 [size=256]
>>         Region 1: Memory at ef000000 (32-bit, non-prefetchable) [size=256]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
>> PME(D0-,D1+,D2+,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>
>> 02:04.0 Multimedia video controller: Internext Compression Inc iTVC16 
>> (CX23416) MPEG-2 Encoder (rev 01)
>>         Subsystem: Hauppauge computer works Inc. WinTV PVR 150
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 32 (32000ns min, 2000ns max), Cache Line Size: 32 bytes
>>         Interrupt: pin A routed to IRQ 11
>>         Region 0: Memory at e8000000 (32-bit, prefetchable) [size=64M]
>>         Capabilities: [44] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>
>> --------------------------------------------------------------------------------------------------------------------------------------------
>> /proc/scsi/scsi
>>
>> Attached devices:
>> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>>   Vendor: ATA      Model: HDS722516VLSA80  Rev: V34O
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>>   Vendor: SONY     Model: CD-ROM CDU5211   Rev: YYS7
>>   Type:   CD-ROM                           ANSI  SCSI revision: 05
>>
>>
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>     
>
>
>   
