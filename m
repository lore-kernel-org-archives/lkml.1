Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbYHPEOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbYHPEOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbYHPEGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:18 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33290 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbYHPEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:45 -0400
Date: Fri, 15 Aug 2008 21:41:47 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3flPW022576@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 26/28] mdb: export clocksource watchdog
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export clocksource watchdog to suppress bogus soft lockup reports
while processors are held in the debugger.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/time/clocksource.c	2008-08-15 21:26:27.000000000 -0600
+++ b/kernel/time/clocksource.c	2008-08-15 15:41:57.000000000 -0600
@@ -242,6 +242,7 @@
 {
 	clocksource_resume_watchdog();
 }
+EXPORT_SYMBOL_GPL(clocksource_touch_watchdog);
 
 /**
  * clocksource_get_next - Returns the selected clocksource
