Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbXKEUcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbXKEUcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXKEUcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:32:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43314 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKEUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:32:11 -0500
Date: Sun, 04 Nov 2007 21:18:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1194294717.5421.26.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.1-1mdv2008.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - Some Kconfig fixes;
   - Updates missing entries at CARDLIST.em28xx;
   - Several driver fixes at bttv, cafe_ccic, s5h1409, mt2131, saa7134, planb, 
	saa7146, ves1820, tda10021, stv0297, pvrusb2, em28xx, tvp5150.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.em28xx   |    3 +
 drivers/media/Kconfig                       |    1 +
 drivers/media/common/saa7146_core.c         |   70 ++++++++++++++++----
 drivers/media/dvb/frontends/mt2131.c        |    2 +-
 drivers/media/dvb/frontends/s5h1409.c       |   96 ++++++++++++++++++++++++---
 drivers/media/dvb/frontends/stv0297.c       |   22 +++++--
 drivers/media/dvb/frontends/tda10021.c      |    6 ++
 drivers/media/dvb/frontends/ves1820.c       |    2 +-
 drivers/media/dvb/ttpci/Kconfig             |    2 +-
 drivers/media/video/Kconfig                 |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c     |    6 +-
 drivers/media/video/cafe_ccic.c             |    6 ++
 drivers/media/video/cx23885/Kconfig         |    2 +-
 drivers/media/video/cx88/Kconfig            |    2 +-
 drivers/media/video/em28xx/Kconfig          |    2 +-
 drivers/media/video/em28xx/em28xx-i2c.c     |    6 +-
 drivers/media/video/em28xx/em28xx-video.c   |    1 +
 drivers/media/video/planb.c                 |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c  |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-main.c  |    5 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    8 --
 drivers/media/video/saa7134/Kconfig         |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c  |   16 ++++-
 drivers/media/video/saa7134/saa7134-cards.c |    4 +-
 drivers/media/video/tuner-core.c            |    6 +--
 drivers/media/video/tvp5150.c               |   16 ++--
 26 files changed, 225 insertions(+), 73 deletions(-)

Adrian Bunk (1):
      V4L/DVB (6432): tuner: fix CONFIG_TUNER_TEA5761=m

Alexander E. Patrakov (1):
      V4L/DVB (6506): saa7134-alsa: Fix mmap support

Brandon Philips (1):
      V4L/DVB (6547): V4L: remove PCI from VIDEO_VIVI depends

Hartmut Birr (3):
      V4L/DVB (6499): tda10021: Bit error counting fixed
      V4L/DVB (6500): tda10021: Fix reported signal strength
      V4L/DVB (6501): stv0297: Signal strength fixes

Jeff Garzik (1):
      V4L/DVB (6407): planb: fix obvious interrupt handling bugs

Jonathan Corbet (2):
      V4L/DVB (6394): Fix a cafe_ccic resume bug
      V4L/DVB (6395): cafe_ccic: Add a pointer to the data sheet

Ludovico Cavedon (1):
      V4L/DVB (6531): Fix a regression caused by commit 153962364dc6fa4a24571885fbe76506d8968610

Mauro Carvalho Chehab (3):
      V4L/DVB (6390): Updates missing entries at CARDLIST.em28xx
      V4L/DVB (6518): Fix tvp5150 default values
      V4L/DVB (6532): Add the remaining addresses for tda9887

Mike Isely (2):
      V4L/DVB (6504): pvrusb2: Remove dead sysfs code
      V4L/DVB (6548): pvrusb2: Fix oops on module removal

Oliver Endriss (2):
      V4L/DVB (6495): saa7146: saa7146_wait_for_debi_done fixes
      V4L/DVB (6498): ves1820: Change the acquisition range for clock recovery from 120 ppm to 240ppm

Randy Dunlap (2):
      V4L/DVB (6478): ir-functions use input functions, should depend on INPUT
      V4L/DVB (6479): use input functions, should depend on INPUT

Roel Kluin (1):
      V4L/DVB (6503): pvrusb2: Fix associativity logic error

Steven Toth (2):
      V4L/DVB (6402): s5h1409: Fix broken QAM support
      V4L/DVB (6403): mt2131: replace comma with semicolon fix

Trent Piepho (3):
      V4L/DVB (6391): bttv: SPICT ioctl doesn't work with vlc
      V4L/DVB (6392): bttv: Update initial image size when set via V4L1 VIDIOCMCAPTURE
      V4L/DVB (6514): em28xx: Include linux/mm.h

hermann pitton (1):
      V4L/DVB (6406): saa7134: fix analog audio in on medion md8800 quadro

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

