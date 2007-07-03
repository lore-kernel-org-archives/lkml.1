Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbXGCTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbXGCTlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXGCTlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:41:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52871 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbXGCTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:41:13 -0400
Date: Tue, 03 Jul 2007 16:20:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1183491061.3926.193.camel@gaivota>
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

For some fixes on V4L/DVB low-level drivers:

   - bttv: fixes a very weird error when used with a v4l1 application;
   - cx88-blackbird: fixes an endless loop at userspace apps, when 
                     trying to request the list of tuners;
   - ttpci: fixes error handling at init() function;
   - cinergyT2: corrects bad locks on work queue.

Cheers,
Mauro.

---

 drivers/media/dvb/cinergyT2/cinergyT2.c   |   66 +++++++++++++++++-----------
 drivers/media/dvb/ttpci/budget-core.c     |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c   |   13 +++---
 drivers/media/video/cx88/cx88-blackbird.c |    2 +
 4 files changed, 49 insertions(+), 34 deletions(-)

Hartmut Birr (1):
      V4L/DVB (5822): Fix the return value in ttpci_budget_init()

Jelle Foks (1):
      V4L/DVB (5816): Cx88-blackbird: fix vidioc_g_tuner never ending list of tuners

Oleg Nesterov (1):
      V4L/DVB (5818): CinergyT2: fix flush_workqueue() vs work->func() deadlock

Trent Piepho (1):
      V4L/DVB (5808): Bttv: fix v4l1 breaking the driver

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

