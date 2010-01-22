Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835Ab0AVGjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0AVGjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 01:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634Ab0AVGjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 01:39:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:43190 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751599Ab0AVGjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 01:39:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Vqod+hC4VPuiYK4FBydzMuum+xcgArrl6Yw1bm9
	uUvRVPp0wu5Yme
Subject: [patch] perf tools: fix dc8d6ab typo prohibiting perf top symbol
 annotation
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 07:39:39 +0100
Message-Id: <1264142379.8074.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf tools: fix dc8d6ab typo prohibiting perf top symbol annotation

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 6f30fe1..af2e224 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1669,7 +1669,7 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 out_try_fixup:
-	if (err > 0) {
+	if (err <= 0) {
 out_fixup:
 		if (kallsyms_filename == NULL)
 			dso__set_long_name(self, strdup("[kernel.kallsyms]"));


