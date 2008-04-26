Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYDZNx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYDZNx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYDZNxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:53:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYDZNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:53:48 -0400
Date: Sat, 26 Apr 2008 10:52:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates for 2.6.26
Message-ID: <20080426105224.1be3563f@gaivota>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:
   - Fix compilation for au0828;
   - several minor fixes at vivi, cx88-blackbird, em28xx, mt312, tuner-xc2028 and 
     pvrusb2;
   - Add a new driver for s5h1411 and correspondings boards at cx88 and 
     pvrusb2-dvb;
   - some cleanups at au0828 and tuner-core;
   - ir-kbd-i2c: Save a temporary memory allocation in ir_probe.

Cheers,
Mauro.

---

 drivers/media/dvb/frontends/Kconfig           |    8 +
 drivers/media/dvb/frontends/Makefile          |    1 +
 drivers/media/dvb/frontends/mt312.h           |    2 +-
 drivers/media/dvb/frontends/s5h1411.c         |  888 +++++++++++++++++++++++++
 drivers/media/dvb/frontends/s5h1411.h         |   90 +++
 drivers/media/video/au0828/Kconfig            |    2 +-
 drivers/media/video/au0828/au0828-cards.c     |    1 -
 drivers/media/video/au0828/au0828-core.c      |   26 +-
 drivers/media/video/au0828/au0828-dvb.c       |    2 +-
 drivers/media/video/au0828/au0828-i2c.c       |    6 +-
 drivers/media/video/au0828/au0828.h           |    8 +-
 drivers/media/video/cx88/Kconfig              |    1 +
 drivers/media/video/cx88/cx88-blackbird.c     |    6 +-
 drivers/media/video/cx88/cx88-cards.c         |    1 +
 drivers/media/video/cx88/cx88-dvb.c           |   32 +
 drivers/media/video/em28xx/em28xx-core.c      |    2 +-
 drivers/media/video/ir-kbd-i2c.c              |   21 +-
 drivers/media/video/pvrusb2/Kconfig           |    1 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.c |   28 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.h |   22 +-
 drivers/media/video/tuner-core.c              |   92 ++--
 drivers/media/video/tuner-xc2028.c            |    2 +-
 drivers/media/video/vivi.c                    |    2 +-
 23 files changed, 1135 insertions(+), 109 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/s5h1411.c
 create mode 100644 drivers/media/dvb/frontends/s5h1411.h

Adrian Bunk (1):
      V4L/DVB (7750): au0828/ cleanups and fixes

Brandon Philips (1):
      V4L/DVB (7735): Fix compilation for au0828

Harvey Harrison (3):
      V4L/DVB (7739): mt312.h: dubious one-bit signed bitfield
      V4L/DVB (7740): tuner-xc2028.c dubious !x & y
      V4L/DVB (7746): pvrusb2: make signed one-bit bitfields unsigned

Janne Grunau (1):
      V4L/DVB (7734): em28xx: copy and paste error in em28xx_init_isoc

Jean Delvare (1):
      V4L/DVB (7751): ir-kbd-i2c: Save a temporary memory allocation in ir_probe

Mauro Carvalho Chehab (2):
      V4L/DVB (7732): vivi: fix a warning
      V4L/DVB (7748): tuner-core: some adjustments at tuner logs, if debug enabled

Michael Krufky (1):
      V4L/DVB (7744): pvrusb2-dvb: add atsc/qam support for Hauppauge pvrusb2 model 751xx

Roel Kluin (1):
      V4L/DVB (7733): blackbird_find_mailbox negative return ignored in blackbird_initialize_codec()

Steven Toth (2):
      V4L/DVB (7741): s5h1411: Adding support for this ATSC/QAM demodulator
      V4L/DVB (7742): cx88: Add support for the DViCO FusionHDTV_7_GOLD digital modes

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
