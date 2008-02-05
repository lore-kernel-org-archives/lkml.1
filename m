Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYBEKSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYBEKSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbYBEKSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:18:17 -0500
Received: from asmodis.mb-net.net ([193.22.253.2]:51865 "EHLO
	asmodis.mb-net.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbYBEKSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:18:12 -0500
X-Greylist: delayed 826 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 05:18:12 EST
Date: Tue, 5 Feb 2008 11:04:23 +0100
From: Michael Bussmann <bus@mb-net.net>
To: linux-kernel@vger.kernel.org
Subject: OOM killer on idle machine
Message-ID: <20080205100423.GA12009@ruf099.fkie.fgan.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
X-message-flag: Please send plain text messages only. Thank you.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm currently experiencing strange OOM errors on a machine with 8 GB RAM,
16 GB swap (Xeon 5150).  After about 5 days uptime the box starts to
spit out OOM messages.

The box is mostly idle, so I haven't got any idea what is consuming memory.
Looking at the output of free it seems that the box has plenty of memory
left, so I'd be thankful if anybody could shed some light on this issue.

Thanks in advance for any information.

Cheers,
MB

PS: Please CC me in replies

Kernel: 2.6.23.14 (also happened with 2.6.23.9 (self-compiled), both with
SLUB) and linux-image-2.6.22-3-686-bigmem (Debian kernel).
RAM: 8 GB
HDD: 2 x 320 GB SATA AHCI (Software RAID-1)
     6 x 320 GB SATA 3Ware 9650SE-8LPML (3w_9xxx driver)

Output of free during OOM-situation:
             total       used       free     shared    buffers     cached
Mem:       8300144     910360    7389784          0      10588      39460
-/+ buffers/cache:     860312    7439832
Swap:     16777208          0   16777208

First OOM message in syslog:

Feb  4 16:15:15 kernel: df_inode invoked oom-killer: gfp_mask=3D0xd0, order=
=3D0, oomkilladj=3D0
Feb  4 16:15:16 kernel:  [<c01408cb>] out_of_memory+0x69/0x18e
Feb  4 16:15:16 kernel:  [<c0141eca>] __alloc_pages+0x1fc/0x283
Feb  4 16:15:16 kernel:  [<c0141f8a>] __get_free_pages+0x39/0x47
Feb  4 16:15:16 kernel:  [<c011bbc8>] copy_process+0x89/0x1051
Feb  4 16:15:16 kernel: df_inode invoked oom-killer: gfp_mask=3D0x40d0, ord=
er=3D1, oomkilladj=3D0
Feb  4 16:15:16 kernel:  [<c01408cb>] out_of_memory+0x69/0x18e
Feb  4 16:15:16 kernel:  [<c0141eca>] __alloc_pages+0x1fc/0x283
Feb  4 16:15:16 kernel:  [<c0156ef4>] __slab_alloc+0x178/0x475
Feb  4 16:15:16 kernel:  [<c0157307>] kmem_cache_alloc+0x3c/0x83
Feb  4 16:15:16 kernel:  [<c0115087>] pgd_alloc+0x58/0xb9
Feb  4 16:15:16 kernel:  [<c0115087>] pgd_alloc+0x58/0xb9
Feb  4 16:15:16 kernel:  [<c011b9dd>] mm_init+0xa1/0xc3
Feb  4 16:15:16 kernel:  [<c015d6d6>] bprm_mm_init+0xf/0x14f
Feb  4 16:15:16 kernel:  [<c015e4f2>] do_execve+0x62/0x16a
Feb  4 16:15:16 kernel:  [<c01011a8>] sys_execve+0x2f/0x7b
Feb  4 16:15:16 kernel:  [<c010285a>] sysenter_past_esp+0x5f/0x85
Feb  4 16:15:16 kernel:  [<c0330000>] gss_refresh+0xca/0x103
Feb  4 16:15:16 kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Feb  4 16:15:16 kernel: Mem-info:
Feb  4 16:15:16 kernel: DMA per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: Normal per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold:=
 hi:   62, btch:  15 usd:  55
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  28   Cold:=
 hi:   62, btch:  15 usd:  52
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  31   Cold:=
 hi:   62, btch:  15 usd:  57
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  36   Cold:=
 hi:   62, btch:  15 usd:  52
Feb  4 16:15:16 kernel: HighMem per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  74   Cold:=
 hi:   62, btch:  15 usd:   6
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 144   Cold:=
 hi:   62, btch:  15 usd:  13
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  90   Cold:=
 hi:   62, btch:  15 usd:  10
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 132   Cold:=
 hi:   62, btch:  15 usd:  12
Feb  4 16:15:16 kernel: Active:23868 inactive:10724 dirty:2 writeback:0 uns=
table:0
Feb  4 16:15:16 kernel:  free:1832856 slab:4611 mapped:5566 pagetables:427 =
bounce:0
Feb  4 16:15:16 kernel: DMA free:3540kB min:68kB low:84kB high:100kB active=
:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 873 9636 9636
Feb  4 16:15:16 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616k=
B active:7584kB inactive:2960kB present:894080kB pages_scanned:20511 all_un=
reclaimable? yes
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 0 70104 70104
Feb  4 16:15:16 kernel: HighMem free:7324192kB min:512kB low:9912kB high:19=
316kB active:87888kB inactive:39936kB present:8973312kB pages_scanned:0 all=
_unreclaimable? no
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 0 0 0
Feb  4 16:15:16 kernel: DMA: 3*4kB 0*8kB 2*16kB 1*32kB 0*64kB 1*128kB 1*256=
kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 3532kB
Feb  4 16:15:16 kernel: Normal: 1*4kB 21*8kB 28*16kB 4*32kB 3*64kB 1*128kB =
1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB =3D 3884kB
Feb  4 16:15:16 kernel: HighMem: 3671*4kB 3883*8kB 3149*16kB 2519*32kB 1749=
*64kB 930*128kB 487*256kB 159*512kB 221*1024kB 146*2048kB 1510*4096kB =3D 7=
324068kB
Feb  4 16:15:16 kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Feb  4 16:15:16 kernel: Free swap  =3D 16777208kB
Feb  4 16:15:16 kernel: Total swap =3D 16777208kB
Feb  4 16:15:16 kernel: Free swap:       16777208kB
Feb  4 16:15:16 kernel:  [<c011cdb9>] do_fork+0x9a/0x17a
Feb  4 16:15:16 kernel:  [<c0100cb5>] sys_clone+0x36/0x3b
Feb  4 16:15:16 kernel:  [<c010285a>] sysenter_past_esp+0x5f/0x85
Feb  4 16:15:16 kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Feb  4 16:15:16 kernel: Mem-info:
Feb  4 16:15:16 kernel: DMA per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: Normal per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold:=
 hi:   62, btch:  15 usd:  55
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  28   Cold:=
 hi:   62, btch:  15 usd:  52
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  31   Cold:=
 hi:   62, btch:  15 usd:  57
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  36   Cold:=
 hi:   62, btch:  15 usd:  52
Feb  4 16:15:16 kernel: HighMem per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  74   Cold:=
 hi:   62, btch:  15 usd:   6
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 144   Cold:=
 hi:   62, btch:  15 usd:  13
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  90   Cold:=
 hi:   62, btch:  15 usd:  10
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 132   Cold:=
 hi:   62, btch:  15 usd:  12
Feb  4 16:15:16 kernel: Active:23868 inactive:10724 dirty:2 writeback:0 uns=
table:0
Feb  4 16:15:16 kernel:  free:1832856 slab:4611 mapped:5566 pagetables:427 =
bounce:0
Feb  4 16:15:16 kernel: DMA free:3540kB min:68kB low:84kB high:100kB active=
:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 873 9636 9636
Feb  4 16:15:16 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616k=
B active:7584kB inactive:2960kB present:894080kB pages_scanned:20511 all_un=
reclaimable? yes
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 0 70104 70104
Feb  4 16:15:16 kernel: HighMem free:7324192kB min:512kB low:9912kB high:19=
316kB active:87888kB inactive:39936kB present:8973312kB pages_scanned:0 all=
_unreclaimable? no
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 0 0 0
Feb  4 16:15:16 kernel: DMA: 3*4kB 0*8kB 2*16kB 1*32kB 0*64kB 1*128kB 1*256=
kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 3532kB
Feb  4 16:15:16 kernel: Normal: 1*4kB 21*8kB 28*16kB 4*32kB 3*64kB 1*128kB =
1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB =3D 3884kB
Feb  4 16:15:16 kernel: HighMem: 3671*4kB 3883*8kB 3149*16kB 2519*32kB 1749=
*64kB 930*128kB 487*256kB 159*512kB 221*1024kB 146*2048kB 1510*4096kB =3D 7=
324068kB
Feb  4 16:15:16 kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Feb  4 16:15:16 kernel: Free swap  =3D 16777208kB
Feb  4 16:15:16 kernel: Total swap =3D 16777208kB
Feb  4 16:15:16 kernel: Free swap:       16777208kB
Feb  4 16:15:16 kernel: 2490368 pages of RAM
Feb  4 16:15:16 kernel: 2260992 pages of HIGHMEM
Feb  4 16:15:16 kernel: 415332 reserved pages
Feb  4 16:15:16 kernel: 24136 pages shared
Feb  4 16:15:16 kernel: 0 pages swap cached
Feb  4 16:15:16 kernel: 2 pages dirty
Feb  4 16:15:16 kernel: 0 pages writeback
Feb  4 16:15:16 kernel: 5566 pages mapped
Feb  4 16:15:16 kernel: 4611 pages slab
Feb  4 16:15:16 kernel: 427 pages pagetables

Feb  4 16:15:16 kernel: Out of memory: kill process 2933 (sh) score 32755 o=
r a child
Feb  4 16:15:16 kernel: Killed process 2934 (java)
Feb  4 16:15:16 kernel: 2490368 pages of RAM
Feb  4 16:15:16 kernel: 2260992 pages of HIGHMEM
Feb  4 16:15:16 kernel: 415332 reserved pages
Feb  4 16:15:16 kernel: 24136 pages shared
Feb  4 16:15:16 kernel: 0 pages swap cached
Feb  4 16:15:16 kernel: 2 pages dirty
Feb  4 16:15:16 kernel: 0 pages writeback
Feb  4 16:15:16 kernel: 5566 pages mapped
Feb  4 16:15:16 kernel: 4611 pages slab
Feb  4 16:15:16 kernel: 427 pages pagetables

Feb  4 16:15:16 kernel: Out of memory: kill process 13047 (slapd) score 819=
3 or a child
Feb  4 16:15:16 kernel: Killed process 13047 (slapd)
Feb  4 16:15:16 kernel: df_inode invoked oom-killer: gfp_mask=3D0xd0, order=
=3D0, oomkilladj=3D0
Feb  4 16:15:16 kernel:  [<c01408cb>] out_of_memory+0x69/0x18e
Feb  4 16:15:16 kernel:  [<c0141eca>] __alloc_pages+0x1fc/0x283
Feb  4 16:15:16 kernel:  [<c0141f8a>] __get_free_pages+0x39/0x47
Feb  4 16:15:16 kernel:  [<c011bbc8>] copy_process+0x89/0x1051
Feb  4 16:15:16 kernel:  [<c011cdb9>] do_fork+0x9a/0x17a
Feb  4 16:15:16 kernel:  [<c0100cb5>] sys_clone+0x36/0x3b
Feb  4 16:15:16 kernel:  [<c010285a>] sysenter_past_esp+0x5f/0x85
Feb  4 16:15:16 kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Feb  4 16:15:16 kernel: Mem-info:
Feb  4 16:15:16 kernel: DMA per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:15:16 kernel: Normal per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  25   Cold:=
 hi:   62, btch:  15 usd:  55
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  28   Cold:=
 hi:   62, btch:  15 usd:  52
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  33   Cold:=
 hi:   62, btch:  15 usd:  57
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  36   Cold:=
 hi:   62, btch:  15 usd:  52
Feb  4 16:15:16 kernel: HighMem per-cpu:
Feb  4 16:15:16 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  74   Cold:=
 hi:   62, btch:  15 usd:   6
Feb  4 16:15:16 kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 144   Cold:=
 hi:   62, btch:  15 usd:  13
Feb  4 16:15:16 kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 179   Cold:=
 hi:   62, btch:  15 usd:  10
Feb  4 16:15:16 kernel: CPU    3: Hot: hi:  186, btch:  31 usd: 132   Cold:=
 hi:   62, btch:  15 usd:  12
Feb  4 16:15:16 kernel: Active:23211 inactive:10724 dirty:2 writeback:0 uns=
table:0
Feb  4 16:15:16 kernel:  free:1833444 slab:4611 mapped:5201 pagetables:427 =
bounce:0
Feb  4 16:15:16 kernel: DMA free:3540kB min:68kB low:84kB high:100kB active=
:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 873 9636 9636
Feb  4 16:15:16 kernel: Normal free:3692kB min:3744kB low:4680kB high:5616k=
B active:7584kB inactive:2960kB present:894080kB pages_scanned:20511 all_un=
reclaimable? yes
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 0 70104 70104
Feb  4 16:15:16 kernel: HighMem free:7326544kB min:512kB low:9912kB high:19=
316kB active:85260kB inactive:39936kB present:8973312kB pages_scanned:0 all=
_unreclaimable? no
Feb  4 16:15:16 kernel: lowmem_reserve[]: 0 0 0 0
Feb  4 16:15:16 kernel: DMA: 3*4kB 0*8kB 2*16kB 1*32kB 0*64kB 1*128kB 1*256=
kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 3532kB
Feb  4 16:15:16 kernel: Normal: 1*4kB 21*8kB 28*16kB 4*32kB 3*64kB 1*128kB =
1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB =3D 3884kB
Feb  4 16:15:16 kernel: HighMem: 3864*4kB 3907*8kB 3148*16kB 2503*32kB 1737=
*64kB 939*128kB 489*256kB 159*512kB 220*1024kB 147*2048kB 1510*4096kB =3D 7=
326424kB
Feb  4 16:15:16 kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Feb  4 16:15:16 kernel: Free swap  =3D 16777208kB
Feb  4 16:15:16 kernel: Total swap =3D 16777208kB
Feb  4 16:15:16 kernel: Free swap:       16777208kB

SysRQ+m shows:

Feb  4 16:35:56 kernel: SysRq : Show Memory
Feb  4 16:35:56 kernel: Mem-info:
Feb  4 16:35:56 kernel: DMA per-cpu:
Feb  4 16:35:56 kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0
Feb  4 16:35:56 kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold:=
 hi:    0, btch:   1 usd:   0                                              =
                                    Feb  4 16:35:56 kernel: CPU    2: Hot: =
hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0          =
                                                                        Feb=
  4 16:35:56 kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi=
:    0, btch:   1 usd:   0
Feb  4 16:35:56 kernel: Normal per-cpu:
Feb  4 16:35:56 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  26   Cold:=
 hi:   62, btch:  15 usd:  51
Feb  4 16:35:56 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  10   Cold:=
 hi:   62, btch:  15 usd:  47
Feb  4 16:35:56 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  25   Cold:=
 hi:   62, btch:  15 usd:  50
Feb  4 16:35:56 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:   7   Cold:=
 hi:   62, btch:  15 usd:  59
Feb  4 16:35:56 kernel: HighMem per-cpu:
Feb  4 16:35:56 kernel: CPU    0: Hot: hi:  186, btch:  31 usd:   6   Cold:=
 hi:   62, btch:  15 usd:   6
Feb  4 16:35:56 kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  15   Cold:=
 hi:   62, btch:  15 usd:  14
Feb  4 16:35:56 kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  98   Cold:=
 hi:   62, btch:  15 usd:   4
Feb  4 16:35:56 kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  47   Cold:=
 hi:   62, btch:  15 usd:   3
Feb  4 16:35:56 kernel: Active:13145 inactive:7163 dirty:0 writeback:0 unst=
able:0
Feb  4 16:35:56 kernel:  free:1847537 slab:4426 mapped:3787 pagetables:360 =
bounce:0
Feb  4 16:35:56 kernel: DMA free:3560kB min:68kB low:84kB high:100kB active=
:8kB inactive:0kB present:16256kB pages_scanned:108 all_unreclaimable? yes
Feb  4 16:35:56 kernel: lowmem_reserve[]: 0 873 9636 9636
Feb  4 16:35:56 kernel: Normal free:3980kB min:3744kB low:4680kB high:5616k=
B active:5396kB inactive:5008kB present:894080kB pages_scanned:20561 all_un=
reclaimable? yes
Feb  4 16:35:56 kernel: lowmem_reserve[]: 0 0 70104 70104
Feb  4 16:35:56 kernel: HighMem free:7382608kB min:512kB low:9912kB high:19=
316kB active:47176kB inactive:23644kB present:8973312kB pages_scanned:0 all=
_unreclaimable? no
Feb  4 16:35:56 kernel: lowmem_reserve[]: 0 0 0 0
Feb  4 16:35:56 kernel: DMA: 2*4kB 4*8kB 2*16kB 1*32kB 0*64kB 1*128kB 1*256=
kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 3560kB
Feb  4 16:35:56 kernel: Normal: 75*4kB 10*8kB 21*16kB 4*32kB 3*64kB 1*128kB=
 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB =3D 3980kB
Feb  4 16:35:56 kernel: HighMem: 1036*4kB 2516*8kB 1914*16kB 1571*32kB 1176=
*64kB 785*128kB 533*256kB 336*512kB 230*1024kB 148*2048kB 1527*4096kB =3D 7=
382608kB
Feb  4 16:35:56 kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Feb  4 16:35:56 kernel: Free swap  =3D 16777208kB
Feb  4 16:35:56 kernel: Total swap =3D 16777208kB
Feb  4 16:35:56 kernel: Free swap:       16777208kB
Feb  4 16:35:56 kernel: 2490368 pages of RAM
Feb  4 16:35:56 kernel: 2260992 pages of HIGHMEM
Feb  4 16:35:56 kernel: 415332 reserved pages
Feb  4 16:35:56 kernel: 25392 pages shared
Feb  4 16:35:56 kernel: 0 pages swap cached
Feb  4 16:35:56 kernel: 0 pages dirty
Feb  4 16:35:56 kernel: 0 pages writeback
Feb  4 16:35:56 kernel: 3787 pages mapped
Feb  4 16:35:56 kernel: 4426 pages slab
Feb  4 16:35:56 kernel: 360 pages pagetables

--=20
Michael Bussmann <bus@mb-net.net>
BOFH excuse #101:

Collapsed Backbone

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHqDSnMOF/Y/9ZWXkRAkMqAJ9y66YkagxCLO/S9Rrzvq94nmVWFACdGtaJ
YQiRlkg/wp7pi6lJZCLwmV0=
=LtwH
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
