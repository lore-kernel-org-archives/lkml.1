Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZJER3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZJER3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZJER3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:29:44 -0400
Received: from kroah.org ([198.145.64.141]:52588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZJER3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:29:43 -0400
Date: Mon, 5 Oct 2009 10:23:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.36
Message-ID: <20091005172331.GA18332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.36 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.35 and 2.6.27.36

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 drivers/isdn/gigaset/bas-gigaset.c |   16 +++++++++-------
 drivers/net/enc28j60.c             |    4 +++-
 drivers/net/pcmcia/pcnet_cs.c      |    2 +-
 drivers/net/wireless/p54/p54usb.c  |    1 +
 fs/inode.c                         |   14 ++++++++------
 mm/hugetlb.c                       |    2 +-
 mm/memory.c                        |    3 ++-
 mm/mmap.c                          |    4 ++--
 net/ax25/af_ax25.c                 |    2 +-
 net/bridge/br_netfilter.c          |    2 +-
 net/packet/af_packet.c             |    4 ++--
 12 files changed, 32 insertions(+), 24 deletions(-)


Arjan van de Ven (2):
      net ax25: Fix signed comparison in the sockopt handler
      net: Make the copy length in af_packet sockopt handler unsigned

Baruch Siach (1):
      enc28j60: fix RX buffer overflow

Christian Lamparter (1):
      p54usb: add Zcomax XG-705A usbid

Cord Walter (1):
      pcnet_cs: Fix misuse of the equality operator.

Greg Kroah-Hartman (1):
      Linux 2.6.27.36

Hugh Dickins (1):
      mm: fix anonymous dirtying

Jan Kara (1):
      fs: make sure data stored into inode is properly seen before unlocking new inode

Lee Schermerhorn (2):
      hugetlb: restore interleaving of bootmem huge pages (2.6.31)
      mmap: avoid unnecessary anon_vma lock acquisition in vma_adjust()

Patrick McHardy (1):
      netfilter: bridge: refcount fix

Tilman Schmidt (1):
      Fix incorrect stable backport to bas_gigaset

