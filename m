Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYIHOhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYIHOhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYIHOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:37:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:48129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYIHOh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:37:29 -0400
Date: Mon, 8 Sep 2008 07:35:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.17
Message-ID: <20080908143516.GA7311@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.17
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.25
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.25.16 and 2.6.25.17

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 
 arch/x86/kernel/cpu/mtrr/generic.c |   15 +++++
 crypto/authenc.c                   |   10 ++-
 drivers/net/forcedeth.c            |    4 -
 drivers/net/r8169.c                |    2 
 drivers/usb/class/cdc-acm.c        |    2 
 drivers/video/fb_defio.c           |   19 +++++++
 drivers/video/fbmem.c              |    4 +
 fs/cifs/file.c                     |    4 +
 fs/cramfs/inode.c                  |   84 ++++++++++++++------------------
 fs/nfsd/nfs4acl.c                  |    2 
 include/linux/fb.h                 |    3 +
 mm/page_alloc.c                    |    7 ++
 net/sched/sch_prio.c               |   16 ++++--
 net/sctp/auth.c                    |    7 ++
 net/sctp/endpointola.c             |    4 -
 net/sctp/socket.c                  |   96 ++++++++++++++++++++++++++++---------
 net/sunrpc/sysctl.c                |   18 +-----
 18 files changed, 198 insertions(+), 101 deletions(-)

Adam Litke (1):
      mm: make setup_zone_migrate_reserve() aware of overlapping nodes

Al Viro (1):
      cramfs: fix named-pipe handling

Alexey Dobriyan (1):
      USB: cdc-acm: don't unlock acm->mutex on error path

Ayaz Abdulla (1):
      forcedeth: fix checksum flag

Cyrill Gorcunov (1):
      sunrpc: fix possible overrun on read of /proc/sys/sunrpc/transports

Francois Romieu (1):
      r8169: balance pci_map / pci_unmap pair

Greg Kroah-Hartman (1):
      Linux 2.6.25.17

Herbert Xu (1):
      crypto: authenc - Avoid using clobbered request pointer

Ian Campbell (1):
      fbdefio: add set_page_dirty handler to deferred IO FB

J. Bruce Fields (1):
      nfsd: fix buffer overrun decoding NFSv4 acl

Jeff Layton (1):
      cifs: fix O_APPEND on directio mounts

Thomas Graf (1):
      sch_prio: Fix nla_parse_nested_compat() regression

Vlad Yasevich (4):
      sctp: fix potential panics in the SCTP-AUTH API.
      sctp: add verification checks to SCTP_AUTH_KEY option
      sctp: correct bounds check in sctp_setsockopt_auth_key
      sctp: fix random memory dereference with SCTP_HMAC_IDENT option.

Yinghai Lu (1):
      x86: work around MTRR mask setting

