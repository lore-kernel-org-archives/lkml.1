Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYGMJuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYGMJuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYGMJuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:50:05 -0400
Received: from smtp-out7.tpgi.com.au ([220.244.226.117]:60260 "EHLO
	mail7.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbYGMJuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:50:03 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jul 2008 05:50:03 EDT
X-TPG-Antivirus: Passed
Date: Sun, 13 Jul 2008 19:30:47 +1000
From: Alex Samad <alex@samad.com.au>
To: linux-kernel@vger.kernel.org
Subject: Page swap allocation failure 2.6.25
Message-ID: <20080713093047.GB661@samad.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi


For a while now I have been receiving page swap allocation failures


Similar to http://lkml.org/lkml/2008/6/10/3 and
http://lkml.org/lkml/2008/2/19/298 and I have filed a bug with debian (
Bug#486300)


It seems like any time I put the system under load, transferring large
files across the network  (1G nic, a r8186 and forcedeth and a
broadcom).  I keep getting these errors


this will writing to a XFS parition
Jul 13 13:28:30 nas kernel: [  648.120681] md2_raid5: page allocation
failure. order:2, mode:0x20
Jul 13 13:28:30 nas kernel: [  648.120688] Pid: 1042, comm: md2_raid5
Not tainted 2.6.25-2-amd64 #1
Jul 13 13:28:30 nas kernel: [  648.120689]=20
Jul 13 13:28:30 nas kernel: [  648.120690] Call Trace:
Jul 13 13:28:30 nas kernel: [  648.120694]  <IRQ>  [<ffffffff8027709a>]
__alloc_pages+0x2f8/0x312
Jul 13 13:28:30 nas kernel: [  648.120729]  [<ffffffff80294c63>]
kmem_getpages+0xc5/0x193
Jul 13 13:28:30 nas kernel: [  648.120733]  [<ffffffff8029529d>]
fallback_alloc+0x147/0x1c0
Jul 13 13:28:30 nas kernel: [  648.120740]  [<ffffffff80294ed8>]
kmem_cache_alloc_node+0x105/0x138
Jul 13 13:28:30 nas kernel: [  648.120746]  [<ffffffff803ac4ae>]
__alloc_skb+0x64/0x12d
Jul 13 13:28:30 nas kernel: [  648.120756]  [<ffffffff881b525f>]
:r8168:rtl8168_rx_fill+0x64/0x106
Jul 13 13:28:30 nas kernel: [  648.120765]  [<ffffffff881b563e>]
:r8168:rtl8168_rx_interrupt+0x324/0x392
Jul 13 13:28:30 nas kernel: [  648.120774]  [<ffffffff881b6920>]
:r8168:rtl8168_poll+0x36/0x184
Jul 13 13:28:30 nas kernel: [  648.120783]  [<ffffffff803b2e5b>]
net_rx_action+0xab/0x18c
Jul 13 13:28:30 nas kernel: [  648.120790]  [<ffffffff80239a80>]
__do_softirq+0x5c/0xd1
Jul 13 13:28:30 nas kernel: [  648.120793]  [<ffffffff8021de6f>]
ack_apic_level+0x38/0xd8
Jul 13 13:28:30 nas kernel: [  648.120799]  [<ffffffff8020d1ac>]
call_softirq+0x1c/0x28
Jul 13 13:28:30 nas kernel: [  648.120804]  [<ffffffff8020f208>]
do_softirq+0x3c/0x81
Jul 13 13:28:30 nas kernel: [  648.120806]  [<ffffffff802399e0>]
irq_exit+0x3f/0x83
Jul 13 13:28:30 nas kernel: [  648.120809]  [<ffffffff8020f468>]
do_IRQ+0xb9/0xd9
Jul 13 13:28:30 nas kernel: [  648.120813]  [<ffffffff8020c34d>]
ret_from_intr+0x0/0x19
Jul 13 13:28:30 nas kernel: [  648.120815]  <EOI>  [<ffffffff8808c098>]
:async_memcpy:async_memcpy+0x98/0xe0
Jul 13 13:28:30 nas kernel: [  648.120833]  [<ffffffff88116c02>]
:raid456:async_copy_data+0xf0/0x128
Jul 13 13:28:30 nas kernel: [  648.120844]  [<ffffffff88117d40>]
:raid456:raid5_run_ops+0x1f6/0x4d4
Jul 13 13:28:30 nas kernel: [  648.120854]  [<ffffffff88118acc>]
:raid456:handle_stripe5+0xaae/0xac5
Jul 13 13:28:30 nas kernel: [  648.120866]  [<ffffffff8811ac47>]
:raid456:handle_stripe+0xd1a/0xd96
Jul 13 13:28:30 nas kernel: [  648.120871]  [<ffffffff80229403>]
__wake_up_common+0x41/0x74
Jul 13 13:28:30 nas kernel: [  648.120878]  [<ffffffff8022be94>]
__wake_up+0x38/0x4e
Jul 13 13:28:30 nas kernel: [  648.120890]  [<ffffffff8811afc9>]
:raid456:raid5d+0x306/0x316
Jul 13 13:28:30 nas kernel: [  648.120908]  [<ffffffff880f6ffd>]
:md_mod:md_thread+0xd7/0xed
Jul 13 13:28:30 nas kernel: [  648.120913]  [<ffffffff80246a44>]
autoremove_wake_function+0x0/0x2e
Jul 13 13:28:30 nas kernel: [  648.120923]  [<ffffffff880f6f26>]
:md_mod:md_thread+0x0/0xed
Jul 13 13:28:30 nas kernel: [  648.120925]  [<ffffffff8024691b>]
kthread+0x47/0x74
Jul 13 13:28:30 nas kernel: [  648.120928]  [<ffffffff8023036d>]
schedule_tail+0x27/0x5c
Jul 13 13:28:30 nas kernel: [  648.120931]  [<ffffffff8020ce08>]
child_rip+0xa/0x12
Jul 13 13:28:30 nas kernel: [  648.120941]  [<ffffffff802468d4>]
kthread+0x0/0x74
Jul 13 13:28:30 nas kernel: [  648.120943]  [<ffffffff8020cdfe>]
child_rip+0x0/0x12
Jul 13 13:28:30 nas kernel: [  648.120946]=20
Jul 13 13:28:30 nas kernel: [  648.120947] Mem-info:
Jul 13 13:28:30 nas kernel: [  648.120949] Node 0 DMA per-cpu:
Jul 13 13:28:30 nas kernel: [  648.120951] CPU    0: hi:    0, btch:   1
usd:   0
Jul 13 13:28:30 nas kernel: [  648.120952] CPU    1: hi:    0, btch:   1
usd:   0
Jul 13 13:28:30 nas kernel: [  648.120954] Node 0 DMA32 per-cpu:
Jul 13 13:28:30 nas kernel: [  648.120955] CPU    0: hi:  186, btch:  31
usd: 127
Jul 13 13:28:30 nas kernel: [  648.120957] CPU    1: hi:  186, btch:  31
usd: 191
Jul 13 13:28:30 nas kernel: [  648.120958] Node 0 Normal per-cpu:
Jul 13 13:28:30 nas kernel: [  648.120960] CPU    0: hi:  186, btch:  31
usd:  89
Jul 13 13:28:30 nas kernel: [  648.120962] CPU    1: hi:  186, btch:  31
usd: 183
Jul 13 13:28:30 nas kernel: [  648.120964] Active:10959 inactive:917990
dirty:65346 writeback:3076 unstable:0
Jul 13 13:28:30 nas kernel: [  648.120965]  free:5002 slab:37834
mapped:2069 pagetables:539 bounce:0
Jul 13 13:28:30 nas kernel: [  648.120967] Node 0 DMA free:11944kB
min:20kB low:24kB high:28kB active:0kB inactive:0kB present:11384kB
pages_scanned:0 all_unreclaimable? yes
Jul 13 13:28:30 nas kernel: [  648.120971] lowmem_reserve[]: 0 3254 3885
3885
Jul 13 13:28:30 nas kernel: [  648.120973] Node 0 DMA32 free:7400kB
min:6668kB low:8332kB high:10000kB active:8468kB inactive:3134788kB
present:3332192kB pages_scanned:0 all_unreclaimable? no
Jul 13 13:28:30 nas kernel: [  648.120977] lowmem_reserve[]: 0 0 631 631
Jul 13 13:28:30 nas kernel: [  648.120979] Node 0 Normal free:664kB
min:1292kB low:1612kB high:1936kB active:35368kB inactive:537172kB
present:646400kB pages_scanned:0 all_unreclaimable? no
Jul 13 13:28:30 nas kernel: [  648.120983] lowmem_reserve[]: 0 0 0 0
Jul 13 13:28:30 nas kernel: [  648.120985] Node 0 DMA: 4*4kB 5*8kB
3*16kB 4*32kB 3*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB
=3D 11944kB
Jul 13 13:28:30 nas kernel: [  648.120992] Node 0 DMA32: 1151*4kB
273*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB
0*4096kB =3D 7316kB
Jul 13 13:28:30 nas kernel: [  648.120997] Node 0 Normal: 120*4kB 1*8kB
0*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB
=3D 616kB
Jul 13 13:28:30 nas kernel: [  648.121004] 921869 total pagecache pages
Jul 13 13:28:30 nas kernel: [  648.121005] Swap cache: add 31, delete 0,
find 0/0
Jul 13 13:28:30 nas kernel: [  648.121007] Free swap  =3D 4194172kB
Jul 13 13:28:30 nas kernel: [  648.121008] Total swap =3D 4194296kB
Jul 13 13:28:30 nas kernel: [  648.121009] Free swap:       4194172kB
Jul 13 13:28:30 nas kernel: [  648.124409] 1015808 pages of RAM
Jul 13 13:28:30 nas kernel: [  648.124409] 32483 reserved pages
Jul 13 13:28:30 nas kernel: [  648.124409] 907806 pages shared
Jul 13 13:28:30 nas kernel: [  648.124409] 31 pages swap cached

I also have nfsd causing the same problems and sshd when i use scp.


I have pages and pages of these dumps

Help

alex



--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh5y0MACgkQkZz88chpJ2OYMACg62YwdmmizsICbCArHc+LQ881
/9MAnAz8kt9PW2Xgr/AxU5w7sdP8Wm73
=PngP
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
