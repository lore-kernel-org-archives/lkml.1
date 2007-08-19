Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbXHSS7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbXHSS7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 14:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXHSS7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 14:59:09 -0400
Received: from smtp01out.vivodinet.gr ([83.171.203.1]:53644 "EHLO
	smtp01.vivodinet.gr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752226AbXHSS7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 14:59:07 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2007 14:59:06 EDT
Message-ID: <46C88CF7.6020900@central.ntua.gr>
Date: Sun, 19 Aug 2007 21:33:27 +0300
From: Costas Sismanis <el98155@central.ntua.gr>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

verlinux output

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux gemini 2.6.22-gentoo-r2 #1 PREEMPT Tue Aug 14 19:55:49 EEST 2007 
i686 AMD
Athlon(tm) XP 1700+ AuthenticAMD GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
reiserfsprogs          3.6.19
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   114
wireless-tools         28
Modules Loaded         wlan_tkip wlan_ccmp nvidia wlan_scan_sta rtc 
ath_rate_sam
ple ath_pci wlan ath_hal


One kernel panic before , and now this printed BUG

BUG: unable to handle kernel paging request at virtual address 00450014
 printing eip:
c014df0a
*pde = 00000000
Oops: 0002 [#1]
PREEMPT
Modules linked in: wlan_tkip wlan_ccmp nvidia(P) wlan_scan_sta rtc 
ath_rate_sample ath_pci wlan ath_hal(P)
CPU:    0
EIP:    0060:[<c014df0a>]    Tainted: P       VLI
EFLAGS: 00210206   (2.6.22-gentoo-r2 #1)
EIP is at unmap_vmas+0x3ca/0x4b0
eax: 00450000   ebx: da3cf13c   ecx: dc837e48   edx: edcf4880
esi: fffffff8   edi: 08050000   ebp: 00000000   esp: cb451d28
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process dodoc (pid: 27342, ti=cb450000 task=efc54a90 task.ti=cb450000)
Stack: 080e2fff 00000000 dc837e48 cb451d8c 00000000 00000001 080e3000 
edac2080
       edcf4880 c051df88 00000000 fffffff8 edac2080 2e281025 080e3000 
00000000
       cb451d8c dc837e48 edcf4880 edcf4880 c0151059 ffffffff cb451d88 
00000000
Call Trace:
 [<c0151059>] exit_mmap+0x69/0xf0
 [<c011ba22>] mmput+0x32/0xb0
 [<c0164fc0>] flush_old_exec+0x460/0x8c0
 [<c016472d>] kernel_read+0x3d/0x60
 [<c018ef12>] load_elf_binary+0x302/0x1b30
 [<c0144aeb>] generic_file_aio_read+0xbb/0x1c0
 [<c0141cb0>] file_read_actor+0x0/0x120
 [<c0176933>] mntput_no_expire+0x13/0x80
 [<c0160595>] do_sync_read+0xd5/0x120
 [<c0146da6>] __alloc_pages+0x56/0x2f0
 [<c0164308>] copy_strings+0xf8/0x210
 [<c018ec10>] load_elf_binary+0x0/0x1b30
 [<c0164506>] search_binary_handler+0xa6/0x250
 [<c0165d22>] do_execve+0x132/0x1b0
 [<c010255f>] sys_execve+0x2f/0x90
 [<c0103f6e>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 14 8b 40 08 a8 08 0f 85 b1 00 00 00 89 e0 25 00 e0 ff ff 8b 40 08 
a8 08 0f 85 8b 00 00 00 8b 4c 24 08 89 e0 25 00 e0 ff ff 8b 11 <ff> 40 
14 89 15 88 df 51 c0 8b 44 2
4 14 bd 00 80 00 00 8b 54 24
EIP: [<c014df0a>] unmap_vmas+0x3ca/0x4b0 SS:ESP 0068:cb451d28


this on probably freezed the computer


 BUG: unable to handle kernel paging request at virtual address 40000039
Aug 17 12:55:59 gemini printing eip:
Aug 17 12:55:59 gemini c014d2f7
Aug 17 12:55:59 gemini *pde = 00000000
Aug 17 12:55:59 gemini Oops: 0002 [#1]
Aug 17 12:55:59 gemini PREEMPT
Aug 17 12:55:59 gemini Modules linked in: wlan_tkip wlan_ccmp rtc 
nvidia(P) wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal(P)
Aug 17 12:55:59 gemini CPU:    0
Aug 17 12:55:59 gemini EIP:    0060:[<c014d2f7>]    Tainted: P       VLI
Aug 17 12:55:59 gemini EFLAGS: 00210246   (2.6.22-gentoo-r2 #1)
Aug 17 12:55:59 gemini EIP is at free_pgd_range+0x47/0x190
Aug 17 12:55:59 gemini eax: 40000000   ebx: cce32ef0   ecx: 40000000   
edx: 08048000
Aug 17 12:55:59 gemini esi: 08000000   edi: cf58ada0   ebp: 08048000   
esp: dd4ddd30
Aug 17 12:55:59 gemini ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Aug 17 12:55:59 gemini Process sh (pid: 6154, ti=dd4dc000 task=cd1a6570 
task.ti=dd4dc000)
Aug 17 12:55:59 gemini Stack: 00000000 dd4ddd8c 00000000 dd4ddd8c 
cce32ef0 cce32ef0 cf58ada0 cf58ada0
Aug 17 12:55:59 gemini 08048000 c014fbaa 00000080 40000000 00000000 
dd4ddd8c dd4ddd8c cf58aef0
Aug 17 12:55:59 gemini efbfd560 efbfd560 c0151077 00000000 dd4ddd88 
00000000 000000dd c051df88
Aug 17 12:55:59 gemini Call Trace:
Aug 17 12:55:59 gemini [<c014fbaa>] free_pgtables+0xaa/0xb0
Aug 17 12:55:59 gemini [<c0151077>] exit_mmap+0x87/0xf0
Aug 17 12:55:59 gemini [<c011ba22>] mmput+0x32/0xb0
Aug 17 12:55:59 gemini [<c0164fc0>] flush_old_exec+0x460/0x8c0
Aug 17 12:55:59 gemini [<c016472d>] kernel_read+0x3d/0x60
Aug 17 12:55:59 gemini [<c018ef12>] load_elf_binary+0x302/0x1b30
Aug 17 12:55:59 gemini [<c0144aeb>] generic_file_aio_read+0xbb/0x1c0
Aug 17 12:55:59 gemini [<c0141cb0>] file_read_actor+0x0/0x120
Aug 17 12:55:59 gemini [<c0176933>] mntput_no_expire+0x13/0x80
Aug 17 12:55:59 gemini [<c0160595>] do_sync_read+0xd5/0x120
Aug 17 12:55:59 gemini [<c0146da6>] __alloc_pages+0x56/0x2f0
Aug 17 12:55:59 gemini [<c0164308>] copy_strings+0xf8/0x210
Aug 17 12:55:59 gemini [<c018ec10>] load_elf_binary+0x0/0x1b30
Aug 17 12:55:59 gemini [<c0164506>] search_binary_handler+0xa6/0x250
Aug 17 12:55:59 gemini [<c0165d22>] do_execve+0x132/0x1b0
Aug 17 12:55:59 gemini [<c010255f>] sys_execve+0x2f/0x90
Aug 17 12:55:59 gemini [<c0103f6e>] sysenter_past_esp+0x5f/0x85
Aug 17 12:55:59 gemini =======================
Aug 17 12:55:59 gemini Code: 0c 81 c6 00 00 40 00 0f 84 49 01 00 00 8b 
4c 24 2c 85 c9 74 2f 81 64 24 2c 00 00 c0 ff 0f 84 33 01 00 00 8b 54 24 
08 8b 44 24 2c <4a> 48 39 c2 89 54 24 10 76 18 81 6c 24 08 00 00 00 00 
8d b4 26
Aug 17 12:55:59 gemini EIP: [<c014d2f7>] free_pgd_range+0x47/0x190 
SS:ESP 0068:dd4ddd30
Aug 17 12:55:59 gemini note: sh[6154] exited with preempt_count 1
Aug 17 12:55:59 gemini BUG: unable to handle kernel NULL pointer 
dereference at virtual address 00000202
Aug 17 12:55:59 gemini printing eip:
Aug 17 12:55:59 gemini c014d335
Aug 17 12:55:59 gemini *pde = 00000000
Aug 17 12:55:59 gemini Oops: 0002 [#2]
Aug 17 12:55:59 gemini PREEMPT
Aug 17 12:55:59 gemini Modules linked in: wlan_tkip wlan_ccmp rtc 
nvidia(P) wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal(P)
Aug 17 12:55:59 gemini CPU:    0
Aug 17 12:55:59 gemini EIP:    0060:[<c014d335>]    Tainted: P       VLI
Aug 17 12:55:59 gemini EFLAGS: 00210217   (2.6.22-gentoo-r2 #1)
Aug 17 12:55:59 gemini EIP is at free_pgd_range+0x85/0x190
Aug 17 12:55:59 gemini eax: 000000ff   ebx: ceb0e17c   ecx: 40000000   
edx: c051df88
Aug 17 12:55:59 gemini esi: 08000000   edi: 000003fc   ebp: 08048000   
esp: de46fef4
Aug 17 12:55:59 gemini ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Aug 17 12:55:59 gemini Process sh (pid: 6018, ti=de46e000 task=dca66090 
task.ti=de46e000)
Aug 17 12:55:59 gemini Stack: 00000000 de46ff50 0818e000 de46ff50 
0818dfff ceb0e17c c388f320 c388f320
Aug 17 12:55:59 gemini 08048000 c014fbaa 00000080 40000000 00000000 
de46ff50 de46ff50 eed29b54
Aug 17 12:55:59 gemini eed1c440 00008b00 c0151077 00000000 de46ff4c 
00000000 000000de c051df88
Aug 17 12:55:59 gemini Call Trace:
Aug 17 12:55:59 gemini [<c014fbaa>] free_pgtables+0xaa/0xb0
Aug 17 12:55:59 gemini [<c0151077>] exit_mmap+0x87/0xf0
Aug 17 12:55:59 gemini [<c011ba22>] mmput+0x32/0xb0
Aug 17 12:55:59 gemini [<c0120a82>] do_exit+0xf2/0x840
Aug 17 12:55:59 gemini [<c01211f3>] do_group_exit+0x23/0x80
Aug 17 12:55:59 gemini [<c0103f6e>] sysenter_past_esp+0x5f/0x85

Aug 17 12:55:59 gemini =======================
Aug 17 12:55:59 gemini Code: b4 26 00 00 00 00 8b 44 24 08 48 89 44 24 
10 3b 74 24 10 0f 87 ff 00 00 00 8b 54 24 0c 89 f0 c1 e8 16 8d 3c 85 00 
00 00 00 8b 12 <89> 54 24 04 8b 12 03 7a 24 8b 54 24 2c 81 e2 00 00 c0 
ff 89 14
Aug 17 12:55:59 gemini EIP: [<c014d335>] free_pgd_range+0x85/0x190 
SS:ESP 0068:de46fef4
Aug 17 12:55:59 gemini Fixing recursive fault but reboot is needed!
Aug 17 12:55:59 gemini BUG: scheduling while atomic: sh/0x00000001/6018
Aug 17 12:55:59 gemini [<c03e477e>] schedule+0x46e/0x640
Aug 17 12:55:59 gemini [<c012da97>] __rcu_process_callbacks+0x67/0x1d0
Aug 17 12:55:59 gemini [<c0122933>] tasklet_action+0x33/0x70
Aug 17 12:55:59 gemini [<c0122882>] __do_softirq+0x42/0x90
Aug 17 12:55:59 gemini [<c0121174>] do_exit+0x7e4/0x840
Aug 17 12:55:59 gemini [<c01049ac>] apic_timer_interrupt+0x28/0x30
Aug 17 12:55:59 gemini [<c01054a6>] die+0x206/0x210
Aug 17 12:55:59 gemini [<c01160d4>] do_page_fault+0x2d4/0x5f0
Aug 17 12:55:59 gemini [<c0166cfb>] pipe_write+0x23b/0x490
Aug 17 12:55:59 gemini [<c0115e00>] do_page_fault+0x0/0x5f0
Aug 17 12:55:59 gemini [<c03e657a>] error_code+0x6a/0x70
Aug 17 12:55:59 gemini [<c014d335>] free_pgd_range+0x85/0x190
Aug 17 12:55:59 gemini [<c014fbaa>] free_pgtables+0xaa/0xb0
Aug 17 12:55:59 gemini [<c0151077>] exit_mmap+0x87/0xf0
Aug 17 12:55:59 gemini [<c011ba22>] mmput+0x32/0xb0
Aug 17 12:55:59 gemini [<c0120a82>] do_exit+0xf2/0x840
Aug 17 12:55:59 gemini [<c01211f3>] do_group_exit+0x23/0x80
Aug 17 12:55:59 gemini [<c0103f6e>] sysenter_past_esp+0x5f/0x85
Aug 17 12:55:59 gemini =======================


i dont know what caused it , at the time , the computer was compiling 
various programs

the environment is a gentoo


Linux version 2.6.22-gentoo-r2 (root@gemini) (gcc version 4.1.2 (Gentoo 
4.1.2 p1.0.1)) #1 PREEMPT Tue Aug 14 19:55:49 EEST 2007

the modules wlan_tkip 11072 2 - Live 0xf0ab6000
wlan_ccmp 7168 1 - Live 0xf0aba000
nvidia 7234932 24 - Live 0xf10de000 (P)
wlan_scan_sta 12032 1 - Live 0xf0903000
rtc 10392 0 - Live 0xf08ff000
ath_rate_sample 12416 1 - Live 0xf08fa000
ath_pci 89376 0 - Live 0xf0910000
wlan 191236 6 wlan_tkip,wlan_ccmp,wlan_scan_sta,ath_rate_sample,ath_pci, 
Live 0xf0891000
ath_hal 189712 3 ath_rate_sample,ath_pci, Live 0xf08c5000 (P)

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
0170-0177 : 0000:00:11.1
  0170-0177 : ide1
01f0-01f7 : 0000:00:11.1
  01f0-01f7 : ide0
02f8-02ff : serial
0376-0376 : 0000:00:11.1
  0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:11.1
  03f6-03f6 : ide0
03f8-03ff : serial
0800-0803 : ACPI PM1a_EVT_BLK
0804-0805 : ACPI PM1a_CNT_BLK
0808-080b : ACPI PM_TMR
0810-0815 : ACPI CPU throttle
0820-0823 : ACPI GPE0_BLK
0cf8-0cff : PCI conf1
e800-e8ff : 0000:00:11.5
  e800-e8ff : VIA8233
ec00-ecff : 0000:00:06.0
  ec00-ecff : 8139too
fc00-fc0f : 0000:00:11.1
  fc00-fc07 : ide0
  fc08-fc0f : ide1


cat  /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cedff : Video ROM
000f0000-000fffff : System ROM
00100000-2ffeffff : System RAM
  00100000-003e7422 : Kernel code
  003e7423-004dc0bb : Kernel data
2fff0000-2fff7fff : ACPI Tables
2fff8000-2fffffff : ACPI Non-volatile Storage
bbc00000-dbcfffff : PCI Bus #01
  c0000000-cfffffff : 0000:01:00.0
dbe00000-dfefffff : PCI Bus #01
  dd000000-ddffffff : 0000:01: 00.0
  de000000-deffffff : 0000:01:00.0
    de000000-deffffff : nvidia
  dfee0000-dfefffff : 0000:01:00.0
dffe0000-dffeffff : 0000:00:07.0
  dffe0000-dffeffff : ath
dfffd000-dfffdfff : 0000:00:09.0
  dfffd000-dfffdfff : ohci_hcd
dfffe000-dfffefff : 0000:00:09.1
  dfffe000-dfffefff : ohci_hcd
dffffe00-dffffeff : 0000:00:09.2
  dffffe00-dffffeff : ehci_hcd
dfffff00-dfffffff : 0000:00:06.0
  dfffff00-dfffffff : 8139too
e0000000-e3ffffff : 0000:00: 00.0
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
fff80000-ffffffff : reserved


lspci -vvv
00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
        Subsystem: VIA Technologies, Inc. Unknown device 0000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR+
        Latency: 0
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- FW- 
Rate=x4
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo 
KT266/A/333 AGP] (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: dbe00000-dfefffff
        Prefetchable memory behind bridge: bbc00000-dbcfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RT8139
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at ec00 [size=256]
        Region 1: Memory at dfffff00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 Ethernet controller: Atheros Communications, Inc. AR5212 
802.11abg NIC (rev 01)
        Subsystem: D-Link System Inc DWL-G520 Wireless PCI Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at dffe0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-




00:09.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
        Subsystem: NEC Corporation Hama USB 2.0 CardBus
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (250ns min, 10500ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at dfffd000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
        Subsystem: NEC Corporation Hama USB 2.0 CardBus
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (250ns min, 10500ns max), Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 16
        Region 0: Memory at dfffe000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 20 [EHCI])
        Subsystem: NEC Corporation USB 2.0
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 8500ns max), Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 17
        Region 0: Memory at dffffe00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 ISA bridge: VIA Technologies, Inc. VT8233 PCI to ISA Bridge
        Subsystem: VIA Technologies, Inc. Unknown device 0000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) 
(prog-if 8a [Master SecP PriP])
        Subsystem: VIA Technologies, Inc. 
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit, 
non-prefetchable) [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, 
non-prefetchable) [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, 
non-prefetchable) [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, 
non-prefetchable) [size=1]
        Region 4: I/O ports at fc00 [size=16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.5 Multimedia audio controller: VIA Technologies, Inc. 
VT8233/A/8235/8237 AC97 Audio Controller (rev 10)
        Subsystem: Avance Logic Inc. MSI K7T266 Pro2-RU (MSI-6380 v2) 
onboard audio (Realtek/ALC 200/200P)
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 12
        Region 0: I/O ports at e800 [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 
6200] (rev a1) (prog-if 00 [VGA])
        Subsystem: XFX Pine Group Inc. Unknown device 2152
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 248 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at c0000000 (32-bit, prefetchable) [size=256M]
        Region 2: Memory at dd000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at dfee0000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 3.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=32 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- 
FW- Rate=x4

cat /proc/scsi/scsi
Attached devices:



hope it helps !

