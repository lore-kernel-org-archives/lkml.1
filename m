Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbXKIXcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbXKIXcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbXKIXcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:32:06 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57066 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbXKIXcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:32:05 -0500
Message-id: <7981323273222714582@pripojeni.net>
In-reply-to: <4827138842526222333@pripojeni.net>
Subject: [PATCH 2/5] Watchdog: bfin_wdt, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: <michael.frysinger@analog.com>
Cc: <vapier.adi@gmail.com>
Date: Fri, 9 Nov 2007 18:32:05 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bfin_wdt, remove SPIN_LOCK_UNLOCKED

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---
commit 5290a0e1fffeb61f0062ebca98e45a6a5ba75711
tree 4d377ca30153b48b32b4d2c079ab884983c0091d
parent aefcf0f6b6ab925184e7cebff8b609e4da1f5c0d
author Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:55:29 +0200
committer Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:55:29 +0200

 drivers/watchdog/bfin_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 309d279..31dc7a6 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -71,7 +71,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static struct watchdog_info bfin_wdt_info;
 static unsigned long open_check;
 static char expect_close;
-static spinlock_t bfin_wdt_spinlock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(bfin_wdt_spinlock);
 
 /**
  *	bfin_wdt_keepalive - Keep the Userspace Watchdog Alive
