Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbXFYJQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbXFYJQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXFYJQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:16:26 -0400
Received: from phenix.kipt.kharkov.ua ([193.239.180.1]:40564 "EHLO
	phenix.kipt.kharkov.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXFYJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:16:25 -0400
Message-ID: <467F7F46.6050701@kipt.kharkov.ua>
Date: Mon, 25 Jun 2007 11:39:34 +0300
From: "Andrew A. Razdolsky" <rand@kipt.kharkov.ua>
Organization: NSC KIPT NOC
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops: 2.6.20.x
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

=====================================================================================
0. cat /etc/slackware-version
Slackware 11.0.0 (x86_64)
=====================================================================================


=====================================================================================
1. Oops dmesg info

wapper: page allocation failure. order:1, mode:0x20

Call Trace:
  <IRQ>  [<ffffffff802534d2>] __alloc_pages+0x2b1/0x2c8
  [<ffffffff8026bb00>] cache_alloc_refill+0x2b5/0x526
  [<ffffffff8026bf29>] __kmalloc+0x6f/0x76
  [<ffffffff803d32b3>] __alloc_skb+0x6b/0x147
  [<ffffffff80406207>] tcp_collapse+0x157/0x351
  [<ffffffff80406581>] tcp_prune_queue+0x180/0x291
  [<ffffffff8040687a>] tcp_data_queue+0x1e8/0xb78
  [<ffffffff80407e02>] tcp_rcv_established+0x84e/0x8db
  [<ffffffff8040f539>] tcp_v4_do_rcv+0x40/0x342
  [<ffffffff803ee8c8>] nf_iterate+0x57/0x8c
  [<ffffffff8040fe22>] tcp_v4_rcv+0x5e7/0x98f
  [<ffffffff803f4692>] ip_local_deliver+0x19c/0x266
  [<ffffffff803f4ea1>] ip_rcv+0x4c8/0x50f
  [<ffffffff803d98b0>] netif_receive_skb+0x1cc/0x1e4
  [<ffffffff8800471a>] :via_rhine:rhine_napipoll+0x3b5/0x590
  [<ffffffff803d9ab5>] net_rx_action+0x9e/0x1ad
  [<ffffffff8022ed46>] __do_softirq+0x6e/0xe7
  [<ffffffff8020a99c>] call_softirq+0x1c/0x28
  [<ffffffff8020c730>] do_softirq+0x4a/0xbe
  [<ffffffff8020c6c1>] do_IRQ+0xc7/0xec
  [<ffffffff80207d07>] mwait_idle+0x0/0x4e
  [<ffffffff80209d21>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffff80207d46>] mwait_idle+0x3f/0x4e
  [<ffffffff80207ca6>] cpu_idle+0x63/0x82
  [<ffffffff805577d0>] start_kernel+0x289/0x295
  [<ffffffff80557190>] _sinittext+0x190/0x19f

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 
usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 
usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 160   Cold: hi:   62, btch:  15 
usd:  56
CPU    1: Hot: hi:  186, btch:  31 usd: 164   Cold: hi:   62, btch:  15 
usd:   2
Active:214098 inactive:17540 dirty:401 writeback:0 unstable:0
  free:1627 slab:18975 mapped:1948 pagetables:845 bounce:0
DMA free:3992kB min:44kB low:52kB high:64kB active:8152kB inactive:0kB 
present:11860kB pages_scanned:224 all_unreclaimable? no
lowmem_reserve[]: 0 993 993
DMA32 free:2516kB min:4008kB low:5008kB high:6012kB active:848240kB 
inactive:70160kB present:1016940kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 6*4kB 0*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 
1*2048kB 0*4096kB = 3992kB
DMA32: 458*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 
0*1024kB 0*2048kB 0*4096kB = 2576kB
Swap cache: add 190983, delete 148244, find 251285/275293, race 0+32
Free swap  = 3795040kB
Total swap = 4008120kB
Free swap:       3795040kB
261855 pages of RAM
5004 reserved pages
43656 pages shared
42739 pages swap cached
=====================================================================================

=====================================================================================
2. scripts/ver_linux

Linux proxy 2.6.21.3 #1 SMP Mon Jun 4 18:42:35 EEST 2007 x86_64 x86_64 
x86_64 GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.16.92
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
xfsprogs               2.8.10
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Kbd                    85:
Sh-utils               5.97
Modules Loaded         nls_koi8_r isofs zlib_inflate loop tun nfs 
xt_multiport ipt_REJECT xt_state xt_limit xt_TCPMSS xt_tcpudp 
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink 
iptable_filter ip_tables x_tables ppp_async crc_ccitt ppp_generic slhc 
sch_sfq ip_gre nfsd exportfs lockd sunrpc r8168 via_rhine mii

=====================================================================================

=====================================================================================
3. lspci

00:00.0 Host bridge: Intel Corporation 945G/GZ/P/PL Express Memory 
Controller Hub (rev 81)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 (rev 01)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 3 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 4 (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC 
Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE 
Controller (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) 
Serial ATA Storage Controller IDE (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
(rev 01)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
03:00.0 SATA controller: JMicron Technologies, Inc. JMB361 AHCI/IDE (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMB361 AHCI/IDE (rev 02)
04:01.0 Ethernet controller: VIA Technologies, Inc. VT6105 [Rhine-III] 
(rev 8b)
04:02.0 Ethernet controller: VIA Technologies, Inc. VT6105 [Rhine-III] 
(rev 8b)
04:05.0 Ethernet controller: VIA Technologies, Inc. VT6105 [Rhine-III] 
(rev 8b)
=====================================================================================

=====================================================================================
4. cat /proc/cpuinfo

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      :               Intel(R) Pentium(R) D CPU 3.00GHz
stepping        : 5
cpu MHz         : 3013.417
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
bogomips        : 6031.01
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      :               Intel(R) Pentium(R) D CPU 3.00GHz
stepping        : 5
cpu MHz         : 3013.417
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
bogomips        : 6026.86
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:
=====================================================================================



    -- Best Regards,
          Andrew A. Razdolsky

