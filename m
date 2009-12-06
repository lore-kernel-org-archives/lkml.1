Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbZLFKDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbZLFKDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbZLFKDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:03:03 -0500
Received: from www.tglx.de ([62.245.132.106]:48420 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200AbZLFKDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:03:02 -0500
Date: Sun, 6 Dec 2009 11:02:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timers ntp updates for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061101450.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-ntp git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-ntp

Thanks,

	tglx

------------------>
John Stultz (1):
      ntp: Provide compability defines (You say MOD_NANO, I say ADJ_NANO)


 include/linux/timex.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index e6967d1..782ccd4 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -115,13 +115,16 @@ struct timex {
 #define ADJ_OFFSET_SS_READ	0xa001	/* read-only adjtime */
 #endif
 
-/* xntp 3.4 compatibility names */
+/* NTP userland likes the MOD_ prefix better */
 #define MOD_OFFSET	ADJ_OFFSET
 #define MOD_FREQUENCY	ADJ_FREQUENCY
 #define MOD_MAXERROR	ADJ_MAXERROR
 #define MOD_ESTERROR	ADJ_ESTERROR
 #define MOD_STATUS	ADJ_STATUS
 #define MOD_TIMECONST	ADJ_TIMECONST
+#define MOD_TAI	ADJ_TAI
+#define MOD_MICRO	ADJ_MICRO
+#define MOD_NANO	ADJ_NANO
 
 
 /*
