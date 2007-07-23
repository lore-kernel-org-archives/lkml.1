Return-Path: <linux-kernel-owner+w=401wt.eu-S1762293AbXGWIBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293AbXGWIBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXGWIBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:01:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41695 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754429AbXGWIBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:01:16 -0400
Date: Mon, 23 Jul 2007 10:00:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.53-rc1
Message-ID: <20070723080040.GZ26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.52:
- CVE-2007-2876: {ip,nf}_conntrack_sctp: fix remotely triggerable NULL dereference


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.52:

Adrian Bunk (1):
      Linux 2.6.16.53-rc1

Al Viro (2):
      coda: wrong order of arguments of ->readdir()
      ieee1394: forgotten dereference...

Albert Lee (1):
      ide: clear bmdma status in ide_intr() for ICHx controllers (revised #4)

Andrew Morton (1):
      ntfs_init_locked_inode(): fix array indexing

Dave Jones (1):
      [IPV4]: Correct rp_filter help text.

David S. Miller (1):
      [NET]: Fix BMSR_100{HALF,FULL}2 defines in linux/mii.h

Dmitry Butskoy (1):
      [IPV6]: MSG_ERRQUEUE messages do not pass to connected raw sockets

Ingo Molnar (1):
      8139too.c: fix netpoll deadlock

Jan Engelhardt (1):
      [SPARC]: Linux always started with 9600 8N1

Johannes Berg (1):
      [NET] skbuff: remove export of static symbol

Mark Glines (1):
      [TCP]: Use default 32768-61000 outgoing port range in all cases.

Patrick McHardy (2):
      [NETFILTER]: {ip,nf}_conntrack_sctp: fix remotely triggerable NULL ptr dereference (CVE-2007-2876)
      [NET]: Fix gen_estimator timer removal race

Vasily Averin (1):
      [NET]: "wrong timeout value" in sk_wait_data() v2

Vlad Yasevich (1):
      SCTP: Add scope_id validation for link-local binds

Yasuyuki Kozakai (1):
      [NETFILTER]: nf_conntrack: don't track locally generated special ICMP error


 Makefile                                     |    2 
 drivers/ide/ide-cd.c                         |    8 ++
 drivers/ide/ide-io.c                         |   11 +++
 drivers/ide/ide.c                            |    1 
 drivers/ide/pci/piix.c                       |   63 ++++++++++++++-----
 drivers/ieee1394/nodemgr.c                   |    2 
 drivers/net/8139too.c                        |    5 -
 drivers/serial/suncore.c                     |    6 -
 fs/coda/dir.c                                |    2 
 fs/ntfs/inode.c                              |    2 
 include/linux/ide.h                          |    1 
 include/linux/mii.h                          |    4 -
 net/core/gen_estimator.c                     |    3 
 net/core/skbuff.c                            |    1 
 net/core/sock.c                              |   14 +++-
 net/ipv4/Kconfig                             |    6 -
 net/ipv4/inet_connection_sock.c              |    4 -
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c |    3 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |   22 +-----
 net/ipv4/tcp.c                               |    3 
 net/ipv6/icmp.c                              |    2 
 net/netfilter/nf_conntrack_proto_sctp.c      |    3 
 net/sctp/ipv6.c                              |    4 +
 23 files changed, 114 insertions(+), 58 deletions(-)

