Return-Path: <linux-kernel-owner+w=401wt.eu-S1762557AbXGEXWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762557AbXGEXWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbXGEXVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:21:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52115 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761073AbXGEXVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:21:47 -0400
Date: Fri, 6 Jul 2007 01:22:17 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] net/core/netevent.c should #include <net/netevent.h>
Message-ID: <20070705232217.GS3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/net/core/netevent.c.old	2007-07-03 04:59:08.000000000 +0200
+++ linux-2.6.22-rc6-mm1/net/core/netevent.c	2007-07-03 04:59:23.000000000 +0200
@@ -15,6 +15,7 @@
 
 #include <linux/rtnetlink.h>
 #include <linux/notifier.h>
+#include <net/netevent.h>
 
 static ATOMIC_NOTIFIER_HEAD(netevent_notif_chain);
 

