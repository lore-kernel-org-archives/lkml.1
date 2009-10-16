Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbZJPRWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbZJPRWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbZJPRVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:21:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:40569 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbZJPRVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:21:52 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] powerpc: Cleanup lib/Kconfig.debug
Date: Fri, 16 Oct 2009 12:21:39 -0500
Message-Id: <1255713699-21852-6-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255713699-21852-5-git-send-email-galak@kernel.crashing.org>
References: <1255713699-21852-1-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-2-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-3-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-4-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-5-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need an explicit PPC64 in the DEBUG_PREEMPT dependancies as all
PPC platforms now support TRACE_IRQFLAGS_SUPPORT.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 30df586..234ceb1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -392,7 +392,7 @@ config DEBUG_KMEMLEAK_TEST
 
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
-	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
+	depends on DEBUG_KERNEL && PREEMPT && TRACE_IRQFLAGS_SUPPORT
 	default y
 	help
 	  If you say Y here then the kernel will use a debug variant of the
-- 
1.6.0.6

