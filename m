Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbYASNVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbYASNVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYASNU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:20:58 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54595 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYASNU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:20:57 -0500
Date: Sat, 19 Jan 2008 15:19:42 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.59
Message-ID: <20080119131942.GC8669@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.58:
- CVE-2006-6058: limit minixfs printks on corrupted dir i_size
- CVE-2007-5500: wait_task_stopped: Check p->exit_state instead of TASK_TRACED
- CVE-2008-0001: Use access mode instead of open flags to determine needed permissions


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.58:

Adrian Bunk (3):
      struct input_device_id mustn't be userspace visible
      Linux 2.6.16.59-rc1
      Linux 2.6.16.59

Al Viro (1):
      missing dma_sync_single_range_for_{cpu,device} on alpha

David S. Miller (1):
      [SPARC64]: Fix endless loop in cheetah_xcall_deliver().

Denis Vlasenko (1):
      fix messages in fs/minix

Eric Sandeen (1):
      limit minixfs printks on corrupted dir i_size (CVE-2006-6058)

Evgeniy Polyakov (1):
      [IPV6]: Restore IPv6 when MTU is big enough

Herbert Xu (2):
      [IPV4] raw: Strengthen check on validity of iph->ihl
      [IPSEC]: Avoid undefined shift operation when testing algorithm ID

Ivan Kokshaysky (1):
      include/asm-alpha/io_trivial.h build fixes

Li Zefan (1):
      CONNECTOR: don't touch queue dev after decrement of ref count

Linus Torvalds (1):
      Use access mode instead of open flags to determine needed permissions (CVE-2008-0001)

Mark McLoughlin (1):
      [INET]: Fix netdev renaming and inet address labels

Maximilian Attems (1):
      [IRDA]: irda_create() nuke user triggable printk

Roland McGrath (1):
      wait_task_stopped: Check p->exit_state instead of TASK_TRACED (CVE-2007-5500)

Russ Dill (1):
      [NET] kaweth was forgotten in msec switchover of usb_start_wait_urb


 Makefile                        |    2 +-
 arch/sparc64/kernel/smp.c       |   19 +++++++++++++------
 drivers/connector/cn_queue.c    |    2 +-
 drivers/usb/net/kaweth.c        |    2 +-
 fs/minix/bitmap.c               |   10 +++++-----
 fs/minix/inode.c                |   26 +++++++++++++-------------
 fs/minix/itree_v1.c             |    9 +++++++--
 fs/minix/itree_v2.c             |    9 +++++++--
 fs/namei.c                      |    4 ++--
 include/asm-alpha/dma-mapping.h |   14 ++++++++------
 include/asm-alpha/io_trivial.h  |   12 ++++++++----
 include/linux/input.h           |    3 +++
 kernel/exit.c                   |    3 +--
 net/ipv4/devinet.c              |    2 +-
 net/ipv4/raw.c                  |    4 +++-
 net/ipv6/addrconf.c             |   11 ++++++++++-
 net/irda/af_irda.c              |    2 --
 net/key/af_key.c                |   14 ++++++++++++--
 18 files changed, 96 insertions(+), 52 deletions(-)
