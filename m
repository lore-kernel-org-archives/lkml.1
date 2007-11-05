Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXKEDPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXKEDPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 22:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXKEDOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 22:14:51 -0500
Received: from [222.73.24.84] ([222.73.24.84]:51800 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbXKEDOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 22:14:50 -0500
Message-ID: <472E8A3E.4010809@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 11:13:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] POSIX TIMER: coding style: leave a space after the comma
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here we add a space after ','

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 kernel/posix-timers.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 35b4bbf..f1461f8 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -296,7 +296,7 @@ void do_schedule_next_timer(struct siginfo *info)
 		unlock_timer(timr, flags);
 }
 
-int posix_timer_event(struct k_itimer *timr,int si_private)
+int posix_timer_event(struct k_itimer *timr, int si_private)
 {
 	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
 	timr->sigq->info.si_sys_private = si_private;
-- 
1.5.3.rc7

