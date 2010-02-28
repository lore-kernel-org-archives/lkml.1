Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031936Ab0B1Txk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:53:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:38864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936463Ab0B1Txi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:53:38 -0500
Date: Sun, 28 Feb 2010 19:52:12 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
References: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Turn it off by default
Message-ID: <tip-c99c30feadf664ccd8590b96259cb9f3954bd246@git.kernel.org>
Git-Commit-ID: c99c30feadf664ccd8590b96259cb9f3954bd246
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 19:52:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c99c30feadf664ccd8590b96259cb9f3954bd246
Gitweb:     http://git.kernel.org/tip/c99c30feadf664ccd8590b96259cb9f3954bd246
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 28 Feb 2010 20:49:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 28 Feb 2010 20:49:00 +0100

nmi_watchdog: Turn it off by default

It was nice to enable it by default for testing - but before we
push it upstream we want it to be off - so that people can
opt-in gradually.

Cc: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
LKML-Reference: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 01a4d85..e2e73cc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -173,7 +173,6 @@ config DETECT_SOFTLOCKUP
 config NMI_WATCHDOG
 	bool "Detect Hard Lockups with an NMI Watchdog"
 	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI
-	default y
 	help
 	  Say Y here to enable the kernel to use the NMI as a watchdog
 	  to detect hard lockups.  This is useful when a cpu hangs for no
