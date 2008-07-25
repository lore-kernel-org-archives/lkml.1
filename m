Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYGYHUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYGYHUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYGYHUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:20:24 -0400
Received: from mail7.tpgi.com.au ([203.12.160.103]:39411 "EHLO
	mail7.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYGYHUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:20:23 -0400
X-TPG-Antivirus: Passed
Date: Fri, 25 Jul 2008 17:20:15 +1000
From: Alex Samad <alex@samad.com.au>
To: linux-kernel@vger.kernel.org
Subject: page swap allocation error/failure in 2.6.25
Message-ID: <20080725072015.GA17688@samad.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I reported this earlier (http://lkml.org/lkml/2008/7/13/41) which I had
attributed to miss match mtu and route information.

But I have started to see the errors again.


Jul 25 13:07:07 hufpuf kernel: [269282.912693] swapper: page allocation
failure. order:2, mode:0x20
Jul 25 13:07:07 hufpuf kernel: [269282.912700] Pid: 0, comm: swapper
Tainted: GF        2.6.25-2-amd64 #1
Jul 25 13:07:07 hufpuf kernel: [269282.912703]=20
Jul 25 13:07:07 hufpuf kernel: [269282.912703] Call Trace:
Jul 25 13:07:07 hufpuf kernel: [269282.912705]  <IRQ>
[<ffffffff8027709a>] __alloc_pages+0x2f8/0x312
Jul 25 13:07:07 hufpuf kernel: [269282.912750]  [<ffffffff80294c63>]
kmem_getpages+0xc5/0x193
Jul 25 13:07:07 hufpuf kernel: [269282.912757]  [<ffffffff8029529d>]
fallback_alloc+0x147/0x1c0
Jul 25 13:07:07 hufpuf kernel: [269282.912769]  [<ffffffff80294ed8>]
kmem_cache_alloc_node+0x105/0x138
Jul 25 13:07:07 hufpuf kernel: [269282.912777]  [<ffffffff803ac4ae>]
__alloc_skb+0x64/0x12d
Jul 25 13:07:07 hufpuf kernel: [269282.912794]  [<ffffffff8807b8e6>]
:forcedeth:nv_alloc_rx_optimized+0x57/0x19b
Jul 25 13:07:07 hufpuf kernel: [269282.912806]  [<ffffffff8807db6b>]
:forcedeth:nv_nic_irq_optimized+0x97/0x21a
Jul 25 13:07:07 hufpuf kernel: [269282.912815]  [<ffffffff8026c077>]
handle_IRQ_event+0x2c/0x61
Jul 25 13:07:07 hufpuf kernel: [269282.912823]  [<ffffffff8026d4e6>]
handle_fasteoi_irq+0x90/0xc8
Jul 25 13:07:07 hufpuf kernel: [269282.912832]  [<ffffffff8020f41c>]
do_IRQ+0x6d/0xd9
Jul 25 13:07:07 hufpuf kernel: [269282.912845]  [<ffffffff883f4386>]
:nf_conntrack:tcp_packet+0xa49/0xa87
Jul 25 13:07:07 hufpuf kernel: [269282.912851]  [<ffffffff8020c34d>]
ret_from_intr+0x0/0x19
Jul 25 13:07:07 hufpuf kernel: [269282.912863]  [<ffffffff883f375e>]
:nf_conntrack:tcp_pkt_to_tuple+0x0/0x5b
Jul 25 13:07:07 hufpuf kernel: [269282.912879]  [<ffffffff883d8359>]
:ip_tables:ipt_do_table+0x134/0x56b
Jul 25 13:07:07 hufpuf kernel: [269282.912894]  [<ffffffff883d8726>]
:ip_tables:ipt_do_table+0x501/0x56b
Jul 25 13:07:07 hufpuf kernel: [269282.912913]  [<ffffffff803cdd87>]
ip_route_input+0x42/0xe3f
Jul 25 13:07:07 hufpuf kernel: [269282.912924]  [<ffffffff803cae42>]
nf_iterate+0x3f/0x7e
Jul 25 13:07:07 hufpuf kernel: [269282.912931]  [<ffffffff803d07a0>]
ip_local_deliver_finish+0x0/0x1dd
Jul 25 13:07:07 hufpuf kernel: [269282.912936]  [<ffffffff803caede>]
nf_hook_slow+0x5d/0xbe
Jul 25 13:07:07 hufpuf kernel: [269282.912939]  [<ffffffff803d07a0>]
ip_local_deliver_finish+0x0/0x1dd
Jul 25 13:07:07 hufpuf kernel: [269282.912951]  [<ffffffff803d0d45>]
ip_local_deliver+0x5f/0x7a
Jul 25 13:07:07 hufpuf kernel: [269282.912957]  [<ffffffff803d077d>]
ip_rcv_finish+0x315/0x338
Jul 25 13:07:07 hufpuf kernel: [269282.912962]  [<ffffffff803d0ca1>]
ip_rcv+0x23f/0x284
Jul 25 13:07:07 hufpuf kernel: [269282.912970]  [<ffffffff803b0d85>]
netif_receive_skb+0x35f/0x3d8
Jul 25 13:07:07 hufpuf kernel: [269282.912980]  [<ffffffff803b3461>]
process_backlog+0x81/0xeb
Jul 25 13:07:07 hufpuf kernel: [269282.912984]  [<ffffffff802125bb>]
nommu_map_single+0x2b/0x40
Jul 25 13:07:07 hufpuf kernel: [269282.912993]  [<ffffffff803b2e5b>]
net_rx_action+0xab/0x18c
Jul 25 13:07:07 hufpuf kernel: [269282.913002]  [<ffffffff80239a80>]
__do_softirq+0x5c/0xd1
Jul 25 13:07:07 hufpuf kernel: [269282.913005]  [<ffffffff8021de6f>]
ack_apic_level+0x38/0xd8
Jul 25 13:07:07 hufpuf kernel: [269282.913012]  [<ffffffff8020d1ac>]
call_softirq+0x1c/0x28
Jul 25 13:07:07 hufpuf kernel: [269282.913017]  [<ffffffff8020f208>]
do_softirq+0x3c/0x81
Jul 25 13:07:07 hufpuf kernel: [269282.913020]  [<ffffffff802399e0>]
irq_exit+0x3f/0x83
Jul 25 13:07:07 hufpuf kernel: [269282.913024]  [<ffffffff8020f468>]
do_IRQ+0xb9/0xd9
Jul 25 13:07:07 hufpuf kernel: [269282.913030]  [<ffffffff8020c34d>]
ret_from_intr+0x0/0x19
Jul 25 13:07:07 hufpuf kernel: [269282.913032]  <EOI>
[<ffffffff802206e4>] native_safe_halt+0x2/0x3
Jul 25 13:07:07 hufpuf kernel: [269282.913052]  [<ffffffff8020ae94>]
default_idle+0x3b/0x6e
Jul 25 13:07:07 hufpuf kernel: [269282.913054]  [<ffffffff8020ae59>]
default_idle+0x0/0x6e
Jul 25 13:07:07 hufpuf kernel: [269282.913056]  [<ffffffff8020af50>]
cpu_idle+0x89/0xb3
Jul 25 13:07:07 hufpuf kernel: [269282.913077]=20
Jul 25 13:07:07 hufpuf kernel: [269282.913078] Mem-info:
Jul 25 13:07:07 hufpuf kernel: [269282.913079] Node 0 DMA per-cpu:
Jul 25 13:07:07 hufpuf kernel: [269282.913082] CPU    0: hi:    0, btch:
1 usd:   0
Jul 25 13:07:07 hufpuf kernel: [269282.913084] CPU    1: hi:    0, btch:
1 usd:   0
Jul 25 13:07:07 hufpuf kernel: [269282.913085] Node 0 DMA32 per-cpu:
Jul 25 13:07:07 hufpuf kernel: [269282.913087] CPU    0: hi:  186, btch:
31 usd: 169
Jul 25 13:07:07 hufpuf kernel: [269282.913089] CPU    1: hi:  186, btch:
31 usd: 172
Jul 25 13:07:07 hufpuf kernel: [269282.913092] Active:245699
inactive:233841 dirty:132 writeback:0 unstable:0
Jul 25 13:07:07 hufpuf kernel: [269282.913094]  free:5175 slab:19887
mapped:17919 pagetables:4494 bounce:0
Jul 25 13:07:07 hufpuf kernel: [269282.913096] Node 0 DMA free:8032kB
min:28kB low:32kB high:40kB active:2024kB inactive:220kB present:11392kB
pages_scanned:0 all_unreclaimable? no
Jul 25 13:07:07 hufpuf kernel: [269282.913100] lowmem_reserve[]: 0 2004
2004 2004
Jul 25 13:07:07 hufpuf kernel: [269282.913102] Node 0 DMA32 free:12668kB
min:5712kB low:7140kB high:8568kB active:980772kB inactive:935144kB
present:2052260kB pages_scanned:0 all_unreclaimable? no
Jul 25 13:07:07 hufpuf kernel: [269282.913107] lowmem_reserve[]: 0 0 0 0
Jul 25 13:07:07 hufpuf kernel: [269282.913110] Node 0 DMA: 178*4kB
73*8kB 41*16kB 14*32kB 14*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB
1*4096kB =3D 8032kB
Jul 25 13:07:07 hufpuf kernel: [269282.913116] Node 0 DMA32: 1739*4kB
622*8kB 7*16kB 0*32kB 2*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*
2048kB 0*4096kB =3D 12812kB
Jul 25 13:07:07 hufpuf kernel: [269282.913124] 261224 total pagecache
pages
Jul 25 13:07:07 hufpuf kernel: [269282.913125] Swap cache: add 6993,
delete 6407, find 1624/2224
Jul 25 13:07:07 hufpuf kernel: [269282.913127] Free swap  =3D 1956068kB
Jul 25 13:07:07 hufpuf kernel: [269282.913129] Total swap =3D 1959800kB
Jul 25 13:07:07 hufpuf kernel: [269282.913130] Free swap:
1956068kB
Jul 25 13:07:07 hufpuf kernel: [269282.916656] 524272 pages of RAM
Jul 25 13:07:07 hufpuf kernel: [269282.916656] 8334 reserved pages
Jul 25 13:07:07 hufpuf kernel: [269282.916656] 103282 pages shared
Jul 25 13:07:07 hufpuf kernel: [269282.916656] 586 pages swap cached


Jul 25 13:07:07 hufpuf kernel: [269282.965360] xvncviewer: page
allocation failure. order:2, mode:0x20
Jul 25 13:07:07 hufpuf kernel: [269282.965367] Pid: 12313, comm:
xvncviewer Tainted: GF        2.6.25-2-amd64 #1
Jul 25 13:07:07 hufpuf kernel: [269282.965369]=20
Jul 25 13:07:07 hufpuf kernel: [269282.965370] Call Trace:
Jul 25 13:07:07 hufpuf kernel: [269282.965372]  <IRQ>
[<ffffffff8027709a>] __alloc_pages+0x2f8/0x312
Jul 25 13:07:07 hufpuf kernel: [269282.965410]  [<ffffffff80294c63>]
kmem_getpages+0xc5/0x193
Jul 25 13:07:07 hufpuf kernel: [269282.965416]  [<ffffffff8029529d>]
fallback_alloc+0x147/0x1c0
Jul 25 13:07:07 hufpuf kernel: [269282.965428]  [<ffffffff80294ed8>]
kmem_cache_alloc_node+0x105/0x138
Jul 25 13:07:07 hufpuf kernel: [269282.965436]  [<ffffffff803ac4ae>]
__alloc_skb+0x64/0x12d
Jul 25 13:07:07 hufpuf kernel: [269282.965451]  [<ffffffff8807b8e6>]
:forcedeth:nv_alloc_rx_optimized+0x57/0x19b
Jul 25 13:07:07 hufpuf kernel: [269282.965463]  [<ffffffff8807db6b>]
:forcedeth:nv_nic_irq_optimized+0x97/0x21a
Jul 25 13:07:07 hufpuf kernel: [269282.965472]  [<ffffffff8026c077>]
handle_IRQ_event+0x2c/0x61
Jul 25 13:07:07 hufpuf kernel: [269282.965479]  [<ffffffff8026d4e6>]
handle_fasteoi_irq+0x90/0xc8
Jul 25 13:07:07 hufpuf kernel: [269282.965487]  [<ffffffff8020f41c>]
do_IRQ+0x6d/0xd9
Jul 25 13:07:07 hufpuf kernel: [269282.965493]  [<ffffffff8020c34d>]
ret_from_intr+0x0/0x19
Jul 25 13:07:07 hufpuf kernel: [269282.965508]  [<ffffffff883f375e>]
:nf_conntrack:tcp_pkt_to_tuple+0x0/0x5b
Jul 25 13:07:07 hufpuf kernel: [269282.965520]  [<ffffffff80239cd0>]
local_bh_disable+0x13/0x14
Jul 25 13:07:07 hufpuf kernel: [269282.965536]  [<ffffffff883f0691>]
:nf_conntrack:__nf_conntrack_find+0x21/0xfd
Jul 25 13:07:07 hufpuf kernel: [269282.965547]  [<ffffffff883f09ee>]
:nf_conntrack:nf_ct_get_tuple+0x42/0x71
Jul 25 13:07:07 hufpuf kernel: [269282.965561]  [<ffffffff883f0776>]
:nf_conntrack:nf_conntrack_find_get+0x9/0x4d
Jul 25 13:07:07 hufpuf kernel: [269282.965573]  [<ffffffff883f14ee>]
:nf_conntrack:nf_conntrack_in+0x1a4/0x4fe
Jul 25 13:07:07 hufpuf kernel: [269282.965583]  [<ffffffff802950fc>]
cache_grow+0x1c9/0x223
Jul 25 13:07:07 hufpuf kernel: [269282.965603]  [<ffffffff803cae42>]
nf_iterate+0x3f/0x7e
Jul 25 13:07:07 hufpuf kernel: [269282.965610]  [<ffffffff803d2c54>]
dst_output+0x0/0xb
Jul 25 13:07:07 hufpuf kernel: [269282.965615]  [<ffffffff803caede>]
nf_hook_slow+0x5d/0xbe
Jul 25 13:07:07 hufpuf kernel: [269282.965618]  [<ffffffff803d2c54>]
dst_output+0x0/0xb
Jul 25 13:07:07 hufpuf kernel: [269282.965630]  [<ffffffff803d40cb>]
__ip_local_out+0x9b/0x9d
Jul 25 13:07:07 hufpuf kernel: [269282.965634]  [<ffffffff803d40d6>]
ip_local_out+0x9/0x1f
Jul 25 13:07:07 hufpuf kernel: [269282.965638]  [<ffffffff803d4cc5>]
ip_queue_xmit+0x2c2/0x315
Jul 25 13:07:07 hufpuf kernel: [269282.965643]  [<ffffffff8021de6f>]
ack_apic_level+0x38/0xd8
Jul 25 13:07:07 hufpuf kernel: [269282.965650]  [<ffffffff8026d513>]
handle_fasteoi_irq+0xbd/0xc8
Jul 25 13:07:07 hufpuf kernel: [269282.965659]  [<ffffffff803e433f>]
tcp_transmit_skb+0x6ca/0x707
Jul 25 13:07:07 hufpuf kernel: [269282.965673]  [<ffffffff803e3175>]
tcp_rcv_established+0x424/0x6f7
Jul 25 13:07:07 hufpuf kernel: [269282.965683]  [<ffffffff803e861b>]
tcp_v4_do_rcv+0x2c/0x1c6
Jul 25 13:07:07 hufpuf kernel: [269282.965692]  [<ffffffff803e9f48>]
tcp_v4_rcv+0x6da/0x73e
Jul 25 13:07:07 hufpuf kernel: [269282.965704]  [<ffffffff803d08c0>]
ip_local_deliver_finish+0x120/0x1dd
Jul 25 13:07:07 hufpuf kernel: [269282.965709]  [<ffffffff803d077d>]
ip_rcv_finish+0x315/0x338
Jul 25 13:07:07 hufpuf kernel: [269282.965715]  [<ffffffff803d0ca1>]
ip_rcv+0x23f/0x284
Jul 25 13:07:07 hufpuf kernel: [269282.965723]  [<ffffffff803b0d85>]
netif_receive_skb+0x35f/0x3d8
Jul 25 13:07:07 hufpuf kernel: [269282.965733]  [<ffffffff803b3461>]
process_backlog+0x81/0xeb
Jul 25 13:07:07 hufpuf kernel: [269282.965736]  [<ffffffff802125bb>]
nommu_map_single+0x2b/0x40
Jul 25 13:07:07 hufpuf kernel: [269282.965745]  [<ffffffff803b2e5b>]
net_rx_action+0xab/0x18c
Jul 25 13:07:07 hufpuf kernel: [269282.965755]  [<ffffffff80239a80>]
__do_softirq+0x5c/0xd1
Jul 25 13:07:07 hufpuf kernel: [269282.965757]  [<ffffffff8021de6f>]
ack_apic_level+0x38/0xd8
Jul 25 13:07:07 hufpuf kernel: [269282.965764]  [<ffffffff8020d1ac>]
call_softirq+0x1c/0x28
Jul 25 13:07:07 hufpuf kernel: [269282.965769]  [<ffffffff8020f208>]
do_softirq+0x3c/0x81
Jul 25 13:07:07 hufpuf kernel: [269282.965772]  [<ffffffff802399e0>]
irq_exit+0x3f/0x83
Jul 25 13:07:07 hufpuf kernel: [269282.965776]  [<ffffffff8020f468>]
do_IRQ+0xb9/0xd9
Jul 25 13:07:07 hufpuf kernel: [269282.965781]  [<ffffffff8020c34d>]
ret_from_intr+0x0/0x19
Jul 25 13:07:07 hufpuf kernel: [269282.965784]  <EOI>=20
Jul 25 13:07:07 hufpuf kernel: [269282.965800] Mem-info:
Jul 25 13:07:07 hufpuf kernel: [269282.965802] Node 0 DMA per-cpu:
Jul 25 13:07:07 hufpuf kernel: [269282.965804] CPU    0: hi:    0, btch:
1 usd:   0
Jul 25 13:07:07 hufpuf kernel: [269282.965806] CPU    1: hi:    0, btch:
1 usd:   0
Jul 25 13:07:07 hufpuf kernel: [269282.965808] Node 0 DMA32 per-cpu:
Jul 25 13:07:07 hufpuf kernel: [269282.965810] CPU    0: hi:  186, btch:
31 usd: 168
Jul 25 13:07:07 hufpuf kernel: [269282.965811] CPU    1: hi:  186, btch:
31 usd: 181
Jul 25 13:07:07 hufpuf kernel: [269282.965815] Active:245684
inactive:233626 dirty:132 writeback:0 unstable:0
Jul 25 13:07:07 hufpuf kernel: [269282.965816]  free:5334 slab:19935
mapped:17919 pagetables:4494 bounce:0
Jul 25 13:07:07 hufpuf kernel: [269282.965818] Node 0 DMA free:8032kB
min:28kB low:32kB high:40kB active:2024kB inactive:220kB present:11392kB
pages_scanned:0 all_unreclaimable? no
Jul 25 13:07:07 hufpuf kernel: [269282.965822] lowmem_reserve[]: 0 2004
2004 2004
Jul 25 13:07:07 hufpuf kernel: [269282.965825] Node 0 DMA32 free:13304kB
min:5712kB low:7140kB high:8568kB active:980724kB inactive:934144kB
present:2052260kB pages_scanned:64 all_unreclaimable? no
Jul 25 13:07:07 hufpuf kernel: [269282.965829] lowmem_reserve[]: 0 0 0 0
Jul 25 13:07:07 hufpuf kernel: [269282.965832] Node 0 DMA: 178*4kB
73*8kB 40*16kB 15*32kB 14*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2
Jul 25 13:07:07 hufpuf kernel: [269282.965838] Node 0 DMA32: 1823*4kB
660*8kB 21*16kB 1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB
0*4096kB =3D 13452kB
Jul 25 13:07:07 hufpuf kernel: [269282.965845] 260976 total pagecache
pages
Jul 25 13:07:07 hufpuf kernel: [269282.965847] Swap cache: add 6993,
delete 6407, find 1624/2224
Jul 25 13:07:07 hufpuf kernel: [269282.965849] Free swap  =3D 1956068kB
Jul 25 13:07:07 hufpuf kernel: [269282.965850] Total swap =3D 1959800kB
Jul 25 13:07:07 hufpuf kernel: [269282.965852] Free swap:
1956068kB
Jul 25 13:07:07 hufpuf kernel: [269282.968840] 524272 pages of RAM
Jul 25 13:07:07 hufpuf kernel: [269282.968840] 8334 reserved pages
Jul 25 13:07:07 hufpuf kernel: [269282.968840] 103280 pages shared
Jul 25 13:07:07 hufpuf kernel: [269282.968840] 586 pages swap cached


Still seems to maybe network related, but I am not sure. These errors
have only come back on 1 machine so far

Alex
PS Please CC me


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiJfqwACgkQkZz88chpJ2MEPACgwcljmaZcciVMnaZw8PRI/Xs+
yBMAn3au878nYJeuCpKMAbZA1gtYbyWc
=Q+Dj
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
