Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXINQpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXINQpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbXINQpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:45:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43728 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620AbXINQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:45:12 -0400
Date: Fri, 14 Sep 2007 13:41:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1189788294.2363.0.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following driver fixes:

   - ivtv: fix VIDIOC_G_ENC_INDEX flag handling
   - saa7134: mux setup for composite sound on AverTV 307
   - Pwc: Fix a broken debug message
   - saa7191: Fix a warning at saa7191_probe
   - cx88: Avoid a NULL pointer dereference during mpeg_open()
   - cpia documentation: Remove reference to dead "cpia_pp=" boot-time
        option

I've also added your fix for et61x251 driver, when V4L1_COMPAT is not 
selected:
   - fix build error for et61x251 driver

Cheers,
Mauro.

---

 Documentation/kernel-parameters.txt                |   23 ++++++++-----------
 .../video4linux/cx2341x/fw-encoder-api.txt         |    4 ++-
 drivers/media/video/cx88/cx88-mpeg.c               |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    6 +++-
 drivers/media/video/ivtv/ivtv-ioctl.c              |   17 ++++++++++----
 drivers/media/video/pwc/pwc-if.c                   |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   12 +++++-----
 drivers/media/video/saa7191.c                      |    4 +-
 include/media/v4l2-dev.h                           |    5 ++-
 9 files changed, 42 insertions(+), 33 deletions(-)

Hans Verkuil (1):
      V4L/DVB (6095): ivtv: fix VIDIOC_G_ENC_INDEX flag handling

Jean Delvare (1):
      V4L/DVB (6147): Pwc: Fix a broken debug message

Linus Torvalds (1):
      V4L/DVB (6220a): fix build error for et61x251 driver

Mauro Carvalho Chehab (1):
      V4L/DVB (6148): Fix a warning at saa7191_probe

Robert P. J. Day (1):
      V4L/DVB (6173a): Documentation: Remove reference to dead "cpia_pp=" boot-time option

Stas Sergeev (1):
      V4L/DVB (6144): Fix mux setup for composite sound on AverTV 307

Steven Toth (1):
      V4L/DVB (6188): Avoid a NULL pointer dereference during mpeg_open()

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

