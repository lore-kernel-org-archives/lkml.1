Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbZLOIxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbZLOIxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZLOIxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:53:48 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:53451 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbZLOIxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GBFNxyX0HZb37UWXEg6Zbbneh6u5DjRmGoH4I7K0q5Xs64TY3bG+vCoZ0gPOEgRafe
         /PSJNHdDWInoCg01DMjlasgzupzNX3BsJ/QIGaPZnZ8mcofB9pwnn4MhTSFLeP6SSh2U
         bcxjAoM/X8Ed5lWUDguMeqrlCJj3PgasW2uB0=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 2/6] perf trace/scripting: don't install unneeded files
Date: Tue, 15 Dec 2009 02:53:36 -0600
Message-Id: <1260867220-15699-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

README and Makefile.PL don't need to be installed for Perl run-time
support.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a4cb792..2953809 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -995,8 +995,6 @@ install: all
 	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/Makefile.PL -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/README -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
 ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-- 
1.6.4.GIT

