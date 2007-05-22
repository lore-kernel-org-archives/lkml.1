Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbXEVU4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbXEVU4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbXEVU4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:56:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41311 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbXEVU4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:56:44 -0400
Date: Tue, 22 May 2007 17:52:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-Id: <1179867371.32496.98.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - Two fixes on Kconfig dependencies (ivtv and em28xx)
   - Adding new fields to v4l2_pix_format broke the ABI, reverted that change
   - Dvb-core: Handle failures to create devices
   - Fix dst usage count
   - Fix suport for SECAM with FI1216MF
   - OLPC: Cafe_ccic and ov7670 fixes

Cheers,
Mauro.

---

 drivers/media/dvb/bt8xx/dst.c          |    3 ---
 drivers/media/dvb/dvb-core/dvbdev.c    |   15 +++++++++++----
 drivers/media/video/cafe_ccic-regs.h   |    6 ++++++
 drivers/media/video/cafe_ccic.c        |   18 +++++++++++++++++-
 drivers/media/video/em28xx/Kconfig     |    3 +--
 drivers/media/video/ivtv/Kconfig       |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h |    8 --------
 drivers/media/video/ivtv/ivtv-ioctl.c  |   12 ++----------
 drivers/media/video/ov7670.c           |   21 ++++++++++++++++++---
 drivers/media/video/tuner-simple.c     |   10 +++++++---
 include/linux/videodev2.h              |    2 --
 11 files changed, 63 insertions(+), 37 deletions(-)

Hans Verkuil (1):
      V4L/DVB (5670): Adding new fields to v4l2_pix_format broke the ABI, reverted that change

Jonathan Corbet (2):
      V4L/DVB (5690): Cafe_ccic: Properly power down the sensor
      V4L/DVB (5691): Ov7670: reset clkrc in rgb565 mode

Manu Abraham (1):
      V4L/DVB (5639a): Fix dst usage count

Matthieu CASTET (1):
      V4L/DVB (5680): Tuner-simple.c fix suport for SECAM with FI1216MF

Mauro Carvalho Chehab (2):
      V4L/DVB (5639): Fix Kconfig dependencies for ivtv
      V4L/DVB (5640): Fix: em28xx shouldn't be selecting VIDEO_BUF

Simon Arlott (1):
      V4L/DVB (5630): Dvb-core: Handle failures to create devices

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

