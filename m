Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbXK2Hjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbXK2Hjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbXK2HiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:38:16 -0500
Received: from [222.73.24.84] ([222.73.24.84]:53529 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759268AbXK2HiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:38:13 -0500
Message-ID: <474E6BD0.20103@cn.fujitsu.com>
Date: Thu, 29 Nov 2007 15:35:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       trivial@kernel.org
Subject: [PATCH 6/6] tick: add a missing dot in prink
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a missing '.' in prink information.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 kernel/time/tick-oneshot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 0258d31..0b5e513 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -78,7 +78,7 @@ int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 		printk(KERN_INFO "Clockevents: "
 		       "could not switch to one-shot mode:");
 		if (!dev) {
-			printk(" no tick device\n");
+			printk(" no tick device.\n");
 		} else {
 			if (!tick_device_is_functional(dev))
 				printk(" %s is not functional.\n", dev->name);
-- 
1.5.3.rc7

