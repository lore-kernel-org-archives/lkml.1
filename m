Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXDOWLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXDOWLG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 18:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXDOWLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 18:11:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51537 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754012AbXDOWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 18:11:04 -0400
Date: Mon, 16 Apr 2007 00:11:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.48
Message-ID: <20070415221112.GI3691@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.47:

Adrian Bunk (2):
      Linux 2.6.16.48-rc1
      Linux 2.6.16.48

Andreas Oberritter (1):
      V4L/DVB: Pluto2: fix incorrect TSCR register setting

David Brownell (1):
      USB: usbnet driver bugfix

Francois Romieu (3):
      r8169: fix a race between PCI probe and dev_open
      r8169: fix suspend/resume for down interface
      r8169: issue request_irq after the private data are completely initialized

Herbert Xu (1):
      [IPSEC]: Reject packets within replay window but outside the bit mask

John Heffner (1):
      [TCP]: Do receiver-side SWS avoidance for rcvbuf < MSS.

Michael Krufky (1):
      V4L: tveeprom: autodetect LG TAPC G701D as tuner type 37

Oliver Endriss (1):
      V4L: saa7146: Fix allocation of clipping memory

Patrick McHardy (2):
      [NET_SCHED]: cls_basic: fix memory leak in basic_destroy
      [NET_SCHED]: cls_tcindex: fix compatibility breakage

Stephen Hemminger (3):
      skge: turn carrier off when down
      sky2: turn carrier off when down
      sky2: turn on clocks when doing resume

Thomas Gleixner (1):
      i386: fix file_read_actor() and pipe_read() for original i386 systems

Trent Piepho (1):
      V4L: radio: Fix error in Kbuild file

YOSHIFUJI Hideaki (1):
      [IPv6]: Fix incorrect length check in rawv6_sendmsg()


 Makefile                          |    2 -
 arch/i386/lib/usercopy.c          |    9 ++++
 drivers/media/dvb/pluto2/pluto2.c |   22 +++++++----
 drivers/media/radio/Kconfig       |    2 -
 drivers/media/video/tveeprom.c    |    2 -
 drivers/net/r8169.c               |   56 ++++++++++++++++--------------
 drivers/net/skge.c                |    1 
 drivers/net/sky2.c                |    8 ++++
 drivers/usb/net/usbnet.c          |    7 ++-
 include/media/saa7146_vv.h        |    3 +
 net/ipv4/tcp_output.c             |    3 +
 net/ipv6/raw.c                    |    4 +-
 net/ipv6/udp.c                    |    2 -
 net/sched/cls_basic.c             |    1 
 net/sched/cls_tcindex.c           |    4 +-
 net/xfrm/xfrm_state.c             |    3 +
 16 files changed, 83 insertions(+), 46 deletions(-)

