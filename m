Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZDKUag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZDKUag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbZDKU3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:29:52 -0400
Received: from thunk.org ([69.25.196.29]:55352 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbZDKU3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:29:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH, RFC 1/3] tracing: Update documentation references in kernel/trace/Kconfig
Date: Sat, 11 Apr 2009 15:51:17 -0400
Message-Id: <1239479479-2603-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239479479-2603-1-git-send-email-tytso@mit.edu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 66bb7488 consolidated documentation files into
Documentation/trace, but it didn't update references found in the
kernel/trace/Kconfig file.  Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2246141..417d198 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -312,7 +312,7 @@ config KMEMTRACE
 	  and profile kernel code.
 
 	  This requires an userspace application to use. See
-	  Documentation/vm/kmemtrace.txt for more information.
+	  Documentation/trace/kmemtrace.txt for more information.
 
 	  Saying Y will make the kernel somewhat larger and slower. However,
 	  if you disable kmemtrace at run-time or boot-time, the performance
@@ -403,7 +403,7 @@ config MMIOTRACE
 	  implementation and works via page faults. Tracing is disabled by
 	  default and can be enabled at run-time.
 
-	  See Documentation/tracers/mmiotrace.txt.
+	  See Documentation/trace/mmiotrace.txt.
 	  If you are not helping to develop drivers, say N.
 
 config MMIOTRACE_TEST
-- 
1.5.6.3

