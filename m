Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411Ab0AQEDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0AQEDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 23:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0AQEDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 23:03:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:53800 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751610Ab0AQEDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 23:03:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ml981NHdmcz26xdma5+ynj/Rjc+9ZhHNpKj4m5l
	HyxbYdE9K9ULFJ
Subject: [patch] perf tools: trivial NO_LIBDWARF build error
 tools/perf/builtin-probe.c
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 17 Jan 2010 05:03:43 +0100
Message-Id: <1263701023.20319.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf tools: fix NO_LIBDWARF build error tools/perf/builtin-probe.c

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>


diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 1d3a99e..9be8063 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -118,6 +118,7 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+#ifndef NO_LIBDWARF
 static int opt_show_lines(const struct option *opt __used,
 			  const char *str, int unset __used)
 {
@@ -127,6 +128,8 @@ static int opt_show_lines(const struct option *opt __used,
 	session.show_lines = true;
 	return 0;
 }
+#endif
+
 /* Currently just checking function name from symbol map */
 static void evaluate_probe_point(struct probe_point *pp)
 {


