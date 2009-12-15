Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZLOJkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZLOJkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZLOJkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:40:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:59176 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbZLOJkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:40:24 -0500
Date: Tue, 15 Dec 2009 09:39:47 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260867220-15699-3-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace/scripting: Don't install unneeded files
Message-ID: <tip-a3a7cb7bb1d7bd989982314cf6f90ec392890006@git.kernel.org>
Git-Commit-ID: a3a7cb7bb1d7bd989982314cf6f90ec392890006
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3a7cb7bb1d7bd989982314cf6f90ec392890006
Gitweb:     http://git.kernel.org/tip/a3a7cb7bb1d7bd989982314cf6f90ec392890006
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 15 Dec 2009 02:53:36 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 10:31:31 +0100

perf trace/scripting: Don't install unneeded files

README and Makefile.PL don't need to be installed for Perl
run-time support.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1260867220-15699-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 87a424e..7814dbb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -996,8 +996,6 @@ install: all
 	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/Makefile.PL -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/README -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
 ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
