Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYJUQPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYJUQPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYJUQPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:15:37 -0400
Received: from mail.tpi.com ([198.107.51.143]:4002 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYJUQPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:15:36 -0400
To: minyard@acm.org
Subject: [PATCH v2] add MODULE_ALIAS to load ipmi_devintf with ipmi_si
Cc: kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
       openipmi-developer@lists.sourceforge.net, scott@canonical.com
Message-Id: <20081021161536.D7CD65A15E@sepang.rtg.net>
Date: Tue, 21 Oct 2008 10:15:36 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 07463c240c3609c1e2fbed45f64acd5fd061ce58 Mon Sep 17 00:00:00 2001
From: Scott James Remnant <scott@canonical.com>
Date: Tue, 21 Oct 2008 15:18:36 +0100
Subject: [PATCH v2] add MODULE_ALIAS to load ipmi_devintf with ipmi_si

The ipmi_devintf module contains the userspace interface for IPMI
devices, yet will not be loaded automatically with a system
interface handler driver.

Add a MODULE_ALIAS for the "platform:ipmi_si" MODALIAS exported by
the ipmi_si driver, so that userspace knows of the recommendation.

Seems like a candidate for stable kernel updates.

Cc: stable@kernel.org
Signed-off-by: Scott James Remnant <scott@ubuntu.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/char/ipmi/ipmi_devintf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 64e1c16..ecaf369 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -957,3 +957,4 @@ module_exit(cleanup_ipmi);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
 MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
+MODULE_ALIAS("platform:ipmi_si");
-- 
1.5.6.3

