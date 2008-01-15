Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYAOWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYAOWTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbYAOWTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:19:37 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54359 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353AbYAOWTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:19:35 -0500
Date: Wed, 16 Jan 2008 00:18:32 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.58
Message-ID: <20080115221832.GA4449@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.57:
- CVE-2007-2525: PPPOE: fix memory leak (local DoS)
- CVE-2007-3731: Handle bogus %cs selector in single-step instruction decoding
- CVE-2007-6417: tmpfs: restore missing clear_highpage


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.57:

Adrian Bunk (3):
      ipv4/arp.c:arp_process(): remove bogus #ifdef mess
      Linux 2.6.16.58-rc1
      Linux 2.6.16.58

Alan Cox (1):
      [SCSI] aacraid: fix security weakness

Ben Collins (1):
      [ATM]: Add CPPFLAGS to byteorder.h check

Charles Hardin (1):
      [PFKEY]: Sending an SADB_GET responds with an SADB_GET

Chas Williams (1):
      [ATM]: [he] initialize lock and tasklet earlier

Evgeniy Polyakov (1):
      [PKT_SCHED]: Fix OOPS when removing devices from a teql queuing discipline

Florian Zumbiehl (1):
      PPPOE: fix memory leak (local DoS) (CVE-2007-2525)

Hugh Dickins (1):
      tmpfs: restore missing clear_highpage (CVE-2007-6417)

Jean Delvare (2):
      hwmon/lm87: Disable VID when it should be
      hwmon/lm87: Fix a division by zero

Michal Schmidt (1):
      [PPP_MPPE]: Don't put InterimKey on the stack

Patrick McHardy (2):
      [INET_DIAG]: Fix oops in netlink_rcv_skb
      [NETLINK]: Fix unicast timeouts

Peter Zijlstra (1):
      i386: fixup TRACE_IRQ breakage

Radu Rendec (1):
      [PKT_SCHED] CLS_U32: Fix endianness problem with u32 classifier hash masks.

Roland McGrath (1):
      Handle bogus %cs selector in single-step instruction decoding (CVE-2007-3731)

YOSHIFUJI Hideaki (1):
      [IPV6]: Fix unbalanced socket reference with MSG_CONFIRM.


 Makefile                     |    2 +-
 arch/i386/kernel/entry.S     |    1 -
 arch/i386/kernel/ptrace.c    |   22 +++++++++++++++-------
 arch/i386/kernel/traps.c     |   10 ++++++----
 arch/x86_64/kernel/ptrace.c  |   23 ++++++++++++++++-------
 drivers/atm/Makefile         |    2 +-
 drivers/atm/he.c             |   10 +++++-----
 drivers/hwmon/lm87.c         |    4 ++--
 drivers/net/ppp_mppe.c       |   14 ++++++--------
 drivers/net/pppox.c          |    2 +-
 drivers/scsi/aacraid/linit.c |    4 ++--
 include/linux/netlink.h      |    2 +-
 ipc/mqueue.c                 |    6 ++++--
 mm/shmem.c                   |    5 +++--
 net/ipv4/arp.c               |   19 -------------------
 net/ipv4/inet_diag.c         |   10 +++++++++-
 net/ipv6/raw.c               |    2 +-
 net/key/af_key.c             |    2 +-
 net/netlink/af_netlink.c     |   10 +++++-----
 net/sched/cls_u32.c          |    4 ++--
 net/sched/sch_teql.c         |    3 +++
 21 files changed, 84 insertions(+), 73 deletions(-)

