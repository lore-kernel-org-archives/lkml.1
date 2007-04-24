Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbXDXBsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbXDXBsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbXDXBsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:48:30 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:35907 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbXDXBs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jSz9VIH4d162xpR7Q8VjvqTyF0Y/iW69hyD3STEKKwT/T3tzQlbIM7G5TvO6m321geoeHwclk6Ez29OaJgRz40sx4NB2xUyttil8DjJSTq1w4Y+II2GgCs/KxevWhSXUNH+NjqRG4cqN+m7GTP4CcH1/5nBEAsHj93PlIFStXmU=
Subject: PROBLEM: Oops: 0002 [1] SMP
From: "Thiago M." =?ISO-8859-1?Q?Say=E3o?= <thiago.sayao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Apr 2007 22:48:12 -0300
Message-Id: <1177379292.16380.16.camel@sayao-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[1] Summary:

Kernel Reports Oops: 0002 [1] SMP and the system becomes unstable

[2] Full Description:

Sometimes, randomly i get this Oops message and the system becomes
unstable. By unstable i mean all applications segmentation faults when i
execute (after the Oops). Sometimes X crashes, sometimes the machine
just reboots (the reboot might be other problem tho).

This happens with kernel 2.6.20 and with 2.6.21-rc7. Was happening with
2.6.20 so i tried 2.6.21-rc7 and this also happens.

sayao@sayao-desktop:/var/log$ uname -a
Linux sayao-desktop 2.6.21-rc7-sayao #2 SMP Mon Apr 16 22:11:36 BRT 2007
x86_64 GNU/Linux

Here is the log:

Apr 22 21:44:33 sayao-desktop kernel: [18641.553890] Unable to handle
kernel paging request at ffffffff00003e82 RIP:
Apr 22 21:44:33 sayao-desktop kernel: [18641.553899]  [__alloc_skb
+188/321] __alloc_skb+0xbc/0x141
Apr 22 21:44:33 sayao-desktop kernel: [18641.553911] PGD 203027 PUD 0
Apr 22 21:44:33 sayao-desktop kernel: [18641.553915] Oops: 0002 [1] SMP
Apr 22 21:44:33 sayao-desktop kernel: [18641.553919] CPU 0
Apr 22 21:44:33 sayao-desktop kernel: [18641.553922] Modules linked in:
binfmt_misc rfcomm l2cap bluetooth i915 drm ppdev capability commoncap
acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_conservative
cpufreq_ondemand cpufreq_powersave freq_table asus_acpi container sbs
i2c_ec i2c_core battery video dock ac button ipv6 lp fuse snd_hda_intel
snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq psmouse
snd_timer snd_seq_device snd parport_pc parport shpchp serio_raw pcspkr
soundcore snd_page_alloc iTCO_wdt iTCO_vendor_support pci_hotplug
intel_agp af_packet evdev tsdev ext3 jbd mbcache sg ide_cd cdrom sd_mod
ata_generic usbhid hid ata_piix libata scsi_mod e100 mii ehci_hcd
generic piix uhci_hcd usbcore thermal processor fan
Apr 22 21:44:33 sayao-desktop kernel: [18641.553997] Pid: 13805, comm:
evolution Not tainted 2.6.21-rc7-sayao #2
Apr 22 21:44:33 sayao-desktop kernel: [18641.554001] RIP:
0010:[__alloc_skb+188/321]  [__alloc_skb+188/321] __alloc_skb+0xbc/0x141
Apr 22 21:44:33 sayao-desktop kernel: [18641.554007] RSP:
0018:ffff810033169bd8  EFLAGS: 00010246
Apr 22 21:44:33 sayao-desktop kernel: [18641.554011] RAX:
ffffffff00003e82 RBX: ffffffff00000002 RCX: 0000000000000000
Apr 22 21:44:33 sayao-desktop kernel: [18641.554014] RDX:
0000000000000000 RSI: 0000000000000000 RDI: ffff81003b1bfa50
Apr 22 21:44:33 sayao-desktop kernel: [18641.554017] RBP:
0000000000003e80 R08: 0000000000000002 R09: 0000000000000000
Apr 22 21:44:33 sayao-desktop kernel: [18641.554021] R10:
ffff81003b1bf980 R11: 00000000000000d0 R12: ffff81003b1bf980
Apr 22 21:44:33 sayao-desktop kernel: [18641.554024] R13:
ffff81003f2109c0 R14: 00000000000004d0 R15: 0000000000003e80
Apr 22 21:44:33 sayao-desktop kernel: [18641.554028] FS:
00002ad334669ea0(0000) GS:ffffffff8052f000(0000) knlGS:0000000000000000
Apr 22 21:44:33 sayao-desktop kernel: [18641.554032] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
Apr 22 21:44:33 sayao-desktop kernel: [18641.554035] CR2:
ffffffff00003e82 CR3: 0000000027bb3000 CR4: 00000000000006e0
Apr 22 21:44:33 sayao-desktop kernel: [18641.554039] Process evolution
(pid: 13805, threadinfo ffff810033168000, task ffff810009665000)
Apr 22 21:44:33 sayao-desktop kernel: [18641.554042] Stack:
0000000009665000 ffff81002f9f5080 0000000000003e80 0000000000000000
Apr 22 21:44:33 sayao-desktop kernel: [18641.554049]  00000000000004d0
ffff810033169ce4 0000000000003e80 ffffffff803a6d82
Apr 22 21:44:33 sayao-desktop kernel: [18641.554055]  0000000000000000
0000000000000206 ffffffff80507110 ffff810000dadc50
Apr 22 21:44:33 sayao-desktop kernel: [18641.554061] Call Trace:
Apr 22 21:44:33 sayao-desktop kernel: [18641.554086]
[sock_alloc_send_skb+130/478] sock_alloc_send_skb+0x82/0x1de
Apr 22 21:44:33 sayao-desktop kernel: [18641.554126]
[unix_stream_sendmsg+392/880] unix_stream_sendmsg+0x188/0x370
Apr 22 21:44:33 sayao-desktop kernel: [18641.554181]  [sock_aio_write
+293/313] sock_aio_write+0x125/0x139
Apr 22 21:44:33 sayao-desktop kernel: [18641.554247]  [do_sync_write
+207/277] do_sync_write+0xcf/0x115
Apr 22 21:44:33 sayao-desktop kernel: [18641.554287]
[autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
Apr 22 21:44:33 sayao-desktop kernel: [18641.554352]  [vfs_write
+228/348] vfs_write+0xe4/0x15c
Apr 22 21:44:33 sayao-desktop kernel: [18641.554369]  [sys_write+69/121]
sys_write+0x45/0x79
Apr 22 21:44:33 sayao-desktop kernel: [18641.554393]  [system_call
+126/131] system_call+0x7e/0x83
Apr 22 21:44:33 sayao-desktop kernel: [18641.554434] 
Apr 22 21:44:33 sayao-desktop kernel: [18641.554436] 
Apr 22 21:44:33 sayao-desktop kernel: [18641.554437] Code: c7 00 01 00
00 00 66 c7 40 04 00 00 66 c7 40 06 00 00 66 c7 
Apr 22 21:44:33 sayao-desktop kernel: [18641.554453] RIP  [__alloc_skb
+188/321] __alloc_skb+0xbc/0x141
Apr 22 21:44:33 sayao-desktop kernel: [18641.554458]  RSP
<ffff810033169bd8>
Apr 22 21:44:33 sayao-desktop kernel: [18641.554460] CR2:
ffffffff00003e82


In this case it appears to happen when using evolution but it happens
with other apps too.

CPU INFO:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      :               Intel(R) Pentium(R) D CPU 2.80GHz
stepping        : 4
cpu MHz         : 2400.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips        : 5599.67
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      :               Intel(R) Pentium(R) D CPU 2.80GHz
stepping        : 4
cpu MHz         : 2400.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips        : 5594.90
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:



Dump of assembler code for function __alloc_skb:
0xffffffff8022e029 <__alloc_skb+0>:     push   %r15
0xffffffff8022e02b <__alloc_skb+2>:     push   %r14
0xffffffff8022e02d <__alloc_skb+4>:     push   %r13
0xffffffff8022e02f <__alloc_skb+6>:     push   %r12
0xffffffff8022e031 <__alloc_skb+8>:     push   %rbp
0xffffffff8022e032 <__alloc_skb+9>:     push   %rbx
0xffffffff8022e033 <__alloc_skb+10>:    sub    $0x8,%rsp
0xffffffff8022e037 <__alloc_skb+14>:    mov    %edi,%ebp
0xffffffff8022e039 <__alloc_skb+16>:    mov    %esi,%r14d
0xffffffff8022e03c <__alloc_skb+19>:    mov    %edx,0x4(%rsp)
0xffffffff8022e040 <__alloc_skb+23>:    mov    %ecx,%ebx
0xffffffff8022e042 <__alloc_skb+25>:    test   %edx,%edx
0xffffffff8022e044 <__alloc_skb+27>:    je     0xffffffff8022e04f
<__alloc_skb+38>
0xffffffff8022e046 <__alloc_skb+29>:    mov    3235539(%rip),%r13
# 0xffffffff80543f20 <skbuff_fclone_cache>
0xffffffff8022e04d <__alloc_skb+36>:    jmp    0xffffffff8022e056
<__alloc_skb+45>
0xffffffff8022e04f <__alloc_skb+38>:    mov    3235522(%rip),%r13
# 0xffffffff80543f18 <skbuff_head_cache>
0xffffffff8022e056 <__alloc_skb+45>:    mov    %r14d,%esi
0xffffffff8022e059 <__alloc_skb+48>:    and    $0xfffffffffffffffe,%esi
0xffffffff8022e05c <__alloc_skb+51>:    mov    %ebx,%edx
0xffffffff8022e05e <__alloc_skb+53>:    mov    %r13,%rdi
0xffffffff8022e061 <__alloc_skb+56>:    callq  0xffffffff802c7a76
<kmem_cache_alloc_node>
0xffffffff8022e066 <__alloc_skb+61>:    test   %rax,%rax
0xffffffff8022e069 <__alloc_skb+64>:    je     0xffffffff8022e155
<__alloc_skb+300>
0xffffffff8022e06f <__alloc_skb+70>:    mov    %rax,%r12
---Type <return> to continue, or q <return> to quit---
0xffffffff8022e072 <__alloc_skb+73>:    add    $0x7f,%ebp
0xffffffff8022e075 <__alloc_skb+76>:    and    $0xffffffffffffff80,%ebp
0xffffffff8022e078 <__alloc_skb+79>:    mov    %ebp,%r15d
0xffffffff8022e07b <__alloc_skb+82>:    lea    0x138(%r15),%rdi
0xffffffff8022e082 <__alloc_skb+89>:    mov    %ebx,%edx
0xffffffff8022e084 <__alloc_skb+91>:    mov    %r14d,%esi
0xffffffff8022e087 <__alloc_skb+94>:    callq  0xffffffff802c7b37
<__kmalloc_node>
0xffffffff8022e08c <__alloc_skb+99>:    mov    %rax,%rbx
0xffffffff8022e08f <__alloc_skb+102>:   test   %rax,%rax
0xffffffff8022e092 <__alloc_skb+105>:   je     0xffffffff8022e14a
<__alloc_skb+289>
0xffffffff8022e098 <__alloc_skb+111>:   mov    $0xd0,%edx
0xffffffff8022e09d <__alloc_skb+116>:   xor    %esi,%esi
0xffffffff8022e09f <__alloc_skb+118>:   mov    %r12,%rdi
0xffffffff8022e0a2 <__alloc_skb+121>:   callq  0xffffffff80260170
<memset>
0xffffffff8022e0a7 <__alloc_skb+126>:   lea    0xf8(%rbp),%eax
0xffffffff8022e0ad <__alloc_skb+132>:   mov    %eax,0xd0(%r12)
0xffffffff8022e0b5 <__alloc_skb+140>:   movl   $0x1,0xd4(%r12)
0xffffffff8022e0c1 <__alloc_skb+152>:   mov    %rbx,0xd8(%r12)
0xffffffff8022e0c9 <__alloc_skb+160>:   mov    %rbx,0xe0(%r12)
0xffffffff8022e0d1 <__alloc_skb+168>:   mov    %rbx,0xe8(%r12)
0xffffffff8022e0d9 <__alloc_skb+176>:   lea    (%rbx,%r15,1),%rax
0xffffffff8022e0dd <__alloc_skb+180>:   mov    %rax,0xf0(%r12)
0xffffffff8022e0e5 <__alloc_skb+188>:   movl   $0x1,(%rax)
0xffffffff8022e0eb <__alloc_skb+194>:   movw   $0x0,0x4(%rax)
0xffffffff8022e0f1 <__alloc_skb+200>:   movw   $0x0,0x6(%rax)
0xffffffff8022e0f7 <__alloc_skb+206>:   movw   $0x0,0x8(%rax)
0xffffffff8022e0fd <__alloc_skb+212>:   movw   $0x0,0xa(%rax)
---Type <return> to continue, or q <return> to quit---
0xffffffff8022e103 <__alloc_skb+218>:   movl   $0x0,0xc(%rax)
0xffffffff8022e10a <__alloc_skb+225>:   movq   $0x0,0x10(%rax)
0xffffffff8022e112 <__alloc_skb+233>:   mov    0x4(%rsp),%esi
0xffffffff8022e116 <__alloc_skb+237>:   test   %esi,%esi
0xffffffff8022e118 <__alloc_skb+239>:   je     0xffffffff8022e158
<__alloc_skb+303>
0xffffffff8022e11a <__alloc_skb+241>:   lea    0xf8(%r12),%rdx
0xffffffff8022e122 <__alloc_skb+249>:   movzbl 0x9d(%r12),%eax
0xffffffff8022e12b <__alloc_skb+258>:   and    $0xe7,%al
0xffffffff8022e12d <__alloc_skb+260>:   or     $0x8,%al
0xffffffff8022e12f <__alloc_skb+262>:   mov    %al,0x9d(%r12)
0xffffffff8022e137 <__alloc_skb+270>:   movl   $0x1,0xf8(%rdx)
0xffffffff8022e141 <__alloc_skb+280>:   andb   $0xe7,0x9d(%rdx)
0xffffffff8022e148 <__alloc_skb+287>:   jmp    0xffffffff8022e158
<__alloc_skb+303>
0xffffffff8022e14a <__alloc_skb+289>:   mov    %r12,%rsi
0xffffffff8022e14d <__alloc_skb+292>:   mov    %r13,%rdi
0xffffffff8022e150 <__alloc_skb+295>:   callq  0xffffffff8020746f
<kmem_cache_free>
0xffffffff8022e155 <__alloc_skb+300>:   xor    %r12d,%r12d
0xffffffff8022e158 <__alloc_skb+303>:   mov    %r12,%rax
0xffffffff8022e15b <__alloc_skb+306>:   add    $0x8,%rsp
0xffffffff8022e15f <__alloc_skb+310>:   pop    %rbx
0xffffffff8022e160 <__alloc_skb+311>:   pop    %rbp
0xffffffff8022e161 <__alloc_skb+312>:   pop    %r12
0xffffffff8022e163 <__alloc_skb+314>:   pop    %r13
0xffffffff8022e165 <__alloc_skb+316>:   pop    %r14
0xffffffff8022e167 <__alloc_skb+318>:   pop    %r15
0xffffffff8022e169 <__alloc_skb+320>:   retq   


My hardware:

00:00.0 Host bridge: Intel Corporation 82946GZ/PL/GL Memory Controller
Hub (rev 02)
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82946GZ/GL
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at 50100000 (32-bit, non-prefetchable)
[size=1M]
        Region 2: Memory at 40000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 20e0 [size=8]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
        Subsystem: Intel Corporation Unknown device a201
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 50200000 (64-bit, non-prefetchable)
[size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown,
Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50300000-503fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1,
Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 1, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee00000  Data: 4061
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device
0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50400000-504fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1,
Port 3
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 3, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee00000  Data: 4069
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device
0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50500000-505fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1,
Port 4
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 4, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee00000  Data: 4071
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device
0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at 2080 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at 2060 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at 2040 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 16
        Region 4: I/O ports at 2020 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at 50204400 (32-bit, non-prefetchable)
[size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: 50000000-500fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Intel Corporation Unknown device
5354

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
Interface Bridge (rev 01)
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 20b0 [size=16]

00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
Serial ATA Storage Controller IDE (rev 01) (prog-if 8f [Master SecP SecO
PriP PriO])
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at 20c8 [size=8]
        Region 1: I/O ports at 20ec [size=4]
        Region 2: I/O ports at 20c0 [size=8]
        Region 3: I/O ports at 20e8 [size=4]
        Region 4: I/O ports at 20a0 [size=16]
        Region 5: Memory at 50204000 (32-bit, non-prefetchable)
[size=1K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 01)
        Subsystem: Intel Corporation Unknown device 5354
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at 2000 [size=32]

04:08.0 Ethernet controller: Intel Corporation PRO/100 VE Network
Connection (rev 01)
        Subsystem: Intel Corporation Unknown device 0001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at 50000000 (32-bit, non-prefetchable)
[size=4K]
        Region 1: I/O ports at 1000 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1
+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-



Sorry for the long e-mail. Hope it helps

Thanks

Thiago M. Sayão.

