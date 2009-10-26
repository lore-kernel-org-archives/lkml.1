Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZJZLjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZJZLjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZJZLjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:39:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:57298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbZJZLjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:39:13 -0400
Date: Mon, 26 Oct 2009 11:38:14 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lethal@linux-sh.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, lethal@linux-sh.org, mingo@elte.hu
In-Reply-To: <20091026054000.GA13517@linux-sh.org>
References: <20091026054000.GA13517@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Remove -Wcast-align
Message-ID: <tip-ec29b8d2af01912bb79adda8aeab4293539f29ac@git.kernel.org>
Git-Commit-ID: ec29b8d2af01912bb79adda8aeab4293539f29ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec29b8d2af01912bb79adda8aeab4293539f29ac
Gitweb:     http://git.kernel.org/tip/ec29b8d2af01912bb79adda8aeab4293539f29ac
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Mon, 26 Oct 2009 14:40:01 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 09:43:06 +0100

perf tools: Remove -Wcast-align

The present use of -Wcast-align causes the build to blow up on
SH due to generating a "cast increases required alignment of
target type" error on each invocation of list_for_each_entry().

It seems that this was previously reported and killed off in the
ia64 support patch, but nothing seems to have happened with
that. Presumably the same problem still remains there, too.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
LKML-Reference: <20091026054000.GA13517@linux-sh.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 46e877b..7e190d5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -177,8 +177,7 @@ endif
 # Include saner warnings here, which can catch bugs:
 #
 
-EXTRA_WARNINGS := -Wcast-align
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat
+EXTRA_WARNINGS := -Wformat
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
