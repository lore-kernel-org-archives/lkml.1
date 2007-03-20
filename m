Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbXCTVuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbXCTVuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXCTVuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:50:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36702 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751448AbXCTVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:50:06 -0400
Date: Tue, 20 Mar 2007 22:50:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.44
Message-ID: <20070320215008.GF752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.43:
- CVE-2007-0005: Fix buffer overflow in Omnikey CardMan 4040 driver
- CVE-2007-1000: [IPV6]: Handle np->opt being NULL in ipv6_getsockopt_sticky().


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git


Changes since 2.6.16.43:

Adrian Bunk (3):
      Linux 2.6.16.44-rc1
      Linux 2.6.16.44-rc2
      Linux 2.6.16.44

Ang Way Chuang (1):
      dvb-core: fix bug in CRC-32 checking on 64-bit systems

Arnaldo Carvalho de Melo (1):
      [TCP]: Fix minisock tcp_create_openreq_child() typo.

Arthur Kepner (1):
      IB/mthca: Use mmiowb after doorbell ring

Chris Wright (1):
      [IPV6] fix ipv6_getsockopt_sticky copy_to_user leak

Dan Yeisley (1):
      init_reap_node() initialization fix

David Moore (1):
      Missing critical phys_to_virt in lib/swiotlb.c

David S. Miller (4):
      video/aty/mach64_ct.c: fix bogus delay loop
      [SPARC64] bbc_i2c: Fix kenvctrld eating %100 cpu.
      [IPV6]: Handle np->opt being NULL in ipv6_getsockopt_sticky(). (CVE-2007-1000)
      SPARC64: Fix memory corruption in pci_4u_free_consistent()

David Stevens (1):
      [IPV6]: /proc/net/anycast6 unbalanced inet6_dev refcnt

Eli Cohen (1):
      IPoIB: Rejoin all multicast groups after a port event

Eric Dumazet (1):
      [INET]: twcal_jiffie should be unsigned long, not int

Herbert Xu (1):
      [UDP]: Reread uh pointer after pskb_trim

Hugh Dickins (2):
      make ppc64 current preempt-safe
      pwc-uncompress.c shouldn't #include <asm/current.h>

Jin-Bong lee (1):
      DVB: cxusb: fix firmware patch for big endian systems

Komuro (1):
      modify 3c589_cs to be SMP safe

Marcel Holtmann (1):
      Fix buffer overflow in Omnikey CardMan 4040 driver (CVE-2007-0005)

Michael S. Tsirkin (1):
      IB/mthca: Fix off-by-one in FMR handling on memfree

Michal Wrobel (1):
      [IPV6]: anycast refcnt fix

Olaf Kirch (1):
      [IPV6]: Fix for ipv6_setsockopt NULL dereference

Sergey Vlasov (1):
      Input: psmouse - fix attribute access on 64-bit systems


 Makefile                                    |    2 +-
 arch/sparc64/kernel/pci_iommu.c             |    2 +-
 drivers/char/pcmcia/cm4040_cs.c             |    3 ++-
 drivers/infiniband/hw/mthca/mthca_cq.c      |    7 +++++++
 drivers/infiniband/hw/mthca/mthca_memfree.c |    2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c      |   19 +++++++++++++++++++
 drivers/infiniband/hw/mthca/mthca_srq.c     |    8 ++++++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c     |    4 +++-
 drivers/input/mouse/psmouse-base.c          |    8 +++++---
 drivers/media/dvb/dvb-core/dvb_net.c        |    4 ++--
 drivers/media/dvb/dvb-usb/cxusb.c           |    4 ++--
 drivers/net/pcmcia/3c589_cs.c               |    7 +++++--
 drivers/sbus/char/bbc_i2c.c                 |   17 +++++++++--------
 drivers/usb/media/pwc/pwc-uncompress.c      |    1 -
 drivers/video/aty/mach64_ct.c               |    4 ++--
 include/asm-powerpc/current.h               |   12 +++++++++++-
 include/net/inet_timewait_sock.h            |    2 +-
 lib/swiotlb.c                               |    2 +-
 mm/slab.c                                   |    2 +-
 net/ipv4/tcp_minisocks.c                    |    2 +-
 net/ipv4/udp.c                              |    1 +
 net/ipv6/addrconf.c                         |    2 ++
 net/ipv6/anycast.c                          |    1 +
 net/ipv6/ipv6_sockglue.c                    |   14 +++++++++-----
 24 files changed, 95 insertions(+), 35 deletions(-)



