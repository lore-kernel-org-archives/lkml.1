Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbXDKOOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbXDKOOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbXDKOOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:14:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47593 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752800AbXDKOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:14:01 -0400
Date: Wed, 11 Apr 2007 16:14:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.47-rc1
Message-ID: <20070411141408.GC10141@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.46:
- CVE-2007-1357: APPLETALK: Fix a remotely triggerable crash


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.46:

Adrian Bunk (1):
      Linux 2.6.16.47-rc1

Al Viro (1):
      b44: src_desc->addr is little-endian

Alan Cox (1):
      ide-floppy: Fix unformatted media crash

David Moore (1):
      ieee1394: video1394: DMA fix

David S. Miller (1):
      [VIDEO] ffb: Fix two DAC handling bugs.

Eric W. Biederman (1):
      Fix reparenting to the same thread group. (take 2)

Jean Delvare (1):
      APPLETALK: Fix a remotely triggerable crash (CVE-2007-1357)

Jeff Garzik (1):
      [netdrvr] tulip, de2104x: fix typo: s/__sparc_/__sparc__/

Patrick McHardy (1):
      [IFB]: Fix crash on input device removal

Sergei Shtylyov (1):
      siimage: PIO1/2 taskfile transfer overclocking fix

Stephen Hemminger (1):
      tcp: fix cubic scaling error

Thomas Gleixner (3):
      prevent timespec/timeval to ktime_t overflow
      fix MTIME_SEC_MAX on 32-bit
      hrtimer: prevent overrun DoS in hrtimer_forward()


 Makefile                       |    2 
 drivers/ide/ide-floppy.c       |    3 -
 drivers/ide/pci/siimage.c      |   59 +++++++++++------------
 drivers/ieee1394/video1394.c   |    8 +++
 drivers/net/b44.c              |    2 
 drivers/net/ifb.c              |   35 +++++--------
 drivers/net/tulip/de2104x.c    |    2 
 drivers/net/tulip/tulip_core.c |    2 
 drivers/video/ffb.c            |   84 +++++++++++++++++++++++----------
 include/linux/ktime.h          |   11 +++-
 include/linux/skbuff.h         |    5 +
 include/net/pkt_cls.h          |    7 +-
 kernel/exit.c                  |   29 +++++++----
 kernel/hrtimer.c               |    6 ++
 net/appletalk/ddp.c            |    7 +-
 net/core/dev.c                 |    8 +--
 net/core/skbuff.c              |    2 
 net/ipv4/tcp_cubic.c           |    6 +-
 net/sched/act_mirred.c         |    2 
 19 files changed, 172 insertions(+), 108 deletions(-)

