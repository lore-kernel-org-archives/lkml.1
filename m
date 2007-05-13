Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbXEMQo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbXEMQo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbXEMQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:44:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58564 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbXEMQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:44:19 -0400
Date: Sun, 13 May 2007 13:38:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1179074641.4003.22.camel@localhost>
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

For two Kconfig fixes for non-x86 archs, a sysfs fix on dvb core, and a 
fix on usage count to allow removing dst driver without forcing.

Cheers,
Mauro.

---

 drivers/media/dvb/bt8xx/dst.c          |    3 ---
 drivers/media/dvb/dvb-core/dvbdev.c    |   15 +++++++++++----
 drivers/media/video/em28xx/Kconfig     |    1 -
 drivers/media/video/ivtv/Kconfig       |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h |    8 --------
 5 files changed, 12 insertions(+), 17 deletions(-)

Manu Abraham (1):
      V4L/DVB (5639a): Fix dst usage count

Mauro Carvalho Chehab (2):
      V4L/DVB (5640): Fix: em28xx currently doesn't require VIDEO_BUF
      V4L/DVB (5639): Fix Kconfig dependencies for ivtv

Simon Arlott (1):
      V4L/DVB (5630): Dvb-core: Handle failures to create devices

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

