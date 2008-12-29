Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYL2BlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYL2BlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 20:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbYL2Bj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 20:39:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:18353 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbYL2Bj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 20:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=fop+jkKXbPe9xvEqA8Sm6uAs5y/daAJCbpPtE9G4eb8tMS9Nmafixk7u3wlNG6/faD
         6Yff5QfSTiybBCLcP4+wWoMsFpB1fJrly3Gv9bPvVVBb7duuiS1hUMBlRipOhr59hI+o
         HTZZx0Bg5p5egwIoRz71F9h1WoXAyWS6OzFBE=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tracepoints: Include only minimal RCU headers in linux/tracepoint.h.
Date: Mon, 29 Dec 2008 03:40:07 +0200
Message-Id: <4dcbaab558466e1cd0be66f3b66c7c5d2a0c532b.1230499486.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro>
 <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1230499486.git.eduard.munteanu@linux360.ro>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows kmemtrace to work nicely with tracepoints, since RCU headers
don't end up anymore including SLAB headers. It might also speed up
compilation because there's less preprocessing involved.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/tracepoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c5bb39c..86b0e8a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -15,7 +15,7 @@
  */
 
 #include <linux/types.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_min.h>
 
 struct module;
 struct tracepoint;
-- 
1.6.0.6

