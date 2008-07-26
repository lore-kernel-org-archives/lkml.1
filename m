Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYGZTO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYGZTO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYGZTOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:14:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35932 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYGZTOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:14:51 -0400
Date: Sat, 26 Jul 2008 21:14:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [git pull] signalfd4 fix
Message-ID: <20080726191434.GA26799@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull a compat_sys_signalfd4 build fix from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      signalfd: fix undefined reference to `compat_sys_signalfd4'


 kernel/sys_ni.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index bd66ac5..5e687bb 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -159,6 +159,7 @@ cond_syscall(sys_ioprio_get);
 cond_syscall(sys_signalfd);
 cond_syscall(sys_signalfd4);
 cond_syscall(compat_sys_signalfd);
+cond_syscall(compat_sys_signalfd4);
 cond_syscall(sys_timerfd_create);
 cond_syscall(sys_timerfd_settime);
 cond_syscall(sys_timerfd_gettime);
