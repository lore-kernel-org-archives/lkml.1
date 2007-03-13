Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbXCMSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbXCMSfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXCMSfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:35:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbXCMSfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:35:41 -0400
Date: Tue, 13 Mar 2007 11:33:53 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.20.3
Message-ID: <20070313183353.GA7434@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.3 kernel.
It contains a number of bugfixes and all 2.6.20 users are recommended to
upgrade.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.2 and 2.6.20.3.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile                                         |    2 
 arch/sparc/kernel/of_device.c                    |    7 
 arch/sparc64/kernel/of_device.c                  |    7 
 drivers/connector/connector.c                    |   22 +-
 drivers/net/wireless/bcm43xx/bcm43xx.h           |    1 
 drivers/net/wireless/bcm43xx/bcm43xx_dma.c       |  171 ++++++++++++++++-------
 drivers/scsi/scsi_debug.c                        |   12 +
 drivers/usb/serial/keyspan.c                     |   49 ++++++
 include/linux/netfilter_ipv4/ip_conntrack_core.h |    2 
 include/net/inet_timewait_sock.h                 |    2 
 include/net/netfilter/nf_conntrack_core.h        |    2 
 net/core/sock.c                                  |    2 
 net/ipv4/netfilter/ip_conntrack_core.c           |    2 
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c      |    4 
 net/ipv4/netfilter/nf_nat_core.c                 |    3 
 net/ipv4/netfilter/nf_nat_proto_gre.c            |    3 
 net/ipv4/netfilter/nf_nat_proto_icmp.c           |    3 
 net/ipv4/netfilter/nf_nat_proto_tcp.c            |    3 
 net/ipv4/netfilter/nf_nat_proto_udp.c            |    3 
 net/ipv4/udp.c                                   |    1 
 net/ipv6/netfilter.c                             |    1 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c   |    1 
 net/netfilter/nf_conntrack_core.c                |    2 
 net/netfilter/nf_conntrack_proto_gre.c           |    3 
 net/netfilter/nf_conntrack_proto_tcp.c           |    4 
 net/netfilter/nfnetlink_log.c                    |   18 +-
 26 files changed, 232 insertions(+), 98 deletions(-)

Summary of changes from v2.6.20.2 to v2.6.20.3
==============================================


David Miller (1):
      Fix sparc64 device register probing

Douglas Gilbert (1):
      Fix bug 7994 sleeping function called from invalid context

Eric Dumazet (1):
      Fix timewait jiffies

Greg Kroah-Hartman (1):
      Linux 2.6.20.3

Herbert Xu (1):
      Fix UDP header pointer after pskb_trim_rcsum()

Johannes Berg (1):
      Fix compat_getsockopt

Larry Finger (1):
      bcm43xx: Fix problem with >1 GB RAM

Micha Mirosaw (1):
      nfnetlink_log: fix NULL pointer dereference

Michal Miroslaw (1):
      nfnetlink_log: fix possible NULL pointer dereference

Patrick McHardy (8):
      conntrack: fix {nf, ip}_ct_iterate_cleanup endless loops
      nf_conntrack/nf_nat: fix incorrect config ifdefs
      tcp conntrack: accept SYN|URG as valid
      nfnetlink_log: fix reference leak
      nfnetlink_log: fix use after free
      nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED
      nfnetlink_log: zero-terminate prefix
      nfnetlink_log: fix crash on bridged packet

Philipp Reisner (1):
      Fix callback bug in connector

Rainer Weikusat (1):
      fix for bugzilla #7544 (keyspan USB-to-serial converter)

Yasuyuki Kozakai (1):
      ip6_route_me_harder should take into account mark

