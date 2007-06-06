Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbXFFKx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbXFFKx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXFFKxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:53:19 -0400
Received: from baikonur.stro.at ([213.239.196.228]:3813 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXFFKxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:53:18 -0400
Date: Wed, 6 Jun 2007 12:53:14 +0200
From: maximilian attems <max@stro.at>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [patch] Kconfig.debug DEBUG_PREEMPT dependency
Message-ID: <20070606105314.GD32083@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

allow to set DEBUG_PREEMPT on PREEMPT_BKL, but !PREEMPT
purpose is to get bonus of debug_smp_processor_id().

Signed-off-by: maximilian attems <max@stro.at>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index da95e10..1d4ab66 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -145,7 +145,7 @@ config DEBUG_SLAB_LEAK
 
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
-	depends on DEBUG_KERNEL && PREEMPT && TRACE_IRQFLAGS_SUPPORT
+	depends on DEBUG_KERNEL && (PREEMPT || PREEMPT_BKL) && TRACE_IRQFLAGS_SUPPORT
 	default y
 	help
 	  If you say Y here then the kernel will use a debug variant of the
