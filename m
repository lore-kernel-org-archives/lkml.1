Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYHUDYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYHUDYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYHUDQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:43 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50120 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYHUDQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:10 -0400
Date: Wed, 20 Aug 2008 20:50:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2obPK028350@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 25/27] mdb: export clocksource watchdog function
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export clocksource watchdog function


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/time/clocksource.c	2008-08-18 23:39:34.000000000 -0600
+++ b/kernel/time/clocksource.c	2008-08-18 23:40:26.000000000 -0600
@@ -242,6 +242,7 @@
 {
 	clocksource_resume_watchdog();
 }
+EXPORT_SYMBOL_GPL(clocksource_touch_watchdog);
 
 /**
  * clocksource_get_next - Returns the selected clocksource
