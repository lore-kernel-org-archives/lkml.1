Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYLWAMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYLWAMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbYLWAMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:23 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54109 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbYLWAMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:12:22 -0500
From: paulmck@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       ralf@linux-mips.org, kernel@wantstofly.org, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] Set the default RCU to be rcutree
Date: Mon, 22 Dec 2008 16:12:16 -0800
Message-Id: <12299911472535-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Only for testing in -tip and -next, not yet for inclusion into mainline.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/Kconfig.preempt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 463f297..6f8f329 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -54,7 +54,7 @@ endchoice
 
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU
 
 config CLASSIC_RCU
 	bool "Classic RCU"
-- 
1.5.2.5

