Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZGRKZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZGRKZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbZGRKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:25:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:55102 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbZGRKZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:25:17 -0400
Date: Sat, 18 Jul 2009 10:24:45 GMT
From: "tip-bot for jolsa@redhat.com" <jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jolsa@redhat.com, mingo@elte.hu
In-Reply-To: <1247773468-11594-4-git-send-email-jolsa@redhat.com>
References: <1247773468-11594-4-git-send-email-jolsa@redhat.com>
Subject: [tip:tracing/core] tracing: Remove .globl in the scripts/recordmcount.pl doc
Message-ID: <tip-d34a4debef933061924ee17c2ede33f5c44925fb@git.kernel.org>
Git-Commit-ID: d34a4debef933061924ee17c2ede33f5c44925fb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 10:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d34a4debef933061924ee17c2ede33f5c44925fb
Gitweb:     http://git.kernel.org/tip/d34a4debef933061924ee17c2ede33f5c44925fb
Author:     jolsa@redhat.com <jolsa@redhat.com>
AuthorDate: Thu, 16 Jul 2009 21:44:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 12:21:17 +0200

tracing: Remove .globl in the scripts/recordmcount.pl doc

I was reading throught the recordmcount.pl starting comment,
and spotted a tiny discrepancy.

The second example is about my_func not being global, but the
example code has the ".globl my_func" statement just moved.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org
LKML-Reference: <1247773468-11594-4-git-send-email-jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 scripts/recordmcount.pl |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7109e2b..db4ebe1 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -57,7 +57,6 @@
 #        call mcount  (offset: 0x5)
 #        [...]
 #        ret
-#  .globl my_func
 #  other_func:
 #        [...]
 #        call mcount (offset: 0x1b)
