Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYIOACq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYIOACq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 20:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIOACh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 20:02:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:29745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYIOACh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 20:02:37 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] FTRACE_STARTUP_TEST should depend on FTRACE.
Date: Sun, 14 Sep 2008 17:02:32 -0700
Message-Id: <1221436952-15206-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doesn't make sense to do an FTRACE startup test when FTRACE isn't
even being compiled in.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 kernel/trace/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 16e5bb5..1ee0400 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -152,6 +152,7 @@ config FTRACE_SELFTEST
 config FTRACE_STARTUP_TEST
 	bool "Perform a startup test on ftrace"
 	depends on TRACING
+	depends on FTRACE
 	depends on DEBUG_KERNEL
 	select FTRACE_SELFTEST
 	help
-- 
1.6.0.1

