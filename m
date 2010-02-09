Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab0BIKwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:52:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:41675 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0BIKwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:52:16 -0500
Date: Tue, 9 Feb 2010 10:51:44 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1265424425-31562-4-git-send-email-dzickus@redhat.com>
References: <1265424425-31562-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Only enable on x86 for now
Message-ID: <tip-8e7672cdb413af859086ffceaed68f7e1e8ea4c2@git.kernel.org>
Git-Commit-ID: 8e7672cdb413af859086ffceaed68f7e1e8ea4c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 10:51:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e7672cdb413af859086ffceaed68f7e1e8ea4c2
Gitweb:     http://git.kernel.org/tip/8e7672cdb413af859086ffceaed68f7e1e8ea4c2
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 9 Feb 2010 06:11:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 9 Feb 2010 06:11:00 +0100

nmi_watchdog: Only enable on x86 for now

It wont even build on other platforms just yet - so restrict it
to x86 for now.

Cc: Don Zickus <dzickus@redhat.com>
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
Cc: peterz@infradead.org
LKML-Reference: <1265424425-31562-4-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f80b67e..acef882 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -173,6 +173,7 @@ config DETECT_SOFTLOCKUP
 config NMI_WATCHDOG
 	bool "Detect Hard Lockups with an NMI Watchdog"
 	depends on DEBUG_KERNEL && PERF_EVENTS
+	depends on X86
 	default y
 	help
 	  Say Y here to enable the kernel to use the NMI as a watchdog
