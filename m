Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYG1SKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYG1SKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYG1SKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:10:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYG1SKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:10:02 -0400
Date: Mon, 28 Jul 2008 11:07:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.13
Message-ID: <20080728180740.GA28669@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.13
kernel.

It contains lots of networking-related bugfixes, all over the map.  Any
users of the 2.6.25 kernel series should upgrade to this version.  For
details on the fixes, see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.25.12 and 2.6.25.13

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

-------------

 Documentation/networking/udplite.txt |    2 -
 Makefile                             |    2 -
 drivers/net/hamradio/hdlcdrv.c       |    1 
 drivers/net/pppoe.c                  |   37 ++++++++++++++++++-----------------
 drivers/net/pppol2tp.c               |   20 +++++++++++-------
 include/linux/ipv6.h                 |    2 +
 include/linux/kernel.h               |    1 
 net/ipv4/raw.c                       |    2 -
 net/ipv4/udp.c                       |    4 +++
 net/ipv4/xfrm4_mode_tunnel.c         |    2 -
 net/ipv6/ip6_fib.c                   |    4 +--
 11 files changed, 46 insertions(+), 31 deletions(-)

David S. Miller (1):
      ipv6: __KERNEL__ ifdef struct ipv6_devconf

Eric Dumazet (1):
      raw: Restore /proc/net/raw correct behavior

Gerrit Renker (1):
      udplite: Protection against coverage value wrap-around

Greg Kroah-Hartman (1):
      Linux 2.6.25.13

Herbert Xu (2):
      net pppoe: Check packet length on all receive paths
      pppoe: Unshare skb before anything else

James Chapman (1):
      l2tp: Fix potential memory corruption in pppol2tp_recvmsg()

Micah Dowty (1):
      hdlcdrv: Fix CRC calculation.

Steffen Klassert (1):
      xfrm: fix fragmentation for ipv4 xfrm tunnel

Stephen Hemminger (1):
      ipv6: use timer pending

