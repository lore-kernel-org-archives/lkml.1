Return-Path: <linux-kernel-owner+w=401wt.eu-S936986AbXGSPLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936986AbXGSPLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbXGSPKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:10:48 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:47773 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765421AbXGSPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:10:43 -0400
Message-ID: <469F7E97.9070400@googlemail.com>
Date: Thu, 19 Jul 2007 17:09:11 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: randconfig compile errors on current git head
Content-Type: multipart/mixed;
 boundary="------------040208020200060605020604"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040208020200060605020604
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

I got to 2 compile errors with randconfigs on current git head.

First error:

...

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `store_uevent':
core.c:(.text+0x6d673): undefined reference to `kobject_actions'
core.c:(.text+0x6d696): undefined reference to `kobject_actions'
make: *** [.tmp_vmlinux1] Error 1

...

And second one :


....

  LD      vmlinux
drivers/built-in.o: In function `store_uevent':
core.c:(.text+0x1eb2c): undefined reference to `kobject_actions'
core.c:(.text+0x1eb4f): undefined reference to `kobject_actions'
drivers/built-in.o: In function `mii_check_media':
(.text+0x24483): undefined reference to `netif_carrier_off'
drivers/built-in.o: In function `mii_check_media':
(.text+0x2448d): undefined reference to `netif_carrier_on'
drivers/built-in.o: In function `mii_check_link':
(.text+0x24573): undefined reference to `netif_carrier_on'
drivers/built-in.o: In function `mii_check_link':
(.text+0x2457f): undefined reference to `netif_carrier_off'
drivers/built-in.o: In function `phy_timer':
phy.c:(.text+0x24eca): undefined reference to `netif_carrier_off'
phy.c:(.text+0x24f9b): undefined reference to `netif_carrier_on'
phy.c:(.text+0x24fdd): undefined reference to `netif_carrier_on'
phy.c:(.text+0x250db): undefined reference to `netif_carrier_on'
phy.c:(.text+0x250ec): undefined reference to `netif_carrier_off'
phy.c:(.text+0x2513a): undefined reference to `netif_carrier_off'
drivers/built-in.o: In function `shaper_kick':
shaper.c:(.text+0x2619b): undefined reference to `skb_unlink'
shaper.c:(.text+0x261bb): undefined reference to `skb_clone'
shaper.c:(.text+0x261d8): undefined reference to `dev_queue_xmit'
shaper.c:(.text+0x261e8): undefined reference to `kfree_skb'
drivers/built-in.o: In function `shaper_ioctl':
shaper.c:(.text+0x26293): undefined reference to `__dev_get_by_name'
drivers/built-in.o: In function `shaper_close':
shaper.c:(.text+0x263db): undefined reference to `kfree_skb'
shaper.c:(.text+0x263e2): undefined reference to `skb_dequeue'
drivers/built-in.o: In function `shaper_start_xmit':
shaper.c:(.text+0x264e7): undefined reference to `kfree_skb'
shaper.c:(.text+0x264f5): undefined reference to `skb_queue_tail'
shaper.c:(.text+0x26502): undefined reference to `skb_dequeue'
shaper.c:(.text+0x26507): undefined reference to `kfree_skb'
drivers/built-in.o: In function `hp100_clean_txring':
hp100.c:(.text+0x281a8): undefined reference to `dev_kfree_skb_any'
drivers/built-in.o: In function `hp100_build_rx_pdl':
hp100.c:(.text+0x281fe): undefined reference to `__alloc_skb'
hp100.c:(.text+0x2826e): undefined reference to `skb_over_panic'
drivers/built-in.o: In function `hp100_rx_bm':
hp100.c:(.text+0x28603): undefined reference to `eth_type_trans'
hp100.c:(.text+0x2860f): undefined reference to `netif_rx'
hp100.c:(.text+0x2864b): undefined reference to `dev_kfree_skb_any'
drivers/built-in.o: In function `hp100_interrupt':
hp100.c:(.text+0x28871): undefined reference to `__alloc_skb'
hp100.c:(.text+0x288c6): undefined reference to `skb_over_panic'
hp100.c:(.text+0x28902): undefined reference to `eth_type_trans'
hp100.c:(.text+0x2890d): undefined reference to `netif_rx'
drivers/built-in.o: In function `hp100_start_xmit_bm':
hp100.c:(.text+0x28bd9): undefined reference to `skb_pad'
drivers/built-in.o: In function `hp100_start_xmit':
hp100.c:(.text+0x2914f): undefined reference to `dev_kfree_skb_any'
drivers/built-in.o: In function `__alloc_ei_netdev':
(.text+0x29a0a): undefined reference to `alloc_netdev_mq'
drivers/built-in.o: In function `ethdev_setup':
8390.c:(.text+0x29a33): undefined reference to `ether_setup'
drivers/built-in.o: In function `ei_receive':
8390.c:(.text+0x29c7e): undefined reference to `__alloc_skb'
8390.c:(.text+0x29ccf): undefined reference to `skb_over_panic'
8390.c:(.text+0x29cfb): undefined reference to `eth_type_trans'
8390.c:(.text+0x29d06): undefined reference to `netif_rx'
drivers/built-in.o: In function `ei_start_xmit':
8390.c:(.text+0x2a6b1): undefined reference to `kfree_skb'
drivers/built-in.o: In function `ei_tx_intr':
8390.c:(.text+0x29ef2): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `ei_tx_timeout':
8390.c:(.text+0x2a3cc): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `dummy_setup':
dummy.c:(.text+0x2abc7): undefined reference to `free_netdev'
dummy.c:(.text+0x2abcc): undefined reference to `ether_setup'
drivers/built-in.o: In function `dummy_xmit':
dummy.c:(.text+0x2ac2a): undefined reference to `kfree_skb'
drivers/built-in.o: In function `de600_interrupt':
de600.c:(.text+0x2b6dc): undefined reference to `__alloc_skb'
de600.c:(.text+0x2b72e): undefined reference to `skb_over_panic'
de600.c:(.text+0x2b841): undefined reference to `eth_type_trans'
de600.c:(.text+0x2b84c): undefined reference to `netif_rx'
de600.c:(.text+0x2b974): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `de600_start_xmit':
de600.c:(.text+0x2c225): undefined reference to `kfree_skb'
drivers/built-in.o: In function `lance_purge_ring':
lance.c:(.text+0x2c268): undefined reference to `dev_kfree_skb_any'
lance.c:(.text+0x2c280): undefined reference to `dev_kfree_skb_any'
drivers/built-in.o: In function `lance_init_ring':
lance.c:(.text+0x2c2f2): undefined reference to `__alloc_skb'
drivers/built-in.o: In function `lance_start_xmit':
lance.c:(.text+0x2c7ee): undefined reference to `skb_pad'
lance.c:(.text+0x2c87c): undefined reference to `kfree_skb'
drivers/built-in.o: In function `lance_interrupt':
lance.c:(.text+0x2c96a): undefined reference to `per_cpu__softnet_data'
lance.c:(.text+0x2ca5e): undefined reference to `__alloc_skb'
lance.c:(.text+0x2caef): undefined reference to `skb_over_panic'
lance.c:(.text+0x2cb28): undefined reference to `eth_type_trans'
lance.c:(.text+0x2cb33): undefined reference to `netif_rx'
lance.c:(.text+0x2ccda): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `lance_tx_timeout':
lance.c:(.text+0x2d13a): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `dfx_rcv_flush':
defxx.c:(.text+0x2d666): undefined reference to `kfree_skb'
drivers/built-in.o: In function `dfx_xmt_flush':
defxx.c:(.text+0x2d6b0): undefined reference to `kfree_skb'
drivers/built-in.o: In function `dfx_adap_init':
defxx.c:(.text+0x2d8ab): undefined reference to `__alloc_skb'
drivers/built-in.o: In function `dfx_int_common':
defxx.c:(.text+0x2d983): undefined reference to `per_cpu__softnet_data'
defxx.c:(.text+0x2da1a): undefined reference to `__netif_schedule'
defxx.c:(.text+0x2dab2): undefined reference to `__alloc_skb'
defxx.c:(.text+0x2db16): undefined reference to `__alloc_skb'
defxx.c:(.text+0x2dba5): undefined reference to `skb_over_panic'
defxx.c:(.text+0x2dbb2): undefined reference to `fddi_type_trans'
defxx.c:(.text+0x2dbc6): undefined reference to `netif_rx'
drivers/built-in.o: In function `dfx_xmt_queue_pkt':
defxx.c:(.text+0x2e669): undefined reference to `__netif_schedule'
defxx.c:(.text+0x2e670): undefined reference to `kfree_skb'
defxx.c:(.text+0x2e6a3): undefined reference to `kfree_skb'
defxx.c:(.text+0x2e70e): undefined reference to `skb_under_panic'
defxx.c:(.text+0x2e7d3): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `el_start_xmit':
3c501.c:(.text+0x2ec6e): undefined reference to `kfree_skb'
drivers/built-in.o: In function `el_interrupt':
3c501.c:(.text+0x2ef32): undefined reference to `__netif_schedule'
3c501.c:(.text+0x2f012): undefined reference to `__alloc_skb'
3c501.c:(.text+0x2f092): undefined reference to `skb_over_panic'
3c501.c:(.text+0x2f0a6): undefined reference to `eth_type_trans'
3c501.c:(.text+0x2f0b1): undefined reference to `netif_rx'
drivers/built-in.o: In function `el_timeout':
3c501.c:(.text+0x2ed3b): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `el16_send_packet':
3c507.c:(.text+0x2f5f8): undefined reference to `__netif_schedule'
3c507.c:(.text+0x2f634): undefined reference to `kfree_skb'
drivers/built-in.o: In function `el16_interrupt':
3c507.c:(.text+0x2f760): undefined reference to `__netif_schedule'
3c507.c:(.text+0x2f887): undefined reference to `__alloc_skb'
3c507.c:(.text+0x2f8dc): undefined reference to `skb_over_panic'
3c507.c:(.text+0x2f8fa): undefined reference to `eth_type_trans'
3c507.c:(.text+0x2f905): undefined reference to `netif_rx'
drivers/built-in.o: In function `el16_tx_timeout':
3c507.c:(.text+0x2fae2): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `depca_interrupt':
depca.c:(.text+0x3009f): undefined reference to `__alloc_skb'
depca.c:(.text+0x30104): undefined reference to `skb_over_panic'
depca.c:(.text+0x30179): undefined reference to `eth_type_trans'
depca.c:(.text+0x30188): undefined reference to `netif_rx'
depca.c:(.text+0x303e3): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `depca_start_xmit':
depca.c:(.text+0x3056d): undefined reference to `skb_pad'
depca.c:(.text+0x307a5): undefined reference to `kfree_skb'
drivers/built-in.o: In function `depca_tx_timeout':
depca.c:(.text+0x30d39): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `net_rx':
atp.c:(.text+0x3190d): undefined reference to `__alloc_skb'
atp.c:(.text+0x31969): undefined reference to `skb_over_panic'
atp.c:(.text+0x31989): undefined reference to `eth_type_trans'
atp.c:(.text+0x31994): undefined reference to `netif_rx'
drivers/built-in.o: In function `atp_send_packet':
atp.c:(.text+0x3232f): undefined reference to `kfree_skb'
drivers/built-in.o: In function `atp_interrupt':
atp.c:(.text+0x32c09): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `tx_timeout':
atp.c:(.text+0x33164): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `ni52_interrupt':
ni52.c:(.text+0x33dd3): undefined reference to `__alloc_skb'
ni52.c:(.text+0x33e25): undefined reference to `skb_over_panic'
ni52.c:(.text+0x33e50): undefined reference to `eth_type_trans'
ni52.c:(.text+0x33e5b): undefined reference to `netif_rx'
ni52.c:(.text+0x34280): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `ni52_send_packet':
ni52.c:(.text+0x34531): undefined reference to `kfree_skb'
drivers/built-in.o: In function `set_multicast_list':
ni52.c:(.text+0x343b4): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `ni65_alloc_mem':
ni65.c:(.text+0x34632): undefined reference to `__alloc_skb'
ni65.c:(.text+0x34685): undefined reference to `skb_over_panic'
ni65.c:(.text+0x346c4): undefined reference to `kfree_skb'
drivers/built-in.o: In function `ni65_stop_start':
ni65.c:(.text+0x34ef9): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `ni65_recv_intr':
ni65.c:(.text+0x35039): undefined reference to `__alloc_skb'
ni65.c:(.text+0x35094): undefined reference to `skb_over_panic'
ni65.c:(.text+0x350d6): undefined reference to `eth_type_trans'
ni65.c:(.text+0x350e1): undefined reference to `netif_rx'
drivers/built-in.o: In function `ni65_interrupt':
ni65.c:(.text+0x3537f): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `ni65_send_packet':
ni65.c:(.text+0x35668): undefined reference to `kfree_skb'
ni65.c:(.text+0x3572d): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `set_multicast_list':
ni65.c:(.text+0x34f68): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `ni65_timeout':
ni65.c:(.text+0x355a3): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `receive_packet':
3c505.c:(.text+0x3627d): undefined reference to `__alloc_skb'
3c505.c:(.text+0x362da): undefined reference to `skb_over_panic'
drivers/built-in.o: In function `elp_interrupt':
3c505.c:(.text+0x3722d): undefined reference to `per_cpu__softnet_data'
3c505.c:(.text+0x37329): undefined reference to `eth_type_trans'
3c505.c:(.text+0x3733d): undefined reference to `netif_rx'
3c505.c:(.text+0x37652): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `elp_timeout':
3c505.c:(.text+0x36644): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `eql_ioctl':
eql.c:(.text+0x37be6): undefined reference to `dev_get_by_name'
eql.c:(.text+0x37d0b): undefined reference to `dev_get_by_name'
eql.c:(.text+0x37d82): undefined reference to `dev_get_by_name'
eql.c:(.text+0x37e1b): undefined reference to `dev_get_by_name'
drivers/built-in.o: In function `eql_slave_xmit':
eql.c:(.text+0x38052): undefined reference to `dev_queue_xmit'
eql.c:(.text+0x38061): undefined reference to `kfree_skb'
drivers/built-in.o: In function `net_interrupt':
cs89x0.c:(.text+0x385ff): undefined reference to `__alloc_skb'
cs89x0.c:(.text+0x38655): undefined reference to `skb_over_panic'
cs89x0.c:(.text+0x3869c): undefined reference to `eth_type_trans'
cs89x0.c:(.text+0x386a7): undefined reference to `netif_rx'
cs89x0.c:(.text+0x386e2): undefined reference to `__netif_schedule'
cs89x0.c:(.text+0x38754): undefined reference to `__netif_schedule'
cs89x0.c:(.text+0x3879f): undefined reference to `__netif_schedule'
cs89x0.c:(.text+0x38822): undefined reference to `__alloc_skb'
cs89x0.c:(.text+0x388c8): undefined reference to `skb_over_panic'
cs89x0.c:(.text+0x3891d): undefined reference to `skb_over_panic'
cs89x0.c:(.text+0x38966): undefined reference to `skb_over_panic'
cs89x0.c:(.text+0x389ba): undefined reference to `eth_type_trans'
cs89x0.c:(.text+0x389c5): undefined reference to `netif_rx'
drivers/built-in.o: In function `net_send_packet':
cs89x0.c:(.text+0x394f8): undefined reference to `kfree_skb'
drivers/built-in.o: In function `net_timeout':
cs89x0.c:(.text+0x38b61): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `tun_chr_close':
tun.c:(.text+0x39676): undefined reference to `rtnl_lock'
tun.c:(.text+0x3968c): undefined reference to `skb_queue_purge'
tun.c:(.text+0x396b1): undefined reference to `unregister_netdevice'
tun.c:(.text+0x396b6): undefined reference to `rtnl_unlock'
drivers/built-in.o: In function `tun_cleanup':
tun.c:(.text+0x396fc): undefined reference to `rtnl_lock'
tun.c:(.text+0x3970d): undefined reference to `unregister_netdevice'
drivers/built-in.o: In function `tun_chr_ioctl':
tun.c:(.text+0x39786): undefined reference to `rtnl_lock'
tun.c:(.text+0x3978b): undefined reference to `rtnl_trylock'
tun.c:(.text+0x39794): undefined reference to `rtnl_unlock'
tun.c:(.text+0x39842): undefined reference to `__dev_get_by_name'
tun.c:(.text+0x398ac): undefined reference to `alloc_netdev_mq'
tun.c:(.text+0x39952): undefined reference to `ether_setup'
tun.c:(.text+0x3999c): undefined reference to `dev_alloc_name'
tun.c:(.text+0x399aa): undefined reference to `register_netdevice'
tun.c:(.text+0x39a07): undefined reference to `free_netdev'
tun.c:(.text+0x39a11): undefined reference to `rtnl_unlock'
tun.c:(.text+0x39ba0): undefined reference to `dev_set_mac_address'
drivers/built-in.o: In function `tun_chr_aio_read':
tun.c:(.text+0x39cd9): undefined reference to `skb_dequeue'
tun.c:(.text+0x39d28): undefined reference to `__netif_schedule'
tun.c:(.text+0x39e5a): undefined reference to `memcpy_toiovec'
tun.c:(.text+0x39e82): undefined reference to `skb_copy_datagram_iovec'
tun.c:(.text+0x39e93): undefined reference to `kfree_skb'
tun.c:(.text+0x39e9c): undefined reference to `kfree_skb'
drivers/built-in.o: In function `tun_net_xmit':
tun.c:(.text+0x39f0b): undefined reference to `skb_queue_tail'
tun.c:(.text+0x39f56): undefined reference to `kfree_skb'
drivers/built-in.o: In function `tun_setup':
tun.c:(.text+0x3a03c): undefined reference to `free_netdev'
drivers/built-in.o: In function `tun_chr_aio_write':
tun.c:(.text+0x3a169): undefined reference to `memcpy_fromiovec'
tun.c:(.text+0x3a19d): undefined reference to `__alloc_skb'
tun.c:(.text+0x3a1f2): undefined reference to `skb_over_panic'
tun.c:(.text+0x3a1ff): undefined reference to `memcpy_fromiovec'
tun.c:(.text+0x3a20d): undefined reference to `kfree_skb'
tun.c:(.text+0x3a24d): undefined reference to `eth_type_trans'
tun.c:(.text+0x3a26a): undefined reference to `netif_rx_ni'
drivers/built-in.o: In function `tun_cleanup':
tun.c:(.text+0x3971e): undefined reference to `rtnl_unlock'
drivers/built-in.o: In function `unregister_hdlc_device':
(.text+0x3a3c4): undefined reference to `rtnl_lock'
drivers/built-in.o: In function `unregister_hdlc_device':
(.text+0x3a3cb): undefined reference to `unregister_netdevice'
drivers/built-in.o: In function `hdlc_rcv':
hdlc.c:(.text+0x3a3f3): undefined reference to `kfree_skb'
drivers/built-in.o: In function `alloc_hdlcdev':
(.text+0x3a54d): undefined reference to `alloc_netdev_mq'
drivers/built-in.o: In function `unregister_hdlc_device':
(.text+0x3a3d8): undefined reference to `rtnl_unlock'
drivers/built-in.o: In function `raw_ioctl':
hdlc_raw.c:(.text+0x3a79c): undefined reference to `linkwatch_fire_event'
drivers/built-in.o: In function `eth_tx':
hdlc_raw_eth.c:(.text+0x3a801): undefined reference to `pskb_expand_head'
hdlc_raw_eth.c:(.text+0x3a815): undefined reference to `kfree_skb'
hdlc_raw_eth.c:(.text+0x3a84a): undefined reference to `skb_over_panic'
drivers/built-in.o: In function `raw_eth_ioctl':
hdlc_raw_eth.c:(.text+0x3a9b8): undefined reference to `ether_setup'
hdlc_raw_eth.c:(.text+0x3a9f4): undefined reference to
`linkwatch_fire_event'
drivers/built-in.o: In function `cisco_hard_header':
hdlc_cisco.c:(.text+0x3aa9c): undefined reference to `skb_under_panic'
drivers/built-in.o: In function `cisco_keepalive_send':
hdlc_cisco.c:(.text+0x3aaf7): undefined reference to `__alloc_skb'
hdlc_cisco.c:(.text+0x3aba0): undefined reference to `skb_over_panic'
drivers/built-in.o: In function `cisco_rx':
hdlc_cisco.c:(.text+0x3acee): undefined reference to `linkwatch_fire_event'
hdlc_cisco.c:(.text+0x3acff): undefined reference to `dev_kfree_skb_any'
hdlc_cisco.c:(.text+0x3ad13): undefined reference to `dev_kfree_skb_any'
drivers/built-in.o: In function `cisco_ioctl':
hdlc_cisco.c:(.text+0x3aee7): undefined reference to `linkwatch_fire_event'
drivers/built-in.o: In function `cisco_stop':
hdlc_cisco.c:(.text+0x3af37): undefined reference to `linkwatch_fire_event'
drivers/built-in.o: In function `cisco_timer':
hdlc_cisco.c:(.text+0x3afa3): undefined reference to `linkwatch_fire_event'
drivers/built-in.o: In function `cisco_keepalive_send':
hdlc_cisco.c:(.text+0x3abc5): undefined reference to `dev_queue_xmit'
drivers/built-in.o: In function `fr_hard_header':
hdlc_fr.c:(.text+0x3b15a): undefined reference to `skb_under_panic'
hdlc_fr.c:(.text+0x3b193): undefined reference to `skb_under_panic'
hdlc_fr.c:(.text+0x3b1cc): undefined reference to `skb_under_panic'
hdlc_fr.c:(.text+0x3b205): undefined reference to `skb_under_panic'
hdlc_fr.c:(.text+0x3b231): undefined reference to `skb_realloc_headroom'
hdlc_fr.c:(.text+0x3b249): undefined reference to `kfree_skb'
hdlc_fr.c:(.text+0x3b275): undefined reference to `skb_under_panic'
hdlc_fr.c:(.text+0x3b2e7): undefined reference to `skb_under_panic'
drivers/built-in.o: In function `fr_lmi_send':
hdlc_fr.c:(.text+0x3b3fe): undefined reference to `__alloc_skb'
hdlc_fr.c:(.text+0x3b5a4): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3b5b9): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3b654): undefined reference to `skb_over_panic'
hdlc_fr.c:(.text+0x3b680): undefined reference to `dev_queue_xmit'
drivers/built-in.o: In function `fr_set_link_state':
hdlc_fr.c:(.text+0x3b6b9): undefined reference to `linkwatch_fire_event'
hdlc_fr.c:(.text+0x3b6ef): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3b704): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3b72c): undefined reference to `linkwatch_fire_event'
hdlc_fr.c:(.text+0x3b743): undefined reference to `netif_carrier_off'
hdlc_fr.c:(.text+0x3b758): undefined reference to `netif_carrier_off'
drivers/built-in.o: In function `fr_close':
hdlc_fr.c:(.text+0x3b877): undefined reference to `dev_close'
hdlc_fr.c:(.text+0x3b883): undefined reference to `dev_close'
drivers/built-in.o: In function `fr_destroy':
hdlc_fr.c:(.text+0x3b8c9): undefined reference to `unregister_netdevice'
hdlc_fr.c:(.text+0x3b8d5): undefined reference to `unregister_netdevice'
drivers/built-in.o: In function `fr_ioctl':
hdlc_fr.c:(.text+0x3bbbc): undefined reference to `ether_setup'
hdlc_fr.c:(.text+0x3bbe5): undefined reference to `alloc_netdev_mq'
hdlc_fr.c:(.text+0x3bcd8): undefined reference to `dev_alloc_name'
hdlc_fr.c:(.text+0x3bce5): undefined reference to `free_netdev'
hdlc_fr.c:(.text+0x3bd16): undefined reference to `register_netdevice'
hdlc_fr.c:(.text+0x3bd21): undefined reference to `free_netdev'
hdlc_fr.c:(.text+0x3bd66): undefined reference to `free_netdev'
hdlc_fr.c:(.text+0x3bde2): undefined reference to `unregister_netdevice'
drivers/built-in.o: In function `pvc_open':
hdlc_fr.c:(.text+0x3bf1f): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3bf34): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3bf48): undefined reference to `netif_carrier_off'
hdlc_fr.c:(.text+0x3bf5d): undefined reference to `netif_carrier_off'
drivers/built-in.o: In function `pvc_xmit':
hdlc_fr.c:(.text+0x3c0b1): undefined reference to `pskb_expand_head'
hdlc_fr.c:(.text+0x3c0ee): undefined reference to `skb_over_panic'
hdlc_fr.c:(.text+0x3c155): undefined reference to `dev_queue_xmit'
hdlc_fr.c:(.text+0x3c163): undefined reference to `kfree_skb'
drivers/built-in.o: In function `fr_rx':
hdlc_fr.c:(.text+0x3c54d): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3c562): undefined reference to `netif_carrier_on'
hdlc_fr.c:(.text+0x3c576): undefined reference to `netif_carrier_off'
hdlc_fr.c:(.text+0x3c58b): undefined reference to `netif_carrier_off'
hdlc_fr.c:(.text+0x3c5cf): undefined reference to `netif_carrier_off'
hdlc_fr.c:(.text+0x3c5e4): undefined reference to `netif_carrier_off'
hdlc_fr.c:(.text+0x3c69d): undefined reference to `skb_clone'
hdlc_fr.c:(.text+0x3c6a6): undefined reference to `kfree_skb'
hdlc_fr.c:(.text+0x3c7c7): undefined reference to `eth_type_trans'
hdlc_fr.c:(.text+0x3c7f3): undefined reference to `netif_rx'
hdlc_fr.c:(.text+0x3c80a): undefined reference to `dev_kfree_skb_any'
hdlc_fr.c:(.text+0x3c815): undefined reference to `dev_kfree_skb_any'
drivers/built-in.o: In function `ppp_ioctl':
hdlc_ppp.c:(.text+0x3ca6e): undefined reference to `linkwatch_fire_event'
drivers/built-in.o: In function `sppp_cisco_send':
syncppp.c:(.text+0x3cbb4): undefined reference to `__alloc_skb'
syncppp.c:(.text+0x3cc0b): undefined reference to `skb_over_panic'
syncppp.c:(.text+0x3cc4e): undefined reference to `skb_over_panic'
drivers/built-in.o: In function `sppp_cp_send':
syncppp.c:(.text+0x3ce33): undefined reference to `__alloc_skb'
syncppp.c:(.text+0x3ce8a): undefined reference to `skb_over_panic'
syncppp.c:(.text+0x3cedc): undefined reference to `skb_over_panic'
syncppp.c:(.text+0x3cf39): undefined reference to `skb_over_panic'
drivers/built-in.o: In function `sppp_flush_xmit':
syncppp.c:(.text+0x3d1e3): undefined reference to `dev_queue_xmit'
syncppp.c:(.text+0x3d1ed): undefined reference to `skb_dequeue'
drivers/built-in.o: In function `sppp_rcv':
syncppp.c:(.text+0x3d2cc): undefined reference to `skb_clone'
syncppp.c:(.text+0x3d2d7): undefined reference to `kfree_skb'
syncppp.c:(.text+0x3d354): undefined reference to `__pskb_pull_tail'
syncppp.c:(.text+0x3d361): undefined reference to `kfree_skb'
syncppp.c:(.text+0x3d46d): undefined reference to `__pskb_pull_tail'
syncppp.c:(.text+0x3da1e): undefined reference to `__pskb_pull_tail'
syncppp.c:(.text+0x3dc3d): undefined reference to `netif_rx'
syncppp.c:(.text+0x3dc92): undefined reference to `__pskb_pull_tail'
syncppp.c:(.text+0x3dd72): undefined reference to `kfree_skb'
drivers/built-in.o: In function `sppp_hard_header':
syncppp.c:(.text+0x3dddd): undefined reference to `skb_under_panic'
drivers/built-in.o: In function `sppp_cisco_send':
syncppp.c:(.text+0x3ccc7): undefined reference to `skb_queue_tail'
drivers/built-in.o: In function `sppp_cp_send':
syncppp.c:(.text+0x3cfbe): undefined reference to `skb_queue_tail'
drivers/built-in.o: In function `drop_xmit_queue':
sbni.c:(.text+0x3e2e2): undefined reference to `dev_kfree_skb_any'
drivers/built-in.o: In function `handle_channel':
sbni.c:(.text+0x3e38e): undefined reference to `per_cpu__softnet_data'
sbni.c:(.text+0x3e57c): undefined reference to `__alloc_skb'
sbni.c:(.text+0x3e6c8): undefined reference to `skb_over_panic'
sbni.c:(.text+0x3e6d3): undefined reference to `eth_type_trans'
sbni.c:(.text+0x3e6de): undefined reference to `netif_rx'
sbni.c:(.text+0x3e882): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `c101_destroy_card':
c101.c:(.text+0x3f63e): undefined reference to `free_netdev'
drivers/built-in.o: In function `sca_intr':
c101.c:(.text+0x3f8f1): undefined reference to `netif_carrier_on'
c101.c:(.text+0x3f8f8): undefined reference to `netif_carrier_off'
c101.c:(.text+0x3fa33): undefined reference to `__alloc_skb'
c101.c:(.text+0x3fb67): undefined reference to `skb_over_panic'
c101.c:(.text+0x3fbbd): undefined reference to `netif_rx'
c101.c:(.text+0x3fcc2): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `c101_open':
c101.c:(.text+0x3feed): undefined reference to `netif_carrier_on'
c101.c:(.text+0x3fef4): undefined reference to `netif_carrier_off'
c101.c:(.text+0x3ff92): undefined reference to `netif_carrier_on'
c101.c:(.text+0x3ff99): undefined reference to `netif_carrier_off'
drivers/built-in.o: In function `sca_xmit':
c101.c:(.text+0x4021f): undefined reference to `kfree_skb'
drivers/built-in.o: In function `alloc_arcdev':
(.text+0x40625): undefined reference to `alloc_netdev_mq'
drivers/built-in.o: In function `arcnet_header':
arcnet.c:(.text+0x406a7): undefined reference to `skb_under_panic'
drivers/built-in.o: In function `arcnet_send_packet':
arcnet.c:(.text+0x4078c): undefined reference to `kfree_skb'
arcnet.c:(.text+0x4089e): undefined reference to `kfree_skb'
drivers/built-in.o: In function `arcnet_interrupt':
(.text+0x4093b): undefined reference to `per_cpu__softnet_data'
drivers/built-in.o: In function `arcnet_interrupt':
(.text+0x40bd5): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `arcnet_timeout':
arcnet.c:(.text+0x40f15): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `build_header':
rfc1201.c:(.text+0x41241): undefined reference to `skb_under_panic'
drivers/built-in.o: In function `rx':
rfc1201.c:(.text+0x413cf): undefined reference to `per_cpu__softnet_data'
rfc1201.c:(.text+0x4141e): undefined reference to `__alloc_skb'
rfc1201.c:(.text+0x41463): undefined reference to `skb_over_panic'
rfc1201.c:(.text+0x414f8): undefined reference to `netif_rx'
rfc1201.c:(.text+0x41541): undefined reference to `per_cpu__softnet_data'
rfc1201.c:(.text+0x415b7): undefined reference to `per_cpu__softnet_data'
rfc1201.c:(.text+0x41629): undefined reference to `__alloc_skb'
rfc1201.c:(.text+0x4169a): undefined reference to `skb_over_panic'
rfc1201.c:(.text+0x4172a): undefined reference to `per_cpu__softnet_data'
rfc1201.c:(.text+0x417d8): undefined reference to `skb_over_panic'
rfc1201.c:(.text+0x41819): undefined reference to `netif_rx'
drivers/built-in.o: In function `build_header':
capmode.c:(.text+0x418d1): undefined reference to `skb_under_panic'
drivers/built-in.o: In function `ack_tx':
capmode.c:(.text+0x419f7): undefined reference to `__alloc_skb'
capmode.c:(.text+0x41a33): undefined reference to `skb_over_panic'
capmode.c:(.text+0x41a6c): undefined reference to `netif_rx'
capmode.c:(.text+0x41a8f): undefined reference to `per_cpu__softnet_data'
drivers/built-in.o: In function `rx':
capmode.c:(.text+0x41b1f): undefined reference to `__alloc_skb'
capmode.c:(.text+0x41b62): undefined reference to `skb_over_panic'
capmode.c:(.text+0x41be9): undefined reference to `netif_rx'
drivers/built-in.o: In function `com20020_found':
(.text+0x42861): undefined reference to `register_netdev'
drivers/built-in.o: In function `arlan_command':
(.text+0x42fd7): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `arlan_command':
(.text+0x432f5): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `arlan_command':
(.text+0x43af0): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `arlan_process_interrupt':
arlan-main.c:(.text+0x441a5): undefined reference to `__netif_schedule'
arlan-main.c:(.text+0x445d4): undefined reference to `__alloc_skb'
arlan-main.c:(.text+0x4463f): undefined reference to `skb_over_panic'
arlan-main.c:(.text+0x44714): undefined reference to `eth_type_trans'
arlan-main.c:(.text+0x4474a): undefined reference to `netif_rx'
arlan-main.c:(.text+0x447ce): undefined reference to `netif_device_detach'
arlan-main.c:(.text+0x44826): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `arlan_tx':
arlan-main.c:(.text+0x4512c): undefined reference to `kfree_skb'
drivers/built-in.o: In function `arlan_registration_timer':
arlan-main.c:(.text+0x45227): undefined reference to `__netif_schedule'
arlan-main.c:(.text+0x452f5): undefined reference to `__netif_schedule'
arlan-main.c:(.text+0x4541f): undefined reference to `__netif_schedule'
arlan-main.c:(.text+0x45499): undefined reference to `__netif_schedule'
arlan-main.c:(.text+0x454b6): undefined reference to `__netif_schedule'
drivers/built-in.o: In function `option_setup':
netconsole.c:(.text+0x480a8): undefined reference to `netpoll_parse_options'
drivers/built-in.o: In function `init_netconsole':
netconsole.c:(.text+0x4810f): undefined reference to `netpoll_setup'
drivers/built-in.o: In function `write_msg':
netconsole.c:(.text+0x4815e): undefined reference to `netpoll_send_udp'
drivers/built-in.o: In function `cleanup_netconsole':
netconsole.c:(.text+0x480d0): undefined reference to `netpoll_cleanup'
drivers/built-in.o: In function `shaper_init':
shaper.c:(.init.text+0x199f): undefined reference to `alloc_netdev_mq'
shaper.c:(.init.text+0x19aa): undefined reference to `register_netdev'
shaper.c:(.init.text+0x19b5): undefined reference to `free_netdev'
drivers/built-in.o: In function `hp100_probe1':
hp100.c:(.init.text+0x2316): undefined reference to `register_netdev'
drivers/built-in.o: In function `hp100_eisa_probe':
hp100.c:(.init.text+0x23c8): undefined reference to `alloc_etherdev_mq'
hp100.c:(.init.text+0x2406): undefined reference to `free_netdev'
drivers/built-in.o: In function `hp100_probe':
(.init.text+0x2543): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `hp100_probe':
(.init.text+0x256f): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `hp100_probe':
(.init.text+0x25bf): undefined reference to `free_netdev'
drivers/built-in.o: In function `wd_probe1':
wd.c:(.init.text+0x2c71): undefined reference to `register_netdev'
drivers/built-in.o: In function `wd_probe':
(.init.text+0x2ce7): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `wd_probe':
(.init.text+0x2e35): undefined reference to `free_netdev'
drivers/built-in.o: In function `es_probe1':
es3210.c:(.init.text+0x3125): undefined reference to `register_netdev'
drivers/built-in.o: In function `es_probe':
(.init.text+0x31b7): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `es_probe':
(.init.text+0x3217): undefined reference to `free_netdev'
drivers/built-in.o: In function `lne390_probe1':
lne390.c:(.init.text+0x3430): undefined reference to `register_netdev'
drivers/built-in.o: In function `lne390_probe':
(.init.text+0x34a7): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `lne390_probe':
(.init.text+0x35ca): undefined reference to `free_netdev'
drivers/built-in.o: In function `ne3210_eisa_probe':
ne3210.c:(.init.text+0x38af): undefined reference to `register_netdev'
ne3210.c:(.init.text+0x3945): undefined reference to `free_netdev'
drivers/built-in.o: In function `dummy_init_module':
dummy.c:(.init.text+0x3969): undefined reference to `rtnl_lock'
dummy.c:(.init.text+0x3973): undefined reference to `__rtnl_link_register'
dummy.c:(.init.text+0x3994): undefined reference to `alloc_netdev_mq'
dummy.c:(.init.text+0x39a1): undefined reference to `dev_alloc_name'
dummy.c:(.init.text+0x39b8): undefined reference to `register_netdevice'
dummy.c:(.init.text+0x39c9): undefined reference to `free_netdev'
dummy.c:(.init.text+0x39e4): undefined reference to `__rtnl_link_unregister'
dummy.c:(.init.text+0x39e9): undefined reference to `rtnl_unlock'
drivers/built-in.o: In function `de600_init':
de600.c:(.init.text+0x3a11): undefined reference to `alloc_etherdev_mq'
de600.c:(.init.text+0x3dd1): undefined reference to `register_netdev'
de600.c:(.init.text+0x3e07): undefined reference to `free_netdev'
drivers/built-in.o: In function `lance_probe':
(.init.text+0x3e41): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `lance_probe':
(.init.text+0x3e6e): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `lance_probe':
(.init.text+0x4885): undefined reference to `register_netdev'
drivers/built-in.o: In function `lance_probe':
(.init.text+0x492e): undefined reference to `free_netdev'
drivers/built-in.o: In function `dfx_dev_register':
defxx.c:(.init.text+0x49d6): undefined reference to `alloc_fddidev'
defxx.c:(.init.text+0x4e52): undefined reference to `register_netdev'
defxx.c:(.init.text+0x4ebf): undefined reference to `free_netdev'
drivers/built-in.o: In function `el1_probe':
(.init.text+0x5153): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `el1_probe':
(.init.text+0x5182): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `el1_probe':
(.init.text+0x51ef): undefined reference to `register_netdev'
drivers/built-in.o: In function `el1_probe':
(.init.text+0x521c): undefined reference to `free_netdev'
drivers/built-in.o: In function `el16_probe':
(.init.text+0x5573): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `el16_probe':
(.init.text+0x55a2): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `el16_probe':
(.init.text+0x560b): undefined reference to `register_netdev'
drivers/built-in.o: In function `el16_probe':
(.init.text+0x5650): undefined reference to `free_netdev'
drivers/built-in.o: In function `depca_common_init':
depca.c:(.init.text+0x576b): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `depca_hw_init':
depca.c:(.init.text+0x5e47): undefined reference to `register_netdev'
drivers/built-in.o: In function `depca_eisa_probe':
depca.c:(.init.text+0x5f1a): undefined reference to `free_netdev'
drivers/built-in.o: In function `depca_isa_probe':
depca.c:(.init.text+0x5fd2): undefined reference to `free_netdev'
drivers/built-in.o: In function `atp_probe1':
atp.c:(.init.text+0x66ef): undefined reference to `alloc_etherdev_mq'
atp.c:(.init.text+0x6c7f): undefined reference to `register_netdev'
atp.c:(.init.text+0x6c8e): undefined reference to `free_netdev'
drivers/built-in.o: In function `ni52_probe':
(.init.text+0x7003): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `ni52_probe':
(.init.text+0x7032): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `ni52_probe':
(.init.text+0x70a4): undefined reference to `register_netdev'
drivers/built-in.o: In function `ni52_probe':
(.init.text+0x70d1): undefined reference to `free_netdev'
drivers/built-in.o: In function `ni65_probe':
(.init.text+0x7891): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `ni65_probe':
(.init.text+0x78c0): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `ni65_probe':
(.init.text+0x7935): undefined reference to `register_netdev'
drivers/built-in.o: In function `ni65_probe':
(.init.text+0x79c2): undefined reference to `free_netdev'
drivers/built-in.o: In function `elplus_probe':
(.init.text+0x7af4): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `elplus_probe':
(.init.text+0x7b21): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `elplus_probe':
(.init.text+0x7f3e): undefined reference to `register_netdev'
drivers/built-in.o: In function `elplus_probe':
(.init.text+0x7f72): undefined reference to `free_netdev'
drivers/built-in.o: In function `ac_probe1':
ac3200.c:(.init.text+0x81e7): undefined reference to `register_netdev'
drivers/built-in.o: In function `ac3200_probe':
(.init.text+0x8287): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `ac3200_probe':
(.init.text+0x82e7): undefined reference to `free_netdev'
drivers/built-in.o: In function `eql_init_module':
eql.c:(.init.text+0x8330): undefined reference to `alloc_netdev_mq'
eql.c:(.init.text+0x833e): undefined reference to `register_netdev'
eql.c:(.init.text+0x834e): undefined reference to `free_netdev'
drivers/built-in.o: In function `cs89x0_probe1':
cs89x0.c:(.init.text+0x8a89): undefined reference to `register_netdev'
drivers/built-in.o: In function `cs89x0_probe':
(.init.text+0x8b94): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `cs89x0_probe':
(.init.text+0x8bbc): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `cs89x0_probe':
(.init.text+0x8c17): undefined reference to `free_netdev'
drivers/built-in.o: In function `hdlc_module_init':
hdlc.c:(.init.text+0x8c47): undefined reference to
`register_netdevice_notifier'
hdlc.c:(.init.text+0x8c57): undefined reference to `dev_add_pack'
drivers/built-in.o: In function `sync_ppp_init':
syncppp.c:(.init.text+0x8cf6): undefined reference to `dev_add_pack'
drivers/built-in.o: In function `sbni_devsetup':
sbni.c:(.init.text+0x8fa4): undefined reference to `ether_setup'
drivers/built-in.o: In function `sbni_probe':
(.init.text+0x9014): undefined reference to `alloc_netdev_mq'
drivers/built-in.o: In function `sbni_probe':
(.init.text+0x9039): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `sbni_probe':
(.init.text+0x912d): undefined reference to `register_netdev'
drivers/built-in.o: In function `sbni_probe':
(.init.text+0x9167): undefined reference to `free_netdev'
drivers/built-in.o: In function `c101_init':
c101.c:(.init.text+0x93c4): undefined reference to `register_netdev'
c101.c:(.init.text+0x965f): undefined reference to `netif_carrier_on'
c101.c:(.init.text+0x9666): undefined reference to `netif_carrier_off'
c101.c:(.init.text+0x967a): undefined reference to `netif_carrier_on'
c101.c:(.init.text+0x9681): undefined reference to `netif_carrier_off'
drivers/built-in.o: In function `com90xx_init':
com90xx.c:(.init.text+0x9dc7): undefined reference to `register_netdev'
com90xx.c:(.init.text+0x9e24): undefined reference to `free_netdev'
drivers/built-in.o: In function `com90io_init':
com90io.c:(.init.text+0xa304): undefined reference to `register_netdev'
com90io.c:(.init.text+0xa396): undefined reference to `free_netdev'
drivers/built-in.o: In function `arc_rimi_init':
arc-rimi.c:(.init.text+0xa68a): undefined reference to `register_netdev'
arc-rimi.c:(.init.text+0xa6ca): undefined reference to `free_netdev'
drivers/built-in.o: In function `arlan_probe':
(.init.text+0xae95): undefined reference to `alloc_etherdev_mq'
drivers/built-in.o: In function `arlan_probe':
(.init.text+0xaec4): undefined reference to `netdev_boot_setup_check'
drivers/built-in.o: In function `arlan_probe':
(.init.text+0xaf1a): undefined reference to `free_netdev'
drivers/built-in.o: In function `arlan_probe':
(.init.text+0xafd9): undefined reference to `register_netdev'
drivers/built-in.o: In function `arlan_probe':
(.init.text+0xb00c): undefined reference to `free_netdev'
drivers/built-in.o: In function `shaper_exit':
shaper.c:(.exit.text+0x28a): undefined reference to `unregister_netdev'
shaper.c:(.exit.text+0x297): undefined reference to `free_netdev'
drivers/built-in.o: In function `hp100_eisa_remove':
hp100.c:(.exit.text+0x2d6): undefined reference to `unregister_netdev'
hp100.c:(.exit.text+0x344): undefined reference to `free_netdev'
drivers/built-in.o: In function `ne3210_eisa_remove':
ne3210.c:(.exit.text+0x387): undefined reference to `unregister_netdev'
ne3210.c:(.exit.text+0x40b): undefined reference to `free_netdev'
drivers/built-in.o: In function `dummy_cleanup_module':
dummy.c:(.exit.text+0x426): undefined reference to `rtnl_link_unregister'
drivers/built-in.o: In function `de600_exit':
de600.c:(.exit.text+0x439): undefined reference to `unregister_netdev'
de600.c:(.exit.text+0x465): undefined reference to `free_netdev'
drivers/built-in.o: In function `dfx_unregister':
defxx.c:(.exit.text+0x4a8): undefined reference to `unregister_netdev'
defxx.c:(.exit.text+0x560): undefined reference to `free_netdev'
drivers/built-in.o: In function `depca_device_remove':
depca.c:(.exit.text+0x5b4): undefined reference to `unregister_netdev'
depca.c:(.exit.text+0x601): undefined reference to `free_netdev'
drivers/built-in.o: In function `atp_cleanup_module':
atp.c:(.exit.text+0x68f): undefined reference to `unregister_netdev'
atp.c:(.exit.text+0x699): undefined reference to `free_netdev'
drivers/built-in.o: In function `eql_cleanup_module':
eql.c:(.exit.text+0x6b6): undefined reference to `unregister_netdev'
eql.c:(.exit.text+0x6c0): undefined reference to `free_netdev'
drivers/built-in.o: In function `hdlc_module_exit':
hdlc.c:(.exit.text+0x6d6): undefined reference to `dev_remove_pack'
hdlc.c:(.exit.text+0x6e0): undefined reference to
`unregister_netdevice_notifier'
drivers/built-in.o: In function `sync_ppp_cleanup':
syncppp.c:(.exit.text+0x746): undefined reference to `dev_remove_pack'
drivers/built-in.o: In function `com90xx_exit':
com90xx.c:(.exit.text+0x7bb): undefined reference to `unregister_netdev'
com90xx.c:(.exit.text+0x817): undefined reference to `free_netdev'
drivers/built-in.o: In function `com90io_exit':
com90io.c:(.exit.text+0x841): undefined reference to `unregister_netdev'
com90io.c:(.exit.text+0x8a2): undefined reference to `free_netdev'
drivers/built-in.o: In function `arc_rimi_exit':
arc-rimi.c:(.exit.text+0x8c4): undefined reference to `unregister_netdev'
arc-rimi.c:(.exit.text+0x906): undefined reference to `free_netdev'
drivers/built-in.o:(.data+0x59e8): undefined reference to `eth_type_trans'
net/built-in.o: In function `wireless_nlevent_process':
wext.c:(.text+0x8c): undefined reference to `rtnl_notify'
wext.c:(.text+0x96): undefined reference to `skb_dequeue'
net/built-in.o: In function `wireless_send_event':
(.text+0x1de): undefined reference to `__alloc_skb'
net/built-in.o: In function `wireless_send_event':
(.text+0x22d): undefined reference to `skb_over_panic'
net/built-in.o: In function `wireless_send_event':
(.text+0x273): undefined reference to `dev_get_flags'
net/built-in.o: In function `wireless_send_event':
(.text+0x2b6): undefined reference to `__rta_fill'
net/built-in.o: In function `wireless_send_event':
(.text+0x2fb): undefined reference to `kfree_skb'
net/built-in.o: In function `wireless_send_event':
(.text+0x310): undefined reference to `skb_queue_tail'
net/built-in.o: In function `wext_handle_ioctl':
(.text+0x747): undefined reference to `dev_load'
net/built-in.o: In function `wext_handle_ioctl':
(.text+0x74c): undefined reference to `rtnl_lock'
net/built-in.o: In function `wext_handle_ioctl':
(.text+0x753): undefined reference to `__dev_get_by_name'
net/built-in.o: In function `wext_handle_ioctl':
(.text+0xa36): undefined reference to `rtnl_unlock'
net/built-in.o:(.rodata+0x418): undefined reference to `dev_seq_start'
net/built-in.o:(.rodata+0x41c): undefined reference to `dev_seq_stop'
net/built-in.o:(.rodata+0x420): undefined reference to `dev_seq_next'
make: *** [vmlinux] Error 1

....

Both configs attached.


Regards,

Gabriel C

--------------040208020200060605020604
Content-Type: text/plain;
 name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22
# Thu Jul 19 15:56:50 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_USER_NS is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=14
CONFIG_CPUSETS=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
# CONFIG_HOTPLUG is not set
# CONFIG_PRINTK is not set
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_BASE_FULL is not set
# CONFIG_FUTEX is not set
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_VISWS=y
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_HPET_TIMER is not set
CONFIG_NR_CPUS=8
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_VISWS_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
CONFIG_PM_DEBUG=y
# CONFIG_DISABLE_CONSOLE_SUSPEND is not set
# CONFIG_PM_TRACE is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_ISA_DMA_API=y
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y

#
# Networking
#
# CONFIG_NET is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_EEPROM_93CX6=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set

#
# SCSI device support
#
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
CONFIG_IEEE1394_VERBOSEDEBUG=y

#
# Controllers
#
CONFIG_IEEE1394_PCILYNX=y
CONFIG_IEEE1394_OHCI1394=y

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=y

#
# SBP-2 support (for storage devices) requires SCSI
#
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
CONFIG_MLX4_CORE=y
CONFIG_PHONE=y
# CONFIG_PHONE_IXJ is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_LIFEBOOK=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
# CONFIG_IPMI_SI is not set
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_SC520_WDT=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
CONFIG_GEN_RTC=y
CONFIG_GEN_RTC_X=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_ATMEL=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set
CONFIG_I2C_ALGO_SGI=y

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_I810=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_ISA=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
CONFIG_I2C_SAVAGE4=y
CONFIG_I2C_SIMTEC=y
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_DS1337=y
CONFIG_SENSORS_DS1374=y
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=y
# CONFIG_SENSORS_PCF8574 is not set
CONFIG_SENSORS_PCA9539=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
CONFIG_SPI=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_AT25 is not set
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
CONFIG_SENSORS_FSCPOS=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_HWMON_DEBUG_CHIP=y

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#
CONFIG_VGASTATE=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_SGIVW is not set
# CONFIG_FB_GBE is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=y
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_MATROX_MULTIHEAD is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_CYBLA=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_VIDEO_SELECT=y
# CONFIG_LOGO is not set

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DUMMY=y
CONFIG_SND_VIRMIDI=y
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=y

#
# PCI devices
#
CONFIG_SND_AD1889=y
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=y
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
CONFIG_SND_AU8830=y
CONFIG_SND_AZT3328=y
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
# CONFIG_SND_CS46XX_NEW_DSP is not set
CONFIG_SND_CS5535AUDIO=y
# CONFIG_SND_DARLA20 is not set
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
CONFIG_SND_ENS1370=y
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDSP=y
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
# CONFIG_SND_INTEL8X0 is not set
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_MAESTRO3=y
# CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=y

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
# CONFIG_USB_HID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#

#
# MMC/SD Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y

#
# LED devices
#
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_EDAC_POLL=y

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_VIRTUALIZATION=y

#
# Userspace I/O
#
CONFIG_UIO=y
CONFIG_UIO_CIF=y

#
# File systems
#
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#

#
# Native Language Support
#
# CONFIG_NLS is not set
CONFIG_INSTRUMENTATION=y
# CONFIG_PROFILING is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_ENABLE_MUST_CHECK=y
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
# CONFIG_DOUBLEFAULT is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
# CONFIG_CRC32 is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

--------------040208020200060605020604
Content-Type: text/plain;
 name="config2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config2"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22
# Thu Jul 19 16:54:51 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_USER_NS is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
CONFIG_CPUSETS=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
# CONFIG_KALLSYMS is not set
# CONFIG_HOTPLUG is not set
# CONFIG_PRINTK is not set
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_BASE_FULL is not set
# CONFIG_FUTEX is not set
# CONFIG_ANON_INODES is not set
CONFIG_SHMEM=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
CONFIG_X86_NUMAQ=y
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
CONFIG_MCRUSOE=y
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_HPET_TIMER is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_NUMA=y
CONFIG_NODES_SHIFT=4
CONFIG_HAVE_ARCH_BOOTMEM_NODE=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_HAVE_ARCH_ALLOC_REMAP=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_MIGRATION is not set
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_IRQBALANCE is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
# CONFIG_PM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
# CONFIG_PCI is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_NAMES is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#

#
# Executable file formats
#
# CONFIG_BINFMT_ELF is not set
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
# CONFIG_NET is not set
CONFIG_WIRELESS_EXT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=y
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0x0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_PNC2000 is not set
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=y
# CONFIG_MTD_DILNETPC is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_VERIFY_WRITE=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND_MUSEUM_IDS=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_OTP is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
# CONFIG_PNP is not set
# CONFIG_MISC_DEVICES is not set

#
# SCSI device support
#
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
CONFIG_DUMMY=y
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=y
CONFIG_TUN=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_ISA is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_FIXED_MII_10_FDX is not set
CONFIG_FIXED_MII_100_FDX=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL1=y
# CONFIG_EL2 is not set
CONFIG_ELPLUS=y
CONFIG_EL16=y
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
# CONFIG_VORTEX is not set
CONFIG_LANCE=y
CONFIG_NET_VENDOR_SMC=y
CONFIG_WD80x3=y
# CONFIG_ULTRA is not set
# CONFIG_ULTRA32 is not set
# CONFIG_SMC9194 is not set
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NI52=y
CONFIG_NI65=y
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
CONFIG_DEPCA=y
CONFIG_HP100=y
# CONFIG_NET_ISA is not set
CONFIG_NET_PCI=y
CONFIG_AC3200=y
# CONFIG_APRICOT is not set
CONFIG_CS89x0=y
# CONFIG_DGRS is not set
CONFIG_LNE390=y
CONFIG_NE3210=y
CONFIG_ES3210=y
# CONFIG_TLAN is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=y
CONFIG_DE600=y
# CONFIG_DE620 is not set
# CONFIG_NETDEV_1000 is not set
CONFIG_NETDEV_10000=y
# CONFIG_TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_ARLAN=y
# CONFIG_WAVELAN is not set
# CONFIG_WLAN_80211 is not set
CONFIG_WAN=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
# CONFIG_N2 is not set
CONFIG_C101=y
# CONFIG_DLCI is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_SHAPER=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_PHONE=y
# CONFIG_PHONE_IXJ is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ATKBD is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_UCB1400=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
# CONFIG_SERIO_I8042 is not set
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=y
CONFIG_SERIAL_8250_ACCENT=y
CONFIG_SERIAL_8250_BOCA=y
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
CONFIG_SERIAL_8250_HUB6=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_TIPAR is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DAB=y

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# CONFIG_LCD_CLASS_DEVICE is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#
# CONFIG_VGASTATE is not set
# CONFIG_FB is not set

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_RTCTIMER=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_DETECT is not set
CONFIG_SND_PCM_XRUN_DEBUG=y

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PORTMAN2X4=y

#
# ISA devices
#
CONFIG_SND_AD1848_LIB=y
CONFIG_SND_CS4231_LIB=y
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1848 is not set
CONFIG_SND_CMI8330=y
CONFIG_SND_CS4231=y
CONFIG_SND_CS4232=y
# CONFIG_SND_CS4236 is not set
CONFIG_SND_ES1688=y
# CONFIG_SND_ES18XX is not set
CONFIG_SND_GUS_SYNTH=y
CONFIG_SND_GUSCLASSIC=y
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_OPL3SA2 is not set
CONFIG_SND_OPTI92X_AD1848=y
CONFIG_SND_OPTI92X_CS4231=y
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
CONFIG_SND_SGALAXY=y
# CONFIG_SND_SSCAPE is not set
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_WAVEFRONT_FIRMWARE_IN_KERNEL=y

#
# System on Chip audio support
#
CONFIG_SND_SOC=y

#
# Open Sound System
#
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
# CONFIG_HID is not set
# CONFIG_USB_SUPPORT is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD Card Drivers
#

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_WBSD=y

#
# LED devices
#
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_EDAC_POLL=y

#
# Real Time Clock
#
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#

#
# DMA Devices
#
CONFIG_AUXDISPLAY=y
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
# CONFIG_INOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_SYSFS is not set
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y

#
# Miscellaneous filesystems
#
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
# CONFIG_JFFS2_FS_SECURITY is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
CONFIG_INSTRUMENTATION=y
# CONFIG_PROFILING is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

--------------040208020200060605020604--
