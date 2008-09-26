Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYIZHo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYIZHo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYIZHou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:44:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63211 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYIZHot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:44:49 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Fri, 26 Sep 2008 12:21:45 +0300
Message-Id: <20080926092145.3290.59352.sendpatchset@gollum>
Subject: [GIT PULL] UBIFS updates for 2.6.27-rc8
X-OriginalArrivalTime: 26 Sep 2008 07:44:02.0263 (UTC) FILETIME=[A4DDAE70:01C91FAB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

git://git.infradead.org/~dedekind/ubifs-2.6.git linux-next

The following changes since commit adee14b2e1557d0a8559f29681732d05a89dfc35:
  Linus Torvalds (1):
        Linux 2.6.27-rc6

are available:

Adrian Hunter (2):
      UBIFS: TNC / GC race fixes
      UBIFS: remove incorrect assert

Alexander Beregalov (1):
      UBIFS: fix printk format warnings

Sebastian Siewior (1):
      UBIFS: create the name of the background thread in every case

 fs/ubifs/debug.c |    2 +-
 fs/ubifs/dir.c   |    2 +-
 fs/ubifs/find.c  |    1 -
 fs/ubifs/gc.c    |   14 +++++++++++---
 fs/ubifs/super.c |    3 +--
 fs/ubifs/tnc.c   |    2 +-
 6 files changed, 15 insertions(+), 9 deletions(-)

These all are fix-only patches of course.

The most important one is
UBIFS: create the name of the background thread in every case
reported here:
http://lists.infradead.org/pipermail/linux-mtd/2008-September/022964.html

The
UBIFS: TNC / GC race fixes
problem was not publically reported, but was found and fixed by us
in Nokia.

These:
UBIFS: remove incorrect assert
UBIFS: fix printk format warnings
are just tiny fixes, which affect only UBIFS debugging mode,
but it would be nice to have them in 2.6.27 as well.

Thanks.
