Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbYCGWfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbYCGWfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYCGWfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:35:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:62935 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188AbYCGWfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:35:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kgdb: Fixes and regression tests
Date: Fri,  7 Mar 2008 16:34:15 -0600
Message-Id: <1204929257-9967-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 07 Mar 2008 22:34:17.0890 (UTC) FILETIME=[61344820:01C880A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To aid in the porting of additional archs for kgdb as well as to
continue to check that new changes have not broken kgdb, a kgdb test
suite has been created.  The objective is to test the kgdb core and
some features of the arch support such as SW/HW breakpoints, SMP
concurrency, single stepping and the NMI watch dog.

By default the kgdb test suite would not be compiled into the kernel.
It main purpose is to test kgdb internals.

Running the regression tests against kgdb has found several problems.
The first patch in the series addresses the regressions found from
running the kgdb test suite.  The second patch in the series is the
kgdb test suite itself.

Jason.

The following changes since commit 9b747d4ea3c90a5cda4e295bd0c1257eba3091ca:
  Jason Wessel (1):
        kgdb: support for ARCH=arm

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_ingo

Jason Wessel (2):
      kgdb: fix several kgdb regressions
      kgdb: Add kgdb internal test suite

 arch/x86/kernel/kgdb.c     |    4 +
 arch/x86/kernel/traps_64.c |    7 +-
 drivers/misc/Makefile      |    1 +
 drivers/misc/kgdbts.c      | 1083 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/kgdb.c              |   14 +-
 lib/Kconfig.kgdb           |   13 +
 6 files changed, 1115 insertions(+), 7 deletions(-)
 create mode 100644 drivers/misc/kgdbts.c

