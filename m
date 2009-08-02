Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZHBNMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZHBNMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZHBNMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:12:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:34122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZHBNLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:11:44 -0400
Date: Sun, 2 Aug 2009 13:10:41 GMT
From: tip-bot for Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, sgayda2@uiuc.edu, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, sgayda2@uiuc.edu, mingo@elte.hu
In-Reply-To: <1248949529-20891-1-git-send-email-sgayda2@uiuc.edu>
References: <1248949529-20891-1-git-send-email-sgayda2@uiuc.edu>
Subject: [tip:perfcounters/core] perf tools: Fix faulty check
Message-ID: <tip-9b30a26bf3d2c56dcb1c3afaca28b73fcd6ed405@git.kernel.org>
Git-Commit-ID: 9b30a26bf3d2c56dcb1c3afaca28b73fcd6ed405
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:10:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b30a26bf3d2c56dcb1c3afaca28b73fcd6ed405
Gitweb:     http://git.kernel.org/tip/9b30a26bf3d2c56dcb1c3afaca28b73fcd6ed405
Author:     Stoyan Gaydarov <sgayda2@uiuc.edu>
AuthorDate: Thu, 30 Jul 2009 05:25:29 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 13:47:59 +0200

perf tools: Fix faulty check

This patch fixes a spelling error that has resulted from copy
and pasting. The location of the error was found using a
semantic patch but the semantic patch was not trying to find
these errors. After looking things over it seemed logical that
this change was needed. Please review it and then include the
patch if it is in fact the correct change.

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1248949529-20891-1-git-send-email-sgayda2@uiuc.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2810605..b4fe057 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -565,7 +565,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		goto out_elf_end;
 
 	secstrs = elf_getdata(sec_strndx, NULL);
-	if (symstrs == NULL)
+	if (secstrs == NULL)
 		goto out_elf_end;
 
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
