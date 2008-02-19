Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbYBSUNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbYBSUNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYBSUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:13:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYBSUM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:12:59 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH] trivial: fix typo at tick-broadcast.c
Date: Tue, 19 Feb 2008 17:05:47 -0300
Message-Id: <1203451547-27276-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

braodcast -> broadcast

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 kernel/time/tick-broadcast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index e1bd50c..b3c8265 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -262,7 +262,7 @@ out:
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
 	if (!cpu_isset(*oncpu, cpu_online_map))
-		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
+		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
 		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-- 
1.4.2

