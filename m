Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXDOQH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXDOQH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXDOQH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:07:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48541 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbXDOQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:07:28 -0400
Date: Sun, 15 Apr 2007 12:31:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-Id: <1176653207.10849.5.camel@localhost>
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

   - Fix Kernel Bugzilla #8301: spinlock fix for flexcop-pci
   - Fix 1/3 for bug 7819: fixed frontend hotplug issue
   - Fix 2/3 for bug 7819: demux and dvr
   - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
   - Usbvision: fix TDA9887 detection
   - Bt878: prevent probing wrong card entry

The fix for Bugzilla #7819 is bigger, since the current lock approach 
doesn't allow hotunplugging an USB DVB device. The other patches are 
trivial fixes.

Cheers,
Mauro.

---

 Documentation/logo.gif                             |  Bin
 drivers/media/dvb/b2c2/flexcop-pci.c               |    9 ++--
 drivers/media/dvb/bt8xx/bt878.c                    |    4 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |   56 +++++++++++++++++++-
 drivers/media/dvb/dvb-core/dmxdev.h                |    2 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   20 ++++++-
 drivers/media/dvb/dvb-core/dvb_net.c               |   32 +++++++++++-
 drivers/media/dvb/dvb-core/dvb_net.h               |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c                |    1 +
 drivers/media/dvb/dvb-core/dvbdev.h                |    1 +
 drivers/media/video/usbvision/usbvision-i2c.c      |    1 +
 11 files changed, 115 insertions(+), 12 deletions(-)

Akinobu Mita (1):
      V4L/DVB (5513): Bt878: prevent probing wrong card entry

Hendrik Borghorst (1):
      V4L/DVB (5505): Fix Kernel Bugzilla #8301: spinlock fix for flexcop-pci

Markus Rechberger (3):
      V4L/DVB (5510): Fix 1/3 for bug 7819: fixed frontend hotplug issue
      V4L/DVB (5511): Fix 2/3 for bug 7819: demux and dvr
      V4L/DVB (5512): Fix 3/3 for bug 7819: fixed hotplugging for dvbnet

Thierry MERLE (1):
      V4L/DVB (5524): Usbvision: fix TDA9887 detection

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

