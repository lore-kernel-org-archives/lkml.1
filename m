Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZJGO1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZJGO1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbZJGO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:27:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:43145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbZJGO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:27:43 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: [PATCH 1/1] perf tools: Install the docs by default
Date: Wed,  7 Oct 2009 11:26:59 -0300
Message-Id: <1254925619-6705-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <y>
References: <y>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we get matching docs when installing a new version of the tools.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Suggested-by: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5a42996..e714bd1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -895,6 +895,7 @@ ifneq (,$X)
 	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
 endif
 endif
+	$(MAKE) -C Documentation install
 
 install-doc:
 	$(MAKE) -C Documentation install
-- 
1.6.2.5

