Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZHEUGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZHEUGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZHEUGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:06:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57069 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZHEUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:06:47 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, trivial@kernel.org
Subject: [PATCH] Fix duplicated word "options" in comment
Date: Wed,  5 Aug 2009 22:06:42 +0200
Message-Id: <1249502802-15123-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this was introduced in

	5e0a093 (tracing: fix config options to not show when automatically selected)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: trivial@kernel.org
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 019f380..6919357 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -68,7 +68,7 @@ config CONTEXT_SWITCH_TRACER
 # This allows those options to appear when no other tracer is selected. But the
 # options do not appear when something else selects it. We need the two options
 # GENERIC_TRACER and TRACING to avoid circular dependencies to accomplish the
-# hidding of the automatic options options.
+# hidding of the automatic options.
 
 config TRACING
 	bool
-- 
tg: (90bc1a6..) t/trivial/optionsoptions (depends on: linus/master)
