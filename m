Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZEYNEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZEYNEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZEYNEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:04:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:53290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbZEYNEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:04:22 -0400
Date: Mon, 25 May 2009 13:03:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525124559.995591577@chello.nl>
References: <20090525124559.995591577@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Fix perf-$cmd invokation
Message-ID: <tip-266dfb0b58bc4181b6158ee63a0069abaa9f3a98@git.kernel.org>
Git-Commit-ID: 266dfb0b58bc4181b6158ee63a0069abaa9f3a98
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 13:03:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  266dfb0b58bc4181b6158ee63a0069abaa9f3a98
Gitweb:     http://git.kernel.org/tip/266dfb0b58bc4181b6158ee63a0069abaa9f3a98
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 May 2009 14:45:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 14:54:59 +0200

perf_counter: Fix perf-$cmd invokation

Fix:

  $ perf-top
  fatal: cannot handle -top internally

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525124559.995591577@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/perf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/perf.c b/Documentation/perf_counter/perf.c
index 594d270..1d6d7aa 100644
--- a/Documentation/perf_counter/perf.c
+++ b/Documentation/perf_counter/perf.c
@@ -357,7 +357,7 @@ int main(int argc, const char **argv)
 	 * die if that one cannot handle it.
 	 */
 	if (!prefixcmp(cmd, "perf-")) {
-		cmd += 4;
+		cmd += 5;
 		argv[0] = cmd;
 		handle_internal_command(argc, argv);
 		die("cannot handle %s internally", cmd);
