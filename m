Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYA0SNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYA0SNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYA0SNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:13:33 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60717 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYA0SNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:13:32 -0500
Date: Sun, 27 Jan 2008 20:13:54 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.60
Message-ID: <20080127181354.GE2558@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.59:
- CVE-2007-6063: isdn: avoid copying overly-long strings
- CVE-2007-6151: I4L: fix isdn_ioctl memory overrun vulnerability
- CVE-2007-6206: vfs: coredumping fix


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.59:

Adrian Bunk (3):
      drivers/scsi/BusLogic.c: #ifdef MODULE BusLogic_pci_tbl[]
      Linux 2.6.16.60-rc1
      Linux 2.6.16.60

Al Viro (3):
      [CASSINI]: Fix endianness bug.
      [NET]: Introduce types for checksums.
      [NET]: Generic checksum annotations and cleanups.

Ben Collins (1):
      [BusLogic] Add pci dev table for auto module loading.

Chas Williams (1):
      [ATM]: [nicstar] delay irq setup until card is configured

David S. Miller (1):
      [CASSINI]: Set skb->truesize properly on receive packets.

Eric Dumazet (1):
      [IPV4] ROUTE: ip_rt_dump() is unecessary slow

Herbert Xu (1):
      [ATM]: Check IP header validity in mpc_send_packet

Ingo Molnar (1):
      vfs: coredumping fix (CVE-2007-6206)

Jeff Moyer (1):
      raw: don't allow the creation of a raw device with minor number 0

Karsten Keil (2):
      isdn: avoid copying overly-long strings (CVE-2007-6063)
      I4L: fix isdn_ioctl memory overrun vulnerability (CVE-2007-6151)

Trond Myklebust (2):
      NFS: writes should not clobber utimes() calls
      NFS: call nfs_wb_all() only on regular files


 Makefile                       |    2 
 drivers/atm/nicstar.c          |   19 +++-----
 drivers/char/raw.c             |    2 
 drivers/isdn/i4l/isdn_common.c |    5 +-
 drivers/isdn/i4l/isdn_net.c    |    8 +--
 drivers/net/cassini.c          |    9 ++-
 drivers/net/cassini.h          |   18 +++----
 drivers/scsi/BusLogic.c        |   13 +++++
 fs/exec.c                      |    6 ++
 fs/nfs/dir.c                   |    3 -
 fs/nfs/inode.c                 |    4 -
 include/linux/types.h          |    2 
 include/net/checksum.h         |   42 ++++++++++--------
 include/net/ip6_checksum.h     |   76 ++++++++++++++++-----------------
 net/atm/mpc.c                  |    7 +++
 net/ipv4/route.c               |    8 +--
 16 files changed, 133 insertions(+), 91 deletions(-)

