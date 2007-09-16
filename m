Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbXIPNo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbXIPNo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 09:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXIPNou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 09:44:50 -0400
Received: from www.tglx.de ([213.239.205.147]:40076 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbXIPNot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 09:44:49 -0400
X-Greylist: delayed 87384 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Sep 2007 09:44:49 EDT
Subject: clockevents - regression fixes for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 16 Sep 2007 15:44:47 +0200
Message-Id: <1189950287.4319.18.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the clockevents regression fixes from my hrt tree.

Thanks,
	tglx

The following changes since commit d0174640eedc1cd756754f03afe2dbb3d56de74e:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of master.kernel.org:/.../jgarzik/netdev-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git for-2.6.23

Thomas Gleixner (5):
      timekeeping: access rtc outside of xtime lock
      timekeeping: Prevent time going backwards on resume
      clockevents: Enforce oneshot broadcast when broadcast mask is set on resume
      clockevents: do not shutdown the oneshot broadcast device
      clockevents: prevent stale tick update on offline cpu

Venkatesh Pallipadi (1):
      ACPI: Reevaluate C/P/T states when a cpu becomes online

 drivers/acpi/processor_core.c |   21 +++++++++++++++++++++
 kernel/time/tick-broadcast.c  |   24 ++++++++++++++++--------
 kernel/time/tick-sched.c      |   12 ++++++++++++
 kernel/time/timekeeping.c     |   10 +++++++++-
 4 files changed, 58 insertions(+), 9 deletions(-)


