Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYGXG1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYGXG1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYGXG1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:27:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYGXG1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:27:15 -0400
Date: Wed, 23 Jul 2008 23:27:15 -0700 (PDT)
Message-Id: <20080723.232715.120106648.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several bug fixes, and also this gets rid of the __netif_schedule()
warning, it isn't something worth chirping about at this point.

A bug fix to TCP probing, as old as 2.4.x, based upon a report
from Eric Dumazet.

Also, the fix for Ingo's netconsole memory corruption issue with
e1000 cards.

Please pull, thanks a lot!

The following changes since commit c010b2f76c3032e48097a6eef291d8593d5d79a6:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Chas Williams (1):
      atm: [fore200e] use MODULE_FIRMWARE() and other suggested cleanups

David S. Miller (2):
      netdev: Remove warning from __netif_schedule().
      tcp: Clear probes_out more aggressively in tcp_ack().

Ingo Molnar (1):
      e1000e: fix e1000_netpoll(), remove extraneous e1000_clean_tx_irq() call

Jarek Poplawski (1):
      pkt_sched: sch_sfq: dump a real number of flows

Oliver Hartkopp (1):
      net: Update entry in af_family_clock_key_strings

Patrick McHardy (1):
      netfilter: make security table depend on NETFILTER_ADVANCED

Stephen Hemminger (1):
      sky2: don't stop queue on shutdown

 drivers/atm/fore200e.c      |   15 ++++++++++++---
 drivers/net/e1000e/netdev.c |    2 --
 drivers/net/sky2.c          |    5 -----
 net/core/dev.c              |    3 ---
 net/core/sock.c             |    2 +-
 net/ipv4/netfilter/Kconfig  |    2 +-
 net/ipv4/tcp_input.c        |    3 +--
 net/ipv6/netfilter/Kconfig  |    2 +-
 net/sched/sch_sfq.c         |    9 ++++++++-
 9 files changed, 24 insertions(+), 19 deletions(-)
