Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787Ab0ARR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0ARR7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945Ab0ARR7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:59:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0ARR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:59:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf archive: Add documentation
Date: Mon, 18 Jan 2010 15:59:19 -0200
Message-Id: <1263837559-24168-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This also makes it appear on the 'perf --help' output, i.e.
util/generate-cmdlist.sh now takes it into account.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-archive.txt |   22 ++++++++++++++++++++++
 tools/perf/command-list.txt               |    2 +-
 2 files changed, 23 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-archive.txt

diff --git a/tools/perf/Documentation/perf-archive.txt b/tools/perf/Documentation/perf-archive.txt
new file mode 100644
index 0000000..fae174d
--- /dev/null
+++ b/tools/perf/Documentation/perf-archive.txt
@@ -0,0 +1,22 @@
+perf-archive(1)
+===============
+
+NAME
+----
+perf-archive - Create archive with object files with build-ids found in perf.data file
+
+SYNOPSIS
+--------
+[verse]
+'perf archive' [file]
+
+DESCRIPTION
+-----------
+This command runs runs perf-buildid-list --with-hits, and collects the files
+with the buildids found so that analisys of perf.data contents can be possible
+on another machine.
+
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-buildid-list[1], linkperf:perf-report[1]
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index f73d1d9..cf6444d 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -3,7 +3,7 @@
 # command name			category [deprecated] [common]
 #
 perf-annotate			mainporcelain common
-perf-archive			mainporcelain
+perf-archive			mainporcelain common
 perf-bench			mainporcelain common
 perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
-- 
1.6.5

