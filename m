Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbZG2Hxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbZG2Hxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZG2Hxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:53:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49811 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZG2Hxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:53:41 -0400
Message-ID: <4A6FFFE9.5070204@cn.fujitsu.com>
Date: Wed, 29 Jul 2009 15:53:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3 -mm] generic-ipi: fix hotplug_cfd()
References: <4A6983D8.8090805@cn.fujitsu.com>
In-Reply-To: <4A6983D8.8090805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CONFIG_HOTPLUG_CPU, not CONFIG_CPU_HOTPLUG

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index bf9f18b..1b5fd2e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -54,7 +54,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			return NOTIFY_BAD;
 		break;
 
-#ifdef CONFIG_CPU_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 
-- 
1.6.1.2


