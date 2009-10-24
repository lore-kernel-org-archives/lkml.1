Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZJXBEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZJXBEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZJXBEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:51692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZJXBEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:36 -0400
Date: Sat, 24 Oct 2009 01:03:38 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, fweisbec@gmail.com, torvalds@osdl.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, torvalds@osdl.org, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091020064731.20ae126a@infradead.org>
References: <20091020064731.20ae126a@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf timechart: Improve the visual appearance of scheduler delays
Message-ID: <tip-2e600d01c131ee189f55ca1879cd364b9e056df8@git.kernel.org>
Git-Commit-ID: 2e600d01c131ee189f55ca1879cd364b9e056df8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e600d01c131ee189f55ca1879cd364b9e056df8
Gitweb:     http://git.kernel.org/tip/2e600d01c131ee189f55ca1879cd364b9e056df8
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Tue, 20 Oct 2009 06:47:31 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 03:39:21 +0200

perf timechart: Improve the visual appearance of scheduler delays

[from KS feedback]

Currently, scheduler delays are shown in a mostly transparent,
light yellow color. This color is rather hard to see on several
screens, especially projectors.

This patch changes the color of the scheduler delays to be a
much more "hard" yellow that survived the kernel summit
projector.

Reported-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091020064731.20ae126a@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/svghelper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 856655d..b3637db 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -103,7 +103,7 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
-	fprintf(svgfile, "      rect.waiting  { fill:rgb(214,214,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.waiting  { fill:rgb(224,214,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.cpu      { fill:rgb(192,192,192); fill-opacity:0.2; stroke-width:0.5; stroke:rgb(128,128,128); } \n");
 	fprintf(svgfile, "      rect.pstate   { fill:rgb(128,128,128); fill-opacity:0.8; stroke-width:0; } \n");
