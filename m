Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbZHRBQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbZHRBQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 21:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758516AbZHRBQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 21:16:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:60675 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247AbZHRBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 21:16:08 -0400
Date: Tue, 18 Aug 2009 10:16:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.31-rc7
Message-ID: <20090818011609.GB4402@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up a couple of suspend bugs (primarily impacting the SH7724
CPU and its associated solution engine board). While technically not
regressions, and a bit bigger than I would care for at this point, these
changes are necessary for fixing up crash on resume for SH7724, spurious
wakeups for CMT clocksource/clockevent users, and suspend crashes in the
fb driver for platforms using deferred I/O.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.31

Which contains:

Magnus Damm (4):
      sh: skip disabled LCDC channels
      sh: CMT suspend/resume
      sh: use in-soc KEYSC on se7724
      sh: sh7724 ddr self-refresh changes

 arch/sh/boards/mach-se/7724/setup.c |    9 ++--
 arch/sh/kernel/cpu/shmobile/sleep.S |   70 ++++++++++++++++++++++++++++++++++-
 drivers/clocksource/sh_cmt.c        |   28 ++++++++++++++
 drivers/video/sh_mobile_lcdcfb.c    |    5 ++
 4 files changed, 106 insertions(+), 6 deletions(-)
