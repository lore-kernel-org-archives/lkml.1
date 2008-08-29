Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYH2GYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYH2GYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYH2GQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:04 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59525 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYH2GPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:33 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lgcQ016142@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 27/29] mdb: export clocksource watchdog function
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export clocksource watchdog function


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/time/clocksource.c	2008-08-28 14:19:32.000000000 -0600
+++ b/kernel/time/clocksource.c	2008-08-28 14:20:04.000000000 -0600
@@ -242,6 +242,7 @@
 {
 	clocksource_resume_watchdog();
 }
+EXPORT_SYMBOL_GPL(clocksource_touch_watchdog);
 
 /**
  * clocksource_get_next - Returns the selected clocksource
