Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436Ab0AQEGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0AQEGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 23:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257Ab0AQEGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 23:06:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:44354 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752113Ab0AQEGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 23:06:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Dms06AdZDTlUdwcG07hXw2WEu2o6LAej4mg/1IO
	GlNJt9uL3tV9ZZ
Subject: [patch] perf tools: fix trivial implicit getline() declaration
 build error tools/perf/util/util.c
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 17 Jan 2010 05:06:38 +0100
Message-Id: <1263701198.20319.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf tools: fix trivial implicit getline() declaration build error tools/perf/util/util.c

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index f068584..31d8ac7 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,9 +1,13 @@
+#define _GNU_SOURCE
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <stdio.h>
 #include <fcntl.h>
 #include <string.h>
 #include <unistd.h>
+#undef _GNU_SOURCE
+
 #include "util.h"
 
 int mkdir_p(char *path, mode_t mode)


