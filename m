Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbXHTUB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbXHTUB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXHTUBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:01:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58403 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXHTUBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:01:48 -0400
Date: Mon, 20 Aug 2007 16:55:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1187640017.565.24.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90-1mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - A few ivtv fixes;
   - Updates firmware location for tda10046;
   - Some fixes for OLPC camera;
   - Sets the proper frequency limits on dvb-pll.

Cheers,
Mauro.

---

 Documentation/dvb/get_dvb_firmware    |   24 +++++++++++-----------
 drivers/media/dvb/frontends/dvb-pll.c |    2 +-
 drivers/media/video/cafe_ccic.c       |   35 ++++++++++++++++++++++++++++++--
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 +-
 drivers/media/video/ov7670.c          |    5 +++-
 include/linux/videodev2.h             |    2 -
 6 files changed, 51 insertions(+), 20 deletions(-)

Andreas Arens (1):
      V4L/DVB (6016): get_dvb_firmware: update script for new location of tda10046 firmware

Chris Ball (1):
      V4L/DVB (6026): Avoid powering up the camera on resume

Hans Verkuil (3):
      V4L/DVB (5968): videodev2.h: remove superfluous FBUF GLOBAL_INV_ALPHA support
      V4L/DVB (5967): ivtv: fix VIDIOC_S_FBUF:new OSD values where never set
      V4L/DVB (5969): ivtv: report ivtv version in status log

Jonathan Corbet (1):
      V4L/DVB (6027): Get rid of an ill-behaved msleep in i2c write

Marcelo Tosatti (1):
      V4L/DVB (6028): Turn an unnecessary mdelay() into msleep().

Trent Piepho (1):
      V4L/DVB (5991): dvb-pll: Set minimum and maximum frequency properly

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

