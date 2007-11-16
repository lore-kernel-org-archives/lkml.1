Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXKPSrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXKPSrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXKPSrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:47:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35669 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXKPSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:47:15 -0500
Date: Fri, 16 Nov 2007 10:46:13 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.4
Message-ID: <20071116184613.GG9807@kroah.com>
References: <20071116183752.GA9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116183752.GA9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.4 kernel.
It contains a number of bugfixes for the core networking and wireless
code.

I'll also be replying to this message with a copy of the patch between
2.6.23.3 and 2.6.23.4

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                    |    2 
 include/linux/netlink.h                     |    2 
 include/linux/skbuff.h                      |    3 
 include/net/9p/9p.h                         |   12 ++
 include/net/sock.h                          |   10 +-
 ipc/mqueue.c                                |    6 -
 net/8021q/vlan.c                            |    5 +
 net/ieee80211/ieee80211_crypt_tkip.c        |    2 
 net/ieee80211/softmac/ieee80211softmac_wx.c |    2 
 net/ipv4/ipcomp.c                           |    3 
 net/ipv6/ipcomp6.c                          |    3 
 net/mac80211/ieee80211.c                    |   55 +++++++-----
 net/mac80211/ieee80211_ioctl.c              |   11 ++
 net/mac80211/ieee80211_sta.c                |  128 +++++++++++-----------------
 net/netfilter/nf_conntrack_proto_tcp.c      |   38 +++-----
 net/netlink/af_netlink.c                    |   10 +-
 net/sched/cls_u32.c                         |    4 
 net/sched/sch_api.c                         |    5 -
 net/sched/sch_teql.c                        |    3 
 net/socket.c                                |    6 +
 20 files changed, 168 insertions(+), 142 deletions(-)

Summary of changes from v2.6.23.3 to v2.6.23.4
==============================================

Andy Green (2):
      mac80211: Improve sanity checks on injected packets
      Add get_unaligned to ieee80211_get_radiotap_len

Bill Moss (1):
      mac80211: honor IW_SCAN_THIS_ESSID in siwscan ioctl

David Miller (1):
      Fix error returns in sys_socketpair()

Evgeniy Polyakov (1):
      Fix TEQL oops.

Greg Kroah-Hartman (1):
      Linux 2.6.23.4

Herbert Xu (3):
      Fix SKB_WITH_OVERHEAD calculations.
      TCP: Fix size calculation in sk_stream_alloc_pskb
      Fix crypto_alloc_comp() error checking.

Ingo Molnar (1):
      Fix 9P protocol build

Johannes Berg (3):
      softmac: fix wext MLME request reason code endianness
      ieee80211: fix TKIP QoS bug
      mac80211: reorder association debug output

John W. Linville (5):
      mac80211: filter locally-originated multicast frames
      mac80211: store channel info in sta_bss_list
      mac80211: store SSID in sta_bss_list
      mac80211: only honor IW_SCAN_THIS_ESSID in STA, IBSS, and AP modes
      mac80211: make ieee802_11_parse_elems return void

Jozsef Kadlecsik (1):
      NETFILTER: nf_conntrack_tcp: fix connection reopening

Patrick McHardy (4):
      Fix advertised packet scheduler timer resolution
      Fix VLAN address syncing.
      Fix SET_VLAN_INGRESS_PRIORITY_CMD error return.
      Fix netlink timeouts.

Radu Rendec (1):
      Fix endianness bug in U32 classifier.

Tony Battersby (1):
      Fix kernel_accept() return handling.

