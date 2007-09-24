Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbXIXWX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbXIXWX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXIXWXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:23:48 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37515 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754548AbXIXWXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:23:47 -0400
Date: Tue, 25 Sep 2007 00:24:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.54-rc1
Message-ID: <20070924222405.GK6800@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.53:

Adrian Bunk (1):
      Linux 2.6.16.54-rc1

Alexander Shmelev (1):
      [SPARC32]: Fix bug in sparc optimized memset.

David S. Miller (1):
      [MATH-EMU]: Fix underflow exception reporting.

Ilpo Järvinen (1):
      TCP: Fix TCP handling of SACK in bidirectional flows

James Bottomley (1):
      [MCA] fix bus matching

Konstantin Sharlaimov (2):
      [PPP]: Fix osize too small errors when decoding mppe.
      [PPP]: Fix output buffer size in ppp_decompress_frame().

Mark Fortescue (1):
      [SPARC32]: Fix rounding errors in ndelay/udelay implementation.

Neil Brown (16):
      md: Add '4' to the list of levels for which bitmaps are supported
      md: Don't clear bits in bitmap when writing to one device fails during recovery
      md/bitmap: fix online removal of file-backed bitmaps
      md/bitmap: cleaner separation of page attribute handlers in md/bitmap
      md/bitmap: use set_bit etc for bitmap page attributes
      md/bitmap: remove unnecessary page reference manipulations from md/bitmap code
      md/bitmap: remove dead code from md/bitmap
      md/bitmap: tidy up i_writecount handling in md/bitmap
      md: Allow re-add to work on array without bitmaps
      md: fix resync speed calculation for restarted resyncs
      md: fix a plug/unplug race in raid5
      md: fix some small races in bitmap plugging in raid5
      md: allow SET_BITMAP_FILE to work on 64bit kernel with 32bit userspace
      md: assorted md and raid1 one-liners
      md: fix a few problems with the interface (sysfs and ioctl) to md
      md: avoid possible BUG_ON in md bitmap handling


 Makefile                          |    2 
 arch/sparc/kernel/entry.S         |   14 ++-
 arch/sparc/lib/memset.S           |    2 
 drivers/mca/mca-bus.c             |    2 
 drivers/md/bitmap.c               |  126 +++++++++++++-----------------
 drivers/md/md.c                   |  107 +++++++++++++++----------
 drivers/md/raid1.c                |   20 ++++
 drivers/md/raid5.c                |   46 +++++++---
 drivers/net/ppp_generic.c         |   15 +++
 include/asm-sparc/sfp-machine.h   |    6 +
 include/asm-sparc64/sfp-machine.h |    2 
 include/linux/compat_ioctl.h      |    2 
 include/linux/raid/bitmap.h       |    3 
 include/linux/raid/md_k.h         |    3 
 include/math-emu/op-common.h      |    5 -
 include/math-emu/soft-fp.h        |    7 +
 net/ipv4/tcp_input.c              |    5 -
 17 files changed, 226 insertions(+), 141 deletions(-)
