Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbXKIXc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbXKIXc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbXKIXcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:32:46 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57077 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbXKIXcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:32:45 -0500
Message-id: <1482721921242938628@pripojeni.net>
In-reply-to: <4827138842526222333@pripojeni.net>
Subject: [PATCH 3/5] Sbus: cpwatchdog, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Date: Fri, 9 Nov 2007 18:32:45 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cpwatchdog, remove SPIN_LOCK_UNLOCKED

SPIN_LOCK_UNLOCKED is deprecated, use __SPIN_LOCK_UNLOCKED with an unique
name instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---
commit 4e91ba06c53856bfaab065aaf9fd8f5b0dd59f6f
tree ff123ed71958d9331623876dfc20efa86c639498
parent 5290a0e1fffeb61f0062ebca98e45a6a5ba75711
author Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:56:54 +0200
committer Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:56:54 +0200

 drivers/sbus/char/cpwatchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/sbus/char/cpwatchdog.c b/drivers/sbus/char/cpwatchdog.c
index 7b5773d..a4e7581 100644
--- a/drivers/sbus/char/cpwatchdog.c
+++ b/drivers/sbus/char/cpwatchdog.c
@@ -154,7 +154,7 @@ struct wd_device {
 };
 
 static struct wd_device wd_dev = { 
-		0, SPIN_LOCK_UNLOCKED, 0, 0, 0, 0,
+		0, __SPIN_LOCK_UNLOCKED(wd_dev.lock), 0, 0, 0, 0,
 };
 
 static struct timer_list wd_timer;
