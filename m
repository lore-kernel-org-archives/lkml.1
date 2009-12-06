Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZLFPrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZLFPrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 10:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZLFPrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 10:47:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZLFPrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 10:47:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM updates for 2.6.33 (updated)
Date: Sun, 6 Dec 2009 16:47:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912061647.38169.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Fixes for the runtime PM framework from Alan Stern and me.

* Hibernate cleanups from Nigel and Jiri Slaby.

* Freezer optimisation from Tejun.


 Documentation/power/runtime_pm.txt |   12 ++-
 drivers/base/power/runtime.c       |   23 ++++---
 include/linux/pm.h                 |    8 ++-
 include/linux/pm_runtime.h         |   12 +++
 kernel/power/Makefile              |    2 +-
 kernel/power/hibernate.c           |   30 ++++++++
 kernel/power/main.c                |    1 +
 kernel/power/process.c             |   14 +++-
 kernel/power/swap.c                |  107 ++++++++++++++++++++++++++++-
 kernel/power/swsusp.c              |  130 ------------------------------------
 10 files changed, 184 insertions(+), 155 deletions(-)

---------------

Alan Stern (2):
      PM / Runtime: Export the PM runtime workqueue
      PM / Runtime: Use deferred_resume flag in pm_request_resume

Jiri Slaby (1):
      PM / Hibernate: Swap, use KERN_CONT

Nigel Cunningham (2):
      PM / Hibernate: Move swap functions to kernel/power/swap.c.
      PM / Hibernate: Shift remaining code from swsusp.c to hibernate.c

Rafael J. Wysocki (5):
      PM / Runtime: Fix lockdep warning in __pm_runtime_set_status()
      PM / Runtime: Ensure timer_expires is nonzero in pm_schedule_suspend()
      PM / Runtime: Make documentation of runtime_idle() agree with the code
      PM / Runtime: Remove unnecessary braces in __pm_runtime_set_status()
      PM: Add flag for devices capable of generating run-time wake-up events

Tejun Heo (1):
      PM / freezer: Don't get over-anxious while waiting

