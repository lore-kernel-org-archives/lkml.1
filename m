Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYHSRsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYHSRsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbYHSRrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:47:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:44207 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbYHSRrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=Fw40czryZznvS44QuMV8YwutbTZNJIKVF3ddovWoGTSuqEjbB79ORf6thFJHwTgYhN
         KcCGMTq2qDwGngCbXtB2BMRtKo4iNkWUCxzaFcsQk9F8GnVv88gEMj8wL5oG6uvtuHd2
         4BIf2DrwkRuDVpKaAms/9tfcBcyaYBndBqu7w=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 5/5] kmemtrace: Fix 2 typos in documentation.
Date: Tue, 19 Aug 2008 20:43:27 +0300
Message-Id: <1219167807-5407-5-git-send-email-eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1219167807-5407-4-git-send-email-eduard.munteanu@linux360.ro>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
 <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro>
 <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro>
 <1219167807-5407-4-git-send-email-eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected the ABI description and the kmemtrace usage guide. Thanks to
Randy Dunlap for noticing these errors.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 Documentation/ABI/testing/debugfs-kmemtrace |    2 +-
 Documentation/vm/kmemtrace.txt              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-kmemtrace b/Documentation/ABI/testing/debugfs-kmemtrace
index a5ff9a6..5e6a92a 100644
--- a/Documentation/ABI/testing/debugfs-kmemtrace
+++ b/Documentation/ABI/testing/debugfs-kmemtrace
@@ -63,7 +63,7 @@ Adding new data to the packet (features) is done at the end of the mandatory
 data:
 	Feature size	(2 byte)
 	Feature ID	(1 byte)
-	Feature data	(Feature size - 4 bytes)
+	Feature data	(Feature size - 3 bytes)
 
 
 Users:
diff --git a/Documentation/vm/kmemtrace.txt b/Documentation/vm/kmemtrace.txt
index 75360b1..f656cac 100644
--- a/Documentation/vm/kmemtrace.txt
+++ b/Documentation/vm/kmemtrace.txt
@@ -61,7 +61,7 @@ III. Quick usage guide
 ======================
 
 1) Get a kernel that supports kmemtrace and build it accordingly (i.e. enable
-CONFIG_KMEMTRACE and CONFIG_DEFAULT_ENABLED).
+CONFIG_KMEMTRACE and CONFIG_KMEMTRACE_DEFAULT_ENABLED).
 
 2) Get the userspace tool and build it:
 $ git-clone git://repo.or.cz/kmemtrace-user.git		# current repository
-- 
1.5.6.1

