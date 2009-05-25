Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZEYMrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZEYMrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZEYMrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:47:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:47587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZEYMrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:47:07 -0400
Message-Id: <20090525124559.995591577@chello.nl>
References: <20090525124523.010479297@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 14:45:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/5] perf_counter: fix perf-$cmd invokation
Content-Disposition: inline; filename=perf_counter-fix-perf-cmd.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

  $ perf-top
  fatal: cannot handle -top internally

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/Documentation/perf_counter/perf.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/perf.c
+++ linux-2.6/Documentation/perf_counter/perf.c
@@ -357,7 +357,7 @@ int main(int argc, const char **argv)
 	 * die if that one cannot handle it.
 	 */
 	if (!prefixcmp(cmd, "perf-")) {
-		cmd += 4;
+		cmd += 5;
 		argv[0] = cmd;
 		handle_internal_command(argc, argv);
 		die("cannot handle %s internally", cmd);

-- 

