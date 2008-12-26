Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYLZDXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYLZDXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 22:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYLZDXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 22:23:05 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60259 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYLZDXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 22:23:04 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH for -tip 1/4] hrtimer: remove #include <linux/irq.h>
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081226122142.5CA6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 26 Dec 2008 12:23:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/irq.h> can be removed and shoud be. because

  - hrtimer doesn't use any irq feature.
  - <linux/irq.h> shouldn't be include from generic code.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/hrtimer.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/kernel/hrtimer.c
===================================================================
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/cpu.h>
-#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>


