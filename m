Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0CHXPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:15:12 -0500
Received: from psi.thgersdorf.net ([188.40.92.130]:58340 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CHXPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:15:07 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 18:15:07 EST
From: Dieter Ries <mail@dieterries.net>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Dieter Ries <mail@dieterries.net>
Subject: [PATCH] OPTPROBES: Don't default to y in Kconfig
Date: Tue,  9 Mar 2010 00:07:38 +0100
Message-Id: <1268089658-19919-1-git-send-email-mail@dieterries.net>
X-Mailer: git-send-email 1.7.0.rc0.76.g43960
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_OPTPROBES should not default to y while still being flagged
EXPERIMENTAL.

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 arch/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e5eb133..57710f7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -43,7 +43,7 @@ config KPROBES
 
 config OPTPROBES
 	bool "Kprobes jump optimization support (EXPERIMENTAL)"
-	default y
+	default n
 	depends on KPROBES
 	depends on !PREEMPT
 	depends on HAVE_OPTPROBES
-- 
1.7.0.rc0.76.g43960

