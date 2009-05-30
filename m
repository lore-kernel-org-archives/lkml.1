Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbZE3LwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbZE3LwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbZE3LwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:52:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:40949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZE3LwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:52:07 -0400
Date: Sat, 30 May 2009 11:51:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Fix 'make install'
Message-ID: <tip-7fbd55449aafb86d3237b5d1a26fb4dab2aa2c76@git.kernel.org>
Git-Commit-ID: 7fbd55449aafb86d3237b5d1a26fb4dab2aa2c76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 May 2009 11:51:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fbd55449aafb86d3237b5d1a26fb4dab2aa2c76
Gitweb:     http://git.kernel.org/tip/7fbd55449aafb86d3237b5d1a26fb4dab2aa2c76
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 30 May 2009 12:38:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 30 May 2009 12:45:29 +0200

perf_counter tools: Fix 'make install'

'make install' didnt install perf itself - which needs a special
rule to be copied to bindir.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index bd29a5c..8f72584 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -776,6 +776,7 @@ install: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(ALL_PROGRAMS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(INSTALL) perf$X '$(DESTDIR_SQ)$(bindir_SQ)'
 ifneq (,$X)
 	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
 endif
