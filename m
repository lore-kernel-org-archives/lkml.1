Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103Ab0AUR1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0AUR1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534Ab0AUR1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:27:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:35932 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0AUR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:27:06 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu, peterz@infradead.org
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] softlockup kgdb fix for tip for 2.6.34
Date: Thu, 21 Jan 2010 11:26:30 -0600
Message-Id: <1264094791-8883-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 21 Jan 2010 17:26:34.0018 (UTC) FILETIME=[E0D7C020:01CA9ABE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, would it be possible to pull in this change or recommend what
needs to be done to reach closure on this long standing problem.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_igno

This particular fix for kgdb to allows it to work correctly with the
softlockup code.  It has been around since September 2009 and in
linux-next since the creation of the patch.  I never issued a pull to
the Linus tree because I did not get an ack from either yourself or
Peter.

Thanks,
Jason.


---
short log follows:

The following changes since commit 24bc7347da73a9ed3383056c3d0f28c0e361621e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../wim/linux-2.6-watchdog

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_ingo

Jason Wessel (1):
      softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume

 include/linux/sched.h |    4 ++++
 kernel/kgdb.c         |    6 +++---
 kernel/softlockup.c   |   15 +++++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

