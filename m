Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbXCENDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbXCENDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXCENDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:03:19 -0500
Received: from tim.rpsys.net ([194.106.48.114]:45414 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbXCENDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:03:18 -0500
Subject: [GIT PULL] Backlight updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 12:59:52 +0000
Message-Id: <1173099592.5842.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull from:
git://git.o-hand.com/linux-rpurdie-backlight for-linus

to receive some backlight updates to address a couple of regressions. 

The fixes have been confirmed by the reporters. The regressions are
being tracked by Adrian.

Thanks,

Richard

 drivers/video/aty/aty128fb.c        |   12 +++++++++++-
 drivers/video/aty/atyfb_base.c      |   10 +++++++++-
 drivers/video/aty/radeon_base.c     |   10 +++++++++-
 drivers/video/nvidia/nv_backlight.c |    4 +---
 drivers/video/nvidia/nvidia.c       |   12 +++++++++++-
 drivers/video/riva/fbdev.c          |   12 +++++++++++-
 6 files changed, 52 insertions(+), 8 deletions(-)

Richard Purdie (2):
      backlight: Fix nvidia backlight initial brightness
      backlight: Allow enable/disable of fb backlights, fixing regressions


