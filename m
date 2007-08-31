Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbXHaGgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbXHaGgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 02:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbXHaGfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 02:35:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57895 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbXHaGfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 02:35:52 -0400
Date: Thu, 30 Aug 2007 23:39:28 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.6
Message-ID: <20070831063928.GA4752@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.6 kernel.
It contains a number of bugfixes and all users of the 2.6.22 series are
encouraged to upgrade to it.

I'll also be replying to this message with a copy of the patch between
2.6.22.5 and 2.6.22.6

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                          |    2 
 arch/i386/mm/fault.c              |    5 -
 arch/sparc64/kernel/pci.c         |   15 +++-
 arch/sparc64/kernel/pci_common.c  |  123 +++++++++++++++++++++++++++++++++++---
 arch/sparc64/kernel/traps.c       |   18 +++--
 arch/sparc64/mm/fault.c           |    5 -
 arch/um/drivers/ubd_kern.c        |    4 -
 drivers/media/video/pwc/pwc-if.c  |   52 ++++++++++------
 drivers/media/video/pwc/pwc.h     |    1 
 drivers/net/bonding/bond_main.c   |   30 ++-------
 drivers/net/ppp_generic.c         |    2 
 drivers/net/sky2.c                |    4 -
 drivers/pci/probe.c               |   18 ++---
 drivers/pci/quirks.c              |    3 
 drivers/usb/core/message.c        |   28 ++++++++
 fs/exec.c                         |    9 --
 fs/ocfs2/file.c                   |    2 
 fs/signalfd.c                     |   14 +++-
 include/asm-sparc/sfp-machine.h   |    6 +
 include/asm-sparc64/sfp-machine.h |    2 
 include/linux/netdevice.h         |    2 
 include/linux/netfilter/Kbuild    |    1 
 include/linux/pci_ids.h           |    3 
 include/math-emu/op-common.h      |    5 +
 include/math-emu/soft-fp.h        |    7 ++
 include/net/tcp.h                 |    2 
 kernel/signal.c                   |    4 -
 net/802/psnap.c                   |   17 +++--
 net/bridge/br_device.c            |    3 
 net/bridge/br_if.c                |   28 +-------
 net/core/dev.c                    |   38 +++++++++++
 net/dccp/ccids/ccid2.c            |    2 
 net/ipv4/af_inet.c                |    2 
 net/ipv4/tcp.c                    |    3 
 net/ipv4/tcp_input.c              |   26 ++++----
 net/ipv4/tcp_ipv4.c               |    1 
 net/ipv6/af_inet6.c               |    2 
 net/ipv6/ip6_output.c             |    2 
 net/ipv6/ipv6_sockglue.c          |    2 
 net/ipv6/tcp_ipv6.c               |    1 
 net/socket.c                      |    2 
 41 files changed, 351 insertions(+), 145 deletions(-)

Summary of changes from v2.6.22.5 to v2.6.22.6
==============================================

Alan Stern (1):
      USB: allow retry on descriptor fetch errors

Bernhard Kaindl (1):
      PCI: lets kill the 'PCI hidden behind bridge' message

Chuck Ebbert (1):
      Netfilter: Missing Kbuild entry for netfilter

David Miller (4):
      Fix soft-fp underflow handling.
      SPARC64: Fix sparc64 task stack traces.
      SPARC64: Fix sparc64 PCI config accesses on sun4u
      TCP: Do not autobind ports for TCP sockets

Gerrit Renker (1):
      DCCP: Fix DCCP GFP_KERNEL allocation in atomic context

Greg Kroah-Hartman (1):
      Linux 2.6.22.6

Herbert Xu (3):
      NET: Share correct feature code between bridging and bonding
      SNAP: Fix SNAP protocol header accesses.
      NET: Fix missing rcu unlock in __sock_create()

Ilpo Jarvinen (1):
      IPv6: Invalid semicolon after if statement

Ilpo Järvinen (2):
      TCP: Fix TCP rate-halving on bidirectional flows.
      TCP: Fix TCP handling of SACK in bidirectional flows.

Jeff Dike (1):
      uml: fix previous request size limit fix

Kay Sievers (1):
      usb: add PRODUCT, TYPE to usb-interface events

Konstantin Sharlaimov (1):
      PPP: Fix PPP buffer sizing.

Mark Fasheh (1):
      ocfs2: Fix bad source start calculation during kernel writes

Oleg Nesterov (2):
      signalfd: fix interaction with posix-timers
      signalfd: make it group-wide, fix posix-timers scheduling

Oliver Neukum (1):
      USB: fix DoS in pwc USB video driver

Stephen Hemminger (1):
      sky2: don't clear phy power bits

Tejun Heo (3):
      PCI: disable MSI on RS690
      PCI: disable MSI on RD580
      PCI: disable MSI on RX790

Wei Yongjun (1):
      IPV6: Fix kernel panic while send SCTP data with IP fragments

Zachary Amsden (1):
      i386: fix lazy mode vmalloc synchronization for paravirt

