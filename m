Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbXCZJgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbXCZJgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXCZJgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:36:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56692 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXCZJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:36:07 -0400
Date: Mon, 26 Mar 2007 00:36:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1174881954.4364.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull 'master' from:
        git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

Basically we have some fixes at IR code, a Kconfig fix when Radio is 
selected, some lock fixes at DVB core, Secam on saa7115 will now work 
properly, a fix on msp34xx detection and suspend/resume and a small fix 
on isl6421_attach.

Cheers,
Mauro.

V4L/DVB development is hosted at http://linuxtv.org
---

 drivers/media/common/ir-functions.c    |    6 ++++--
 drivers/media/dvb/dvb-core/dmxdev.c    |   12 +++---------
 drivers/media/dvb/dvb-core/dvb_demux.c |   21 +++++++--------------
 drivers/media/dvb/dvb-core/dvbdev.c    |    9 +++------
 drivers/media/dvb/frontends/isl6421.c  |    1 +
 drivers/media/radio/Kconfig            |    2 +-
 drivers/media/video/msp3400-driver.c   |   14 ++++++--------
 drivers/media/video/saa7115.c          |    2 +-
 drivers/media/video/tuner-core.c       |   10 ++++------
 include/media/saa7146_vv.h             |    3 ++-
 10 files changed, 32 insertions(+), 48 deletions(-)

Hans Verkuil:
      V4L/DVB (5415): Msp_attach must return 0 if no msp3400 was found.

Jean Delvare:
      V4L/DVB (5421): Fix suspend/resume in msp3400 and tuner

Mauro Carvalho Chehab:
      V4L/DVB (5408): Fix SECAM handling on saa7115

Oliver Endriss:
      V4L/DVB (5441): Saa7146: Fix allocation of clipping memory

Simon Arlott:
      V4L/DVB (5400): Core: fix several locking related problems

Thomas Viehweger:
      V4L/DVB (5472): Isl6421: don't reference freed memory

Trent Piepho:
      V4L/DVB (5390): Radio: Fix error in Kbuild file

Vincent Penne:
      V4L/DVB (5332): Ir_rc5_timer_end decoder lockup fix

