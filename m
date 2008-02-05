Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbYBEUna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbYBEUna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbYBEUnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:43:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:29277 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbYBEUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wUUKh2ytj6zpaCGI1W5SIKd2I3Rdij0OazW+CSaA9BO8A74quZO5xJ/OuzPnTs4IffqSWv4gJdCaLoxyVSHb5YqShXrZ8FVy9DsqyQYx6k4NDJSAKfhJFQ/w4r9CFz8kTD+Em+PGlTqVkpEL+2rzawtY4BDaQbrbPnFx7LQALtQ=
Subject: [PATCH 5/8] x86: sparse warning in therm_throt.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:42:42 -0800
Message-Id: <1202244162.18081.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/cpu/mcheck/therm_throt.c:121:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 24885be..9b7e01d 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -118,7 +118,7 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
 
 static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
 {
-	return sysfs_remove_group(&sys_dev->kobj, &thermal_throttle_attr_group);
+	sysfs_remove_group(&sys_dev->kobj, &thermal_throttle_attr_group);
 }
 
 /* Mutex protecting device creation against CPU hotplug */
-- 
1.5.4.rc5.1138.g2602


