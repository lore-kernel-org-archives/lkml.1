Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXCZV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXCZV3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXCZV23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:28:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35293 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932696AbXCZV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:27:31 -0400
Date: Mon, 26 Mar 2007 23:27:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.45
Message-ID: <20070326212734.GG16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git


Changes since 2.6.16.44:

Adrian Bunk (2):
      Linux 2.6.16.45-rc1
      Linux 2.6.16.45

Alexey Dobriyan (1):
      [NET]: Copy mac_len in skb_clone() as well

Bart De Schuymer (1):
      NETFILTER: arp_tables: fix userspace compilation

David S. Miller (1):
      [SPARC64]: Add missing HPAGE_MASK masks on address parameters.

Ed Swierk (1):
      load_module: no BUG if module_subsys uninitialized

Joy Latten (1):
      [XFRM]: Fix missing protocol comparison of larval SAs.

Keith Mannthey (1):
      i386 bootioremap / kexec fix

Masayuki Nakagawa (1):
      [IPV6]: ipv6_fl_socklist is inadvertently shared.

Michał Mirosław (5):
      Fix reference counting (memory leak) problem in __nfulnl_send() and callers related to packet queueing.
      [NETFILTER]: nfnetlink_log: fix NULL pointer dereference
      [NETFILTER]: nfnetlink_log: fix possible NULL pointer dereference
      [NETFILTER]: nfnetlink_log: fix reference leak
      [NETFILTER]: nfnetlink_log: fix use after free

Pablo Neira Ayuso (1):
      NETFILTER: ctnetlink: check for status attribute existence on conntrack creation

Patrick McHardy (8):
      NETFILTER: Kconfig: fix xt_physdev dependencies
      NETFILTER: Fix iptables ABI breakage on (at least) CRIS
      NETFILTER: nf_conntrack_ipv6: fix crash when handling fragments
      NETFILTER: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT value
      NETFILTER: xt_connbytes: fix division by zero
      [NETFILTER]: nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED
      [NETFILTER]: nfnetlink_log: fix crash on bridged packet
      [NETFILTER]: tcp conntrack: accept SYN|URG as valid

Robert Olsson (1):
      [IPV4]: Do not disable preemption in trie_leaf_remove().


 Makefile                                       |    2 -
 arch/i386/mm/boot_ioremap.c                    |    7 ++-
 arch/sparc64/mm/hugetlbpage.c                  |   29 ++++++++++-----
 include/linux/netfilter/nf_conntrack_tcp.h     |    2 -
 include/linux/netfilter_arp/arp_tables.h       |    1 
 include/linux/netfilter_ipv4/ip_tables.h       |    2 -
 kernel/module.c                                |    6 +++
 net/core/skbuff.c                              |    1 
 net/ipv4/fib_trie.c                            |    2 -
 net/ipv4/netfilter/ip_conntrack_netlink.c      |    8 ++--
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c    |    4 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    2 +
 net/ipv6/tcp_ipv6.c                            |    1 
 net/netfilter/Kconfig                          |    2 -
 net/netfilter/nf_conntrack_netlink.c           |    8 ++--
 net/netfilter/nf_conntrack_proto_tcp.c         |    4 +-
 net/netfilter/nfnetlink_log.c                  |   31 ++++++++++++-----
 net/netfilter/xt_connbytes.c                   |   29 ++++++---------
 net/xfrm/xfrm_state.c                          |    3 +
 20 files changed, 93 insertions(+), 52 deletions(-)

