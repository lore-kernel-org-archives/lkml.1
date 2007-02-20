Return-Path: <linux-kernel-owner+w=401wt.eu-S1030233AbXBTQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030233AbXBTQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030232AbXBTQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:31:11 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:43148 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030233AbXBTQbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:31:10 -0500
Message-Id: <20070220163019.085494681@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 20 Feb 2007 08:30:19 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] update timekeeping_is_continuous comment
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.20/kernel/timer.c
===================================================================
--- linux-2.6.20.orig/kernel/timer.c
+++ linux-2.6.20/kernel/timer.c
@@ -908,7 +908,7 @@ static inline void change_clocksource(vo
 #endif
 
 /**
- * timeofday_is_continuous - check to see if timekeeping is free running
+ * timekeeping_is_continuous - check to see if timekeeping is free running
  */
 int timekeeping_is_continuous(void)
 {
-- 
