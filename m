Return-Path: <linux-kernel-owner+w=401wt.eu-S1765429AbXKOGY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765429AbXKOGY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764385AbXKOGVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:21:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45862 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764813AbXKOGVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:21:42 -0500
Date: Wed, 14 Nov 2007 22:18:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/23] 2.6.23-stable review, network changes
Message-ID: <20071115061806.GA8282@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.23.X release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday 00:00:00 UTC.  Anything received
after that time might be too late.

This set of patches focuses on only the core kernel.  Other sets of
patches will follow if you are interested in those instead.

The diffstat of this review series is included below.

thanks,

greg k-h

------

 include/linux/netlink.h                     |    2 
 include/linux/skbuff.h                      |    3 
 include/net/9p/9p.h                         |   12 ++
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
 18 files changed, 161 insertions(+), 137 deletions(-)
