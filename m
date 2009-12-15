Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbZLOUhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbZLOUhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbZLOUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:37:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53957 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933525AbZLOUhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:37:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] More PM updates for 2.6.33
Date: Tue, 15 Dec 2009 21:37:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912152137.38985.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some more power management updates for 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Runtime PM core fix from Alan Stern.

* Patch from Arjan allowing us to measure and chart device suspend/resume times
  (I think this is going to be useful regardless of the async suspend/resume)

* Two minor PM core fixes from me.


 drivers/base/power/main.c    |   44 ++++++++++++++++++++++++++++++++---------
 drivers/base/power/runtime.c |   10 ++++----
 include/linux/init.h         |    2 +
 3 files changed, 41 insertions(+), 15 deletions(-)

---------------

Alan Stern (1):
      PM: allow for usage_count > 0 in pm_runtime_get()

Arjan van de Ven (1):
      PM: Add initcall_debug style timing for suspend/resume

Rafael J. Wysocki (2):
      PM: Remove unnecessary goto from device_resume_noirq()
      PM: rwsem.h need not be included into main.c


This doesn't include the async suspend/resume patchset, because I'm still
running tests on it.  Thanks!
