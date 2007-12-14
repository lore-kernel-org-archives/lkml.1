Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbXLNTwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbXLNTwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXLNTw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:52:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57114 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762995AbXLNTwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:52:25 -0500
Date: Fri, 14 Dec 2007 11:51:20 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.15
Message-ID: <20071214195120.GC15765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.15 kernel.
It a number of bugfixes and anyone using the 2.6.23 kernel series is
recommended to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.14 and 2.6.22.15

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                              |    2 -
 crypto/algapi.c                       |    6 +--
 drivers/ata/ahci.c                    |   65 ----------------------------------
 drivers/ata/libata-core.c             |   10 -----
 drivers/atm/he.c                      |   10 ++---
 drivers/block/rd.c                    |   13 ++++++
 drivers/isdn/i4l/isdn_common.c        |    5 ++
 drivers/isdn/i4l/isdn_net.c           |    8 ++--
 drivers/net/atl1/atl1_main.c          |   25 ++++++-------
 drivers/net/forcedeth.c               |   38 +++++++++++++------
 drivers/usb/host/ehci-hcd.c           |    5 ++
 drivers/usb/image/microtek.c          |    2 -
 drivers/video/fb_ddc.c                |    8 ++--
 fs/nfsd/nfsfh.c                       |   20 +++++++---
 include/linux/pci_ids.h               |    4 ++
 include/linux/thread_info.h           |   17 +++++++-
 include/net/tcp.h                     |    3 +
 kernel/exit.c                         |    2 -
 kernel/futex.c                        |   25 ++++++-------
 kernel/hrtimer.c                      |    8 ++++
 kernel/sys.c                          |    2 -
 lib/libcrc32c.c                       |    7 +--
 lib/textsearch.c                      |    8 +++-
 mm/shmem.c                            |    5 +-
 net/bridge/br.c                       |    4 +-
 net/bridge/br_input.c                 |    7 ++-
 net/bridge/netfilter/ebtable_broute.c |    4 +-
 net/decnet/dn_dev.c                   |    4 +-
 net/ipv4/arp.c                        |   19 ---------
 net/ipv4/netfilter/nf_nat_core.c      |    2 -
 net/ipv4/route.c                      |    8 +---
 net/ipv4/sysctl_net_ipv4.c            |    2 -
 net/ipv4/tcp_illinois.c               |    2 -
 net/ipv4/tcp_output.c                 |    1 
 net/ipv6/addrconf.c                   |   11 +++++
 net/key/af_key.c                      |    2 -
 net/netfilter/xt_TCPMSS.c             |    4 --
 net/rxrpc/Kconfig                     |    1 
 net/unix/af_unix.c                    |    9 ++++
 net/xfrm/xfrm_state.c                 |    2 -
 40 files changed, 188 insertions(+), 192 deletions(-)

Summary of changes from v2.6.22.14 to v2.6.22.15
===============================================

Adrian Bunk (1):
      IPV4: Remove bogus ifdef mess in arp_process

Ayaz Abdulla (2):
      forcedeth: new mcp79 pci ids
      forcedeth boot delay fix

Charles Hardin (1):
      PFKEY: Sending an SADB_GET responds with an SADB_GET

Christian Borntraeger (1):
      Future of Linux 2.6.22.y series

David Brownell (1):
      USB: fix up EHCI startup synchronization

David Howells (1):
      RXRPC: Add missing select on CRYPTO

Eric Dumazet (1):
      NET: Corrects a bug in ip_rt_acct_read()

Evgeniy Polyakov (1):
      IPV6: Restore IPv6 when MTU is big enough

Florian Zumbiehl (1):
      UNIX: EOF on non-blocking SOCK_SEQPACKET

Greg Kroah-Hartman (2):
      Revert "Fix SMP poweroff hangs"
      Linux 2.6.22.15

Herbert Xu (2):
      libcrc32c: keep intermediate crc state in cpu order
      CRYPTO api: Fix potential race in crypto_remove_spawn

Hugh Dickins (1):
      tmpfs: restore missing clear_highpage

Ilpo Järvinen (1):
      TCP: MTUprobe: fix potential sk_send_head corruption

Jean Delvare (1):
      fb_ddc: fix DDC lines quirk

Karsten Keil (2):
      isdn: avoid copying overly-long strings
      I4L: fix isdn_ioctl memory overrun vulnerability

Li Zefan (1):
      nf_nat: fix memset error

Luca Tettamanti (1):
      atl1: disable broken 64-bit DMA

Neil Brown (1):
      knfsd: Validate filehandle type in fsid_source

Oliver Neukum (1):
      USB: make the microtek driver and HAL cooperate

Pablo Neira Ayuso (1):
      TEXTSEARCH: Do not allow zero length patterns in the textsearch infrastructure

Patrick McHardy (2):
      XFRM: Fix leak of expired xfrm_states
      NETFILTER: xt_TCPMSS: remove network triggerable WARN_ON

Pavel Emelyanov (3):
      DECNET: dn_nl_deladdr() almost always returns no error
      BRIDGE: Lost call to br_fdb_fini() in br_init() error path
      BRIDGE: Properly dereference the br_should_route_hook

Sam Jansen (1):
      TCP: Problem bug with sysctl_tcp_congestion_control function

Scott James Remnant (1):
      wait_task_stopped(): pass correct exit_code to wait_noreap_copyout()

Stephen Hemminger (1):
      TCP: illinois: Incorrect beta usage

Steven Rostedt (1):
      futex: fix for futex_wait signal stack corruption

Tejun Heo (1):
      libata: kill spurious NCQ completion detection

Thomas Gleixner (1):
      hrtimers: avoid overflow for large relative timeouts (CVE-2007-5966)

chas williams (1):
      ATM: [he] initialize lock and tasklet earlier

