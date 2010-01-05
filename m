Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141Ab0AEH2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0AEH2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069Ab0AEH2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:28:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39102
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab0AEH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:28:32 -0500
Date: Mon, 04 Jan 2010 23:28:35 -0800 (PST)
Message-Id: <20100104.232835.124284338.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix some fundamental perf issues that were undiscovered until perf top
started using rate based profiling by default.

Fix a crash in bbc_envctrl on unload if kthread_run() fails during
load.  Still need to figure out why kthread_run() is erroring out
though...

Please pull, thanks a lot!

The following changes since commit c5974b835a909ff15c3b7e6cf6789b5eb919f419:
  Linus Torvalds (1):
        Merge branch 'limits_cleanup' of git://decibel.fi.muni.cz/~xslaby/linux

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      bbc_envctrl: Clean up properly if kthread_run() fails.
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      sparc64: Fix NMI programming when perf events are active.
      sparc64: Fix Niagara2 perf event handling.

 arch/sparc/kernel/nmi.c         |    3 +-
 arch/sparc/kernel/perf_event.c  |   11 +++++++
 drivers/sbus/char/bbc_envctrl.c |   64 +++++++++++++++++++++++----------------
 3 files changed, 51 insertions(+), 27 deletions(-)
