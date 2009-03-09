Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZCIObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZCIObU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZCIObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:31:07 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:45298 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZCIObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:31:04 -0400
Date: Mon, 9 Mar 2009 15:24:07 +0100
From: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
To: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: iwlagn: Cannot allocate memory on 2.6.29-rc4-ikn-00001-gd5b5623
Message-ID: <20090309142407.GB18058@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-ipw3945-devel@schottelius.org>,
	"ipw3945-devel@lists.sourceforge.net" <ipw3945-devel@lists.sourceforge.net>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-00001-gd5b5623 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

After several rmmod & modprobe iwlagn, several suspends I get the following
netlink answer:

[8:42] ikn:~# ip l s wlan0 up
RTNETLINK answers: Cannot allocate memory

[dmesg attached]

The interesting part: The rest of the system is still working fine.

I cannot upgrade to a newer version due to Bug #12705, as reported on
13 Feb 2009.

Sincerly,

Nico


[270638.440620] zsh: page allocation failure. order:4, mode:0x40d0
[270638.440628] Pid: 14669, comm: zsh Not tainted 2.6.29-rc4-ikn-00001-gd5b=
5623 #9
[270638.440632] Call Trace:
[270638.440647]  [<ffffffff8027261c>] __alloc_pages_internal+0x3ed/0x40c
[270638.440655]  [<ffffffff802726a9>] __get_free_pages+0x17/0x56
[270638.440706]  [<ffffffffa0100378>] iwl_txq_ctx_reset+0x32c/0x79c [iwlcor=
e]
[270638.440734]  [<ffffffffa00fd86f>] ? iwl_rx_queue_update_write_ptr+0x134=
/0x157 [iwlcore]
[270638.440761]  [<ffffffffa00fbaa6>] iwl_hw_nic_init+0x105/0x128 [iwlcore]
[270638.440778]  [<ffffffffa0590ca6>] __iwl_up+0x231/0x240 [iwlagn]
[270638.440792]  [<ffffffffa05917eb>] ? iwl_isr+0x0/0xfa [iwlagn]
[270638.440807]  [<ffffffffa05915d6>] iwl_mac_start+0x921/0xaa5 [iwlagn]
[270638.440816]  [<ffffffff8035a5b6>] ? __pci_find_next_cap_ttl+0x39/0x8d
[270638.440823]  [<ffffffff8035a679>] ? pci_find_capability+0x6f/0x71
[270638.440830]  [<ffffffff8035c232>] ? pci_restore_state+0x197/0x1a8
[270638.440845]  [<ffffffffa059178e>] iwl_pci_resume+0x34/0x4d [iwlagn]
[270638.440861]  [<ffffffff8035dd03>] pci_pm_resume+0x6a/0xc1
[270638.440870]  [<ffffffff803c166e>] pm_op+0x3a/0x67
[270638.440875]  [<ffffffff803c1cd6>] device_resume+0x93/0x358
[270638.440883]  [<ffffffff8025bc53>] suspend_devices_and_enter+0x109/0x12e
[270638.440890]  [<ffffffff8025bde0>] enter_state+0x110/0x164
[270638.440897]  [<ffffffff8025bee9>] state_store+0xb5/0xd7
[270638.440905]  [<ffffffff8034d69b>] kobj_attr_store+0x17/0x19
[270638.440912]  [<ffffffff802e4f95>] sysfs_write_file+0xdf/0x114
[270638.440920]  [<ffffffff80299c29>] vfs_write+0xae/0x157
[270638.440926]  [<ffffffff80299d96>] sys_write+0x47/0x70
[270638.440933]  [<ffffffff8020b61b>] system_call_fastpath+0x16/0x1b
[270638.440937] Mem-Info:
[270638.440940] DMA per-cpu:
[270638.440943] CPU    0: hi:    0, btch:   1 usd:   0
[270638.440947] CPU    1: hi:    0, btch:   1 usd:   0
[270638.440950] DMA32 per-cpu:
[270638.440953] CPU    0: hi:  186, btch:  31 usd:   0
[270638.440957] CPU    1: hi:  186, btch:  31 usd:   0
[270638.440964] Active_anon:202079 active_file:19960 inactive_anon:70056
[270638.440967]  inactive_file:35762 unevictable:1078 dirty:7 writeback:0 u=
nstable:0
[270638.440970]  free:80401 slab:23240 mapped:6827 pagetables:3030 bounce:0
[270638.440978] DMA free:7820kB min:28kB low:32kB high:40kB active_anon:932=
kB inactive_anon:1544kB active_file:104kB inactive_file:280kB unevictable:0=
kB present:10020kB pages_scanned:0 all_unreclaimable? no
[270638.440984] lowmem_reserve[]: 0 1947 1947 1947
[270638.440994] DMA32 free:313784kB min:5628kB low:7032kB high:8440kB activ=
e_anon:807384kB inactive_anon:278680kB active_file:79736kB inactive_file:14=
2768kB unevictable:4312kB present:1994104kB pages_scanned:0 all_unreclaimab=
le? no
[270638.441001] lowmem_reserve[]: 0 0 0 0
[270638.441006] DMA: 3*4kB 2*8kB 3*16kB 2*32kB 6*64kB 7*128kB 5*256kB 2*512=
kB 0*1024kB 0*2048kB 1*4096kB =3D 7820kB
[270638.441020] DMA32: 28578*4kB 23970*8kB 438*16kB 2*32kB 0*64kB 1*128kB 0=
*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB =3D 313784kB
[270638.441034] 56798 total pagecache pages
[270638.441037] 0 pages in swap cache
[270638.441041] Swap cache stats: add 0, delete 0, find 0/0
[270638.441044] Free swap  =3D 0kB
[270638.441046] Total swap =3D 0kB
[270638.459367] 510464 pages RAM
[270638.459371] 10298 pages reserved
[270638.459373] 81093 pages shared
[270638.459376] 357827 pages non-shared
[270638.459380] iwlagn: kmalloc for auxiliary BD structures failed
[270638.459466] iwlagn: Tx 12 queue init failed
[270638.460425] iwlagn: Unable to init nic
[270638.461093] sd 0:0:0:0: [sda] Starting disk
[270639.232291] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[270639.328465] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[270639.328474] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[270639.328622] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[270639.328629] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[270639.339725] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[270639.339733] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[270639.339827] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[270639.339833] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[270639.340757] ata1.00: configured for UDMA/100
[270639.342813] ata1.00: configured for UDMA/100
[270639.356278] ata1: EH complete
[270639.356387] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250=
 GB/232 GiB)
[270639.356423] sd 0:0:0:0: [sda] Write Protect is off
[270639.356428] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[270639.356482] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[270639.356541] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250=
 GB/232 GiB)
[270639.356572] sd 0:0:0:0: [sda] Write Protect is off
[270639.356576] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[270639.356626] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[270640.744143] usb 1-6: reset high speed USB device using ehci_hcd and add=
ress 3
[270640.992322] usb 4-1: reset full speed USB device using uhci_hcd and add=
ress 2
[270641.144798] pci 0000:00:02.0: power state changed by ACPI to D0
[270641.144994] pci 0000:00:02.0: power state changed by ACPI to D0
[270641.145007] pci 0000:00:02.0: setting latency timer to 64
[270641.256324] usb 2-6: reset high speed USB device using ehci_hcd and add=
ress 13
[270641.428264] Restarting tasks ... done.
[270642.528329] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[270642.678525] ready
[270642.679758] sd 11:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96=
 GB/3.69 GiB)
[270642.680546] sd 11:0:0:0: [sdb] Write Protect is off
[270642.680553] sd 11:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[270642.680558] sd 11:0:0:0: [sdb] Assuming drive cache: write through
[270642.681885] sd 11:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96=
 GB/3.69 GiB)
[270642.682511] sd 11:0:0:0: [sdb] Write Protect is off
[270642.682517] sd 11:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[270642.682522] sd 11:0:0:0: [sdb] Assuming drive cache: write through
[270642.682530]  sdb: sdb1
[270642.835983] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[270642.852200] input: TPPS/2 IBM TrackPoint as /class/input/input30
[270643.429018] wlan0: No ProbeResp from current AP 00:14:6c:67:9c:32 - ass=
ume out of range
[270730.670799] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1=
=2E3.27ks
[270730.670808] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[270730.670953] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[270730.670968] iwlagn 0000:03:00.0: setting latency timer to 64
[270730.671049] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[270730.690081] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[270730.693714] wmaster0 (iwlagn): not using net_device_ops yet
[270730.695061] phy9: Selected rate control algorithm 'iwl-agn-rs'
[270730.695100] wlan0 (iwlagn): not using net_device_ops yet
[270730.736457] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[270730.736659] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[270730.736737] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uc=
ode
[270730.840487] iwlagn loaded firmware version 5.4.1.16
[270731.159536] NetworkManager: page allocation failure. order:4, mode:0x40=
d0
[270731.159549] Pid: 4037, comm: NetworkManager Not tainted 2.6.29-rc4-ikn-=
00001-gd5b5623 #9
[270731.159554] Call Trace:
[270731.159571]  [<ffffffff8027261c>] __alloc_pages_internal+0x3ed/0x40c
[270731.159580]  [<ffffffff802726a9>] __get_free_pages+0x17/0x56
[270731.159635]  [<ffffffffa0100378>] iwl_txq_ctx_reset+0x32c/0x79c [iwlcor=
e]
[270731.159663]  [<ffffffffa00fd86f>] ? iwl_rx_queue_update_write_ptr+0x134=
/0x157 [iwlcore]
[270731.159691]  [<ffffffffa00fbaa6>] iwl_hw_nic_init+0x105/0x128 [iwlcore]
[270731.159709]  [<ffffffffa05adca6>] __iwl_up+0x231/0x240 [iwlagn]
[270731.159725]  [<ffffffffa05ae5d6>] iwl_mac_start+0x921/0xaa5 [iwlagn]
[270731.159744]  [<ffffffff804cffeb>] ? kprobe_flush_task+0xa8/0xb7
[270731.159778]  [<ffffffffa00dac24>] ieee80211_open+0x2b2/0x6f6 [mac80211]
[270731.159787]  [<ffffffff804556cc>] dev_open+0x7c/0xc1
[270731.159796]  [<ffffffff8045502c>] dev_change_flags+0xba/0x181
[270731.159804]  [<ffffffff8045ceec>] do_setlink+0x2b5/0x37d
[270731.159813]  [<ffffffff8022b6ce>] ? enqueue_entity+0x1b/0x118
[270731.159821]  [<ffffffff8045d162>] rtnl_setlink+0x11f/0x123
[270731.159829]  [<ffffffff8045d7f1>] ? rtnl_dump_ifinfo+0x0/0x90
[270731.159836]  [<ffffffff8045e04e>] rtnetlink_rcv_msg+0x1c2/0x1e0
[270731.159844]  [<ffffffff8045de8c>] ? rtnetlink_rcv_msg+0x0/0x1e0
[270731.159853]  [<ffffffff8046d9e5>] netlink_rcv_skb+0x3e/0x8d
[270731.159860]  [<ffffffff8045de82>] rtnetlink_rcv+0x27/0x31
[270731.159868]  [<ffffffff8046d4c1>] netlink_unicast+0x211/0x287
[270731.159876]  [<ffffffff8044de7a>] ? __alloc_skb+0x66/0x127
[270731.159884]  [<ffffffff8046d7b8>] netlink_sendmsg+0x281/0x294
[270731.159893]  [<ffffffff80446d90>] sock_sendmsg+0xfd/0x120
[270731.159900]  [<ffffffff80446c1a>] ? sock_recvmsg+0x10e/0x133
[270731.159910]  [<ffffffff80248db2>] ? autoremove_wake_function+0x0/0x38
[270731.159918]  [<ffffffff8045de35>] ? rtnl_unlock+0x9/0xb
[270731.159927]  [<ffffffff804b83a5>] ? wext_ioctl_dispatch+0x138/0x172
[270731.159935]  [<ffffffff804b7eb3>] ? ioctl_private_call+0x0/0x79
[270731.159943]  [<ffffffff804b8128>] ? ioctl_standard_call+0x0/0xb4
[270731.159951]  [<ffffffff80445dd5>] ? move_addr_to_kernel+0x25/0x35
[270731.159958]  [<ffffffff8044f05a>] ? verify_iovec+0x4f/0x91
[270731.159966]  [<ffffffff80446f85>] sys_sendmsg+0x1d2/0x23c
[270731.159974]  [<ffffffff8046bdcf>] ? netlink_table_ungrab+0x28/0x2a
[270731.159982]  [<ffffffff8046c7ea>] ? netlink_insert+0x10b/0x12e
[270731.159989]  [<ffffffff80447a0e>] ? move_addr_to_user+0x42/0x59
[270731.159997]  [<ffffffff80447e5c>] ? sys_getsockname+0x80/0x94
[270731.160006]  [<ffffffff8020b61b>] system_call_fastpath+0x16/0x1b
[270731.160010] Mem-Info:
[270731.160015] DMA per-cpu:
[270731.160019] CPU    0: hi:    0, btch:   1 usd:   0
[270731.160023] CPU    1: hi:    0, btch:   1 usd:   0
[270731.160027] DMA32 per-cpu:
[270731.160031] CPU    0: hi:  186, btch:  31 usd:  37
[270731.160036] CPU    1: hi:  186, btch:  31 usd:   0
[270731.160044] Active_anon:202239 active_file:19501 inactive_anon:70033
[270731.160047]  inactive_file:36525 unevictable:1078 dirty:17 writeback:64=
 unstable:0
[270731.160050]  free:79672 slab:23353 mapped:7040 pagetables:3042 bounce:0
[270731.160059] DMA free:7820kB min:28kB low:32kB high:40kB active_anon:932=
kB inactive_anon:1544kB active_file:104kB inactive_file:280kB unevictable:0=
kB present:10020kB pages_scanned:0 all_unreclaimable? no
[270731.160067] lowmem_reserve[]: 0 1947 1947 1947
[270731.160081] DMA32 free:310868kB min:5628kB low:7032kB high:8440kB activ=
e_anon:808024kB inactive_anon:278588kB active_file:77900kB inactive_file:14=
5820kB unevictable:4312kB present:1994104kB pages_scanned:0 all_unreclaimab=
le? no
[270731.160089] lowmem_reserve[]: 0 0 0 0
[270731.160098] DMA: 3*4kB 2*8kB 3*16kB 2*32kB 6*64kB 7*128kB 5*256kB 2*512=
kB 0*1024kB 0*2048kB 1*4096kB =3D 7820kB
[270731.160119] DMA32: 26964*4kB 23916*8kB 678*16kB 17*32kB 1*64kB 0*128kB =
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 310896kB
[270731.160141] 57116 total pagecache pages
[270731.160144] 0 pages in swap cache
[270731.160149] Swap cache stats: add 0, delete 0, find 0/0
[270731.160152] Free swap  =3D 0kB
[270731.160155] Total swap =3D 0kB
[270731.184524] 510464 pages RAM
[270731.184531] 10298 pages reserved
[270731.184535] 81709 pages shared
[270731.184538] 358196 pages non-shared
[270731.184544] iwlagn: kmalloc for auxiliary BD structures failed
[270731.184642] iwlagn: Tx 17 queue init failed
[270731.186653] iwlagn: Unable to init nic
[270732.155141] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[270732.155337] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[270732.616949] ip: page allocation failure. order:4, mode:0x40d0
[270732.616961] Pid: 23934, comm: ip Not tainted 2.6.29-rc4-ikn-00001-gd5b5=
623 #9
[270732.616967] Call Trace:
[270732.616984]  [<ffffffff8027261c>] __alloc_pages_internal+0x3ed/0x40c
[270732.616994]  [<ffffffff802726a9>] __get_free_pages+0x17/0x56
[270732.617102]  [<ffffffffa0100378>] iwl_txq_ctx_reset+0x32c/0x79c [iwlcor=
e]
[270732.617134]  [<ffffffffa00fd86f>] ? iwl_rx_queue_update_write_ptr+0x134=
/0x157 [iwlcore]
[270732.617165]  [<ffffffffa00fbaa6>] iwl_hw_nic_init+0x105/0x128 [iwlcore]
[270732.617187]  [<ffffffffa05adca6>] __iwl_up+0x231/0x240 [iwlagn]
[270732.617204]  [<ffffffffa05ae7eb>] ? iwl_isr+0x0/0xfa [iwlagn]
[270732.617221]  [<ffffffffa05ae5d6>] iwl_mac_start+0x921/0xaa5 [iwlagn]
[270732.617255]  [<ffffffffa00dac24>] ieee80211_open+0x2b2/0x6f6 [mac80211]
[270732.617267]  [<ffffffff804556cc>] dev_open+0x7c/0xc1
[270732.617279]  [<ffffffff8045502c>] dev_change_flags+0xba/0x181
[270732.617289]  [<ffffffff8045ceec>] do_setlink+0x2b5/0x37d
[270732.617299]  [<ffffffff8045e342>] rtnl_newlink+0x2d6/0x472
[270732.617308]  [<ffffffff8045e119>] ? rtnl_newlink+0xad/0x472
[270732.617319]  [<ffffffff8045e04e>] rtnetlink_rcv_msg+0x1c2/0x1e0
[270732.617329]  [<ffffffff8045de8c>] ? rtnetlink_rcv_msg+0x0/0x1e0
[270732.617340]  [<ffffffff8046d9e5>] netlink_rcv_skb+0x3e/0x8d
[270732.617350]  [<ffffffff8045de82>] rtnetlink_rcv+0x27/0x31
[270732.617360]  [<ffffffff8046d4c1>] netlink_unicast+0x211/0x287
[270732.617370]  [<ffffffff8044de7a>] ? __alloc_skb+0x66/0x127
[270732.617379]  [<ffffffff8046d7b8>] netlink_sendmsg+0x281/0x294
[270732.617387]  [<ffffffff8046d4de>] ? netlink_unicast+0x22e/0x287
[270732.617394]  [<ffffffff8044de7a>] ? __alloc_skb+0x66/0x127
[270732.617402]  [<ffffffff80446d90>] sock_sendmsg+0xfd/0x120
[270732.617412]  [<ffffffff80446c1a>] ? sock_recvmsg+0x10e/0x133
[270732.617425]  [<ffffffff80248db2>] ? autoremove_wake_function+0x0/0x38
[270732.617437]  [<ffffffff80280e3e>] ? handle_mm_fault+0x6ac/0x6c9
[270732.617447]  [<ffffffff80445dd5>] ? move_addr_to_kernel+0x25/0x35
[270732.617457]  [<ffffffff8044f05a>] ? verify_iovec+0x4f/0x91
[270732.617467]  [<ffffffff80446f85>] sys_sendmsg+0x1d2/0x23c
[270732.617476]  [<ffffffff80285ac3>] ? do_brk+0x24d/0x329
[270732.617486]  [<ffffffff8020b61b>] system_call_fastpath+0x16/0x1b
[270732.617493] Mem-Info:
[270732.617498] DMA per-cpu:
[270732.617505] CPU    0: hi:    0, btch:   1 usd:   0
[270732.617511] CPU    1: hi:    0, btch:   1 usd:   0
[270732.617517] DMA32 per-cpu:
[270732.617523] CPU    0: hi:  186, btch:  31 usd:  11
[270732.617529] CPU    1: hi:  186, btch:  31 usd:   0
[270732.617538] Active_anon:202321 active_file:18462 inactive_anon:69978
[270732.617541]  inactive_file:36491 unevictable:1078 dirty:14 writeback:0 =
unstable:0
[270732.617543]  free:80861 slab:23227 mapped:7038 pagetables:3052 bounce:0
[270732.617553] DMA free:7820kB min:28kB low:32kB high:40kB active_anon:932=
kB inactive_anon:1544kB active_file:104kB inactive_file:280kB unevictable:0=
kB present:10020kB pages_scanned:0 all_unreclaimable? no
[270732.617565] lowmem_reserve[]: 0 1947 1947 1947
[270732.617583] DMA32 free:315624kB min:5628kB low:7032kB high:8440kB activ=
e_anon:808352kB inactive_anon:278368kB active_file:73744kB inactive_file:14=
5684kB unevictable:4312kB present:1994104kB pages_scanned:38 all_unreclaima=
ble? no
[270732.617595] lowmem_reserve[]: 0 0 0 0
[270732.617608] DMA: 3*4kB 2*8kB 3*16kB 2*32kB 6*64kB 7*128kB 5*256kB 2*512=
kB 0*1024kB 0*2048kB 1*4096kB =3D 7820kB
[270732.617640] DMA32: 27162*4kB 23958*8kB 899*16kB 18*32kB 0*64kB 1*128kB =
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 315656kB
[270732.617672] 56058 total pagecache pages
[270732.617678] 0 pages in swap cache
[270732.617684] Swap cache stats: add 0, delete 0, find 0/0
[270732.617689] Free swap  =3D 0kB
[270732.617693] Total swap =3D 0kB
[270732.641084] 510464 pages RAM
[270732.641091] 10298 pages reserved
[270732.641095] 81745 pages shared
[270732.641098] 357039 pages non-shared
[270732.641103] iwlagn: kmalloc for auxiliary BD structures failed
[270732.641199] iwlagn: Tx 17 queue init failed
[270732.642647] iwlagn: Unable to init nic
[270733.915986] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[270733.916220] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[270734.516492] NetworkManager: page allocation failure. order:4, mode:0x40=
d0
[270734.516503] Pid: 23935, comm: NetworkManager Not tainted 2.6.29-rc4-ikn=
-00001-gd5b5623 #9
[270734.516509] Call Trace:
[270734.516525]  [<ffffffff8027261c>] __alloc_pages_internal+0x3ed/0x40c
[270734.516535]  [<ffffffff802726a9>] __get_free_pages+0x17/0x56
[270734.516590]  [<ffffffffa0100378>] iwl_txq_ctx_reset+0x32c/0x79c [iwlcor=
e]
[270734.516618]  [<ffffffffa00fd86f>] ? iwl_rx_queue_update_write_ptr+0x134=
/0x157 [iwlcore]
[270734.516646]  [<ffffffffa00fbaa6>] iwl_hw_nic_init+0x105/0x128 [iwlcore]
[270734.516665]  [<ffffffffa05adca6>] __iwl_up+0x231/0x240 [iwlagn]
[270734.516681]  [<ffffffffa05ae7eb>] ? iwl_isr+0x0/0xfa [iwlagn]
[270734.516696]  [<ffffffffa05ae5d6>] iwl_mac_start+0x921/0xaa5 [iwlagn]
[270734.516707]  [<ffffffff80342edb>] ? blk_recount_segments+0x3e/0x5d
[270734.516740]  [<ffffffffa00dac24>] ? ieee80211_open+0x2b2/0x6f6 [mac8021=
1]
[270734.516749]  [<ffffffff8026ebf8>] ? mempool_alloc_slab+0x11/0x13
[270734.516780]  [<ffffffffa00dac24>] ieee80211_open+0x2b2/0x6f6 [mac80211]
[270734.516788]  [<ffffffff8026cc71>] ? find_get_page+0x30/0xb6
[270734.516796]  [<ffffffff804556cc>] dev_open+0x7c/0xc1
[270734.516805]  [<ffffffff8045502c>] dev_change_flags+0xba/0x181
[270734.516813]  [<ffffffff8045ceec>] do_setlink+0x2b5/0x37d
[270734.516822]  [<ffffffff8022b926>] ? dequeue_task_fair+0x26/0x99
[270734.516829]  [<ffffffff8045d162>] rtnl_setlink+0x11f/0x123
[270734.516837]  [<ffffffff8045d7f1>] ? rtnl_dump_ifinfo+0x0/0x90
[270734.516845]  [<ffffffff8045e04e>] rtnetlink_rcv_msg+0x1c2/0x1e0
[270734.516852]  [<ffffffff8045de8c>] ? rtnetlink_rcv_msg+0x0/0x1e0
[270734.516861]  [<ffffffff8046d9e5>] netlink_rcv_skb+0x3e/0x8d
[270734.516868]  [<ffffffff8045de82>] rtnetlink_rcv+0x27/0x31
[270734.516876]  [<ffffffff8046d4c1>] netlink_unicast+0x211/0x287
[270734.516884]  [<ffffffff8044de7a>] ? __alloc_skb+0x66/0x127
[270734.516892]  [<ffffffff8046d7b8>] netlink_sendmsg+0x281/0x294
[270734.516901]  [<ffffffff80446d90>] sock_sendmsg+0xfd/0x120
[270734.516909]  [<ffffffff80446c1a>] ? sock_recvmsg+0x10e/0x133
[270734.516919]  [<ffffffff80248db2>] ? autoremove_wake_function+0x0/0x38
[270734.516929]  [<ffffffff80280e3e>] ? handle_mm_fault+0x6ac/0x6c9
[270734.516937]  [<ffffffff80445dd5>] ? move_addr_to_kernel+0x25/0x35
[270734.516944]  [<ffffffff8044f05a>] ? verify_iovec+0x4f/0x91
[270734.516951]  [<ffffffff80446f85>] sys_sendmsg+0x1d2/0x23c
[270734.516960]  [<ffffffff8046bdcf>] ? netlink_table_ungrab+0x28/0x2a
[270734.516967]  [<ffffffff8046c7ea>] ? netlink_insert+0x10b/0x12e
[270734.516975]  [<ffffffff80447a0e>] ? move_addr_to_user+0x42/0x59
[270734.516983]  [<ffffffff80447e5c>] ? sys_getsockname+0x80/0x94
[270734.516991]  [<ffffffff8020b61b>] system_call_fastpath+0x16/0x1b
[270734.516996] Mem-Info:
[270734.517000] DMA per-cpu:
[270734.517004] CPU    0: hi:    0, btch:   1 usd:   0
[270734.517008] CPU    1: hi:    0, btch:   1 usd:   0
[270734.517012] DMA32 per-cpu:
[270734.517016] CPU    0: hi:  186, btch:  31 usd:   0
[270734.517021] CPU    1: hi:  186, btch:  31 usd:   0
[270734.517029] Active_anon:202372 active_file:17164 inactive_anon:69915
[270734.517032]  inactive_file:36514 unevictable:1078 dirty:13 writeback:0 =
unstable:0
[270734.517034]  free:82476 slab:22945 mapped:6982 pagetables:3054 bounce:0
[270734.517044] DMA free:7820kB min:28kB low:32kB high:40kB active_anon:932=
kB inactive_anon:1544kB active_file:104kB inactive_file:280kB unevictable:0=
kB present:10020kB pages_scanned:0 all_unreclaimable? no
[270734.517052] lowmem_reserve[]: 0 1947 1947 1947
[270734.517065] DMA32 free:322084kB min:5628kB low:7032kB high:8440kB activ=
e_anon:808556kB inactive_anon:278116kB active_file:68552kB inactive_file:14=
5776kB unevictable:4312kB present:1994104kB pages_scanned:0 all_unreclaimab=
le? no
[270734.517074] lowmem_reserve[]: 0 0 0 0
[270734.517082] DMA: 3*4kB 2*8kB 3*16kB 2*32kB 6*64kB 7*128kB 5*256kB 2*512=
kB 0*1024kB 0*2048kB 1*4096kB =3D 7820kB
[270734.517103] DMA32: 27198*4kB 23938*8kB 1249*16kB 44*32kB 1*64kB 1*128kB=
 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 322136kB
[270734.517125] 54760 total pagecache pages
[270734.517129] 0 pages in swap cache
[270734.517133] Swap cache stats: add 0, delete 0, find 0/0
[270734.517137] Free swap  =3D 0kB
[270734.517140] Total swap =3D 0kB
[270734.537856] 510464 pages RAM
[270734.537862] 10298 pages reserved
[270734.537866] 81591 pages shared
[270734.537869] 355529 pages non-shared
[270734.537875] iwlagn: kmalloc for auxiliary BD structures failed
[270734.537969] iwlagn: Tx 17 queue init failed
[270734.539423] iwlagn: Unable to init nic
[270738.028034] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[270738.028232] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[270738.239768] ip: page allocation failure. order:4, mode:0x40d0
[270738.239779] Pid: 23944, comm: ip Not tainted 2.6.29-rc4-ikn-00001-gd5b5=
623 #9
[270738.239784] Call Trace:
[270738.239800]  [<ffffffff8027261c>] __alloc_pages_internal+0x3ed/0x40c
[270738.239810]  [<ffffffff802726a9>] __get_free_pages+0x17/0x56
[270738.239866]  [<ffffffffa0100378>] iwl_txq_ctx_reset+0x32c/0x79c [iwlcor=
e]
[270738.239894]  [<ffffffffa00fd86f>] ? iwl_rx_queue_update_write_ptr+0x134=
/0x157 [iwlcore]
[270738.239922]  [<ffffffffa00fbaa6>] iwl_hw_nic_init+0x105/0x128 [iwlcore]
[270738.239941]  [<ffffffffa05adca6>] __iwl_up+0x231/0x240 [iwlagn]
[270738.239957]  [<ffffffffa05ae7eb>] ? iwl_isr+0x0/0xfa [iwlagn]
[270738.239972]  [<ffffffffa05ae5d6>] iwl_mac_start+0x921/0xaa5 [iwlagn]
[270738.240007]  [<ffffffffa00dac24>] ieee80211_open+0x2b2/0x6f6 [mac80211]
[270738.240058]  [<ffffffff804556cc>] dev_open+0x7c/0xc1
[270738.240067]  [<ffffffff8045502c>] dev_change_flags+0xba/0x181
[270738.240076]  [<ffffffff8045ceec>] do_setlink+0x2b5/0x37d
[270738.240084]  [<ffffffff8045e342>] rtnl_newlink+0x2d6/0x472
[270738.240092]  [<ffffffff8045e119>] ? rtnl_newlink+0xad/0x472
[270738.240100]  [<ffffffff8045e04e>] rtnetlink_rcv_msg+0x1c2/0x1e0
[270738.240108]  [<ffffffff8045de8c>] ? rtnetlink_rcv_msg+0x0/0x1e0
[270738.240118]  [<ffffffff8046d9e5>] netlink_rcv_skb+0x3e/0x8d
[270738.240125]  [<ffffffff8045de82>] rtnetlink_rcv+0x27/0x31
[270738.240133]  [<ffffffff8046d4c1>] netlink_unicast+0x211/0x287
[270738.240140]  [<ffffffff8044de7a>] ? __alloc_skb+0x66/0x127
[270738.240148]  [<ffffffff8046d7b8>] netlink_sendmsg+0x281/0x294
[270738.240156]  [<ffffffff8046d4de>] ? netlink_unicast+0x22e/0x287
[270738.240163]  [<ffffffff8044de7a>] ? __alloc_skb+0x66/0x127
[270738.240172]  [<ffffffff80446d90>] sock_sendmsg+0xfd/0x120
[270738.240179]  [<ffffffff80446c1a>] ? sock_recvmsg+0x10e/0x133
[270738.240189]  [<ffffffff80248db2>] ? autoremove_wake_function+0x0/0x38
[270738.240200]  [<ffffffff80280e3e>] ? handle_mm_fault+0x6ac/0x6c9
[270738.240208]  [<ffffffff80445dd5>] ? move_addr_to_kernel+0x25/0x35
[270738.240215]  [<ffffffff8044f05a>] ? verify_iovec+0x4f/0x91
[270738.240223]  [<ffffffff80446f85>] sys_sendmsg+0x1d2/0x23c
[270738.240231]  [<ffffffff80285ac3>] ? do_brk+0x24d/0x329
[270738.240240]  [<ffffffff8020b61b>] system_call_fastpath+0x16/0x1b
[270738.240931] Mem-Info:
[270738.240935] DMA per-cpu:
[270738.240940] CPU    0: hi:    0, btch:   1 usd:   0
[270738.240944] CPU    1: hi:    0, btch:   1 usd:   0
[270738.240949] DMA32 per-cpu:
[270738.240953] CPU    0: hi:  186, btch:  31 usd:  61
[270738.240957] CPU    1: hi:  186, btch:  31 usd:  25
[270738.240965] Active_anon:202460 active_file:15901 inactive_anon:69892
[270738.240968]  inactive_file:35535 unevictable:1078 dirty:18 writeback:0 =
unstable:0
[270738.240971]  free:85067 slab:22519 mapped:6930 pagetables:3063 bounce:0
[270738.240981] DMA free:7820kB min:28kB low:32kB high:40kB active_anon:932=
kB inactive_anon:1544kB active_file:104kB inactive_file:280kB unevictable:0=
kB present:10020kB pages_scanned:0 all_unreclaimable? no
[270738.240988] lowmem_reserve[]: 0 1947 1947 1947
[270738.241002] DMA32 free:332448kB min:5628kB low:7032kB high:8440kB activ=
e_anon:808908kB inactive_anon:278024kB active_file:63500kB inactive_file:14=
1860kB unevictable:4312kB present:1994104kB pages_scanned:249 all_unreclaim=
able? no
[270738.241015] lowmem_reserve[]: 0 0 0 0
[270738.241024] DMA: 3*4kB 2*8kB 3*16kB 2*32kB 6*64kB 7*128kB 5*256kB 2*512=
kB 0*1024kB 0*2048kB 1*4096kB =3D 7820kB
[270738.241045] DMA32: 27419*4kB 24011*8kB 1807*16kB 40*32kB 1*64kB 1*128kB=
 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 332404kB
[270738.241067] 52500 total pagecache pages
[270738.241070] 0 pages in swap cache
[270738.241075] Swap cache stats: add 0, delete 0, find 0/0
[270738.241078] Free swap  =3D 0kB
[270738.241081] Total swap =3D 0kB
[270738.261278] 510464 pages RAM
[270738.261285] 10298 pages reserved
[270738.261288] 81608 pages shared
[270738.261292] 352903 pages non-shared
[270738.261296] iwlagn: kmalloc for auxiliary BD structures failed
[270738.261389] iwlagn: Tx 17 queue init failed
[270738.262906] iwlagn: Unable to init nic
[8:42] ikn:~#               =20


--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm1JocACgkQuL75KpiFGIx30gCeJ+qorqEi36gR/HMUyiQ+BQa3
2ocAoNqQx/FUkFLA8NPxhiuFifqvuHxM
=xcHi
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
