Return-Path: <linux-kernel-owner+w=401wt.eu-S1765515AbXG2PCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765515AbXG2PCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764118AbXG2O6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47800 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763902AbXG2O6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:05 -0400
Date: Sun, 29 Jul 2007 16:57:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: pavel@suse.cz, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make kernel/power/main.c:suspend_enter() static
Message-ID: <20070729145742.GP16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

suspend_enter() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/power/main.c  |    2 +-
 kernel/power/power.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1/kernel/power/power.h.old	2007-07-26 14:49:29.000000000 +0200
+++ linux-2.6.23-rc1-mm1/kernel/power/power.h	2007-07-26 14:49:36.000000000 +0200
@@ -177,7 +177,6 @@
 				unsigned int, char *);
 
 /* kernel/power/main.c */
-extern int suspend_enter(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
 extern struct blocking_notifier_head pm_chain_head;
 
--- linux-2.6.23-rc1-mm1/kernel/power/main.c.old	2007-07-26 14:49:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1/kernel/power/main.c	2007-07-26 14:50:05.000000000 +0200
@@ -120,7 +120,7 @@
  *
  *	This function should be called after devices have been suspended.
  */
-int suspend_enter(suspend_state_t state)
+static int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
 

