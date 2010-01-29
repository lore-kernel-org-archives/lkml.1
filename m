Return-Path: <linux-kernel-owner+w=401wt.eu-S932321Ab0A2JeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab0A2JeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445Ab0A2JeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:34:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:36800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab0A2JeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:34:00 -0500
Date: Fri, 29 Jan 2010 09:33:18 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, jkacur@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264633557-17597-6-git-send-email-acme@infradead.org>
References: <1264633557-17597-6-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Ignore perf-archive temp file
Message-ID: <tip-fbe346c280823783bd1e5eac1980a57667363c1b@git.kernel.org>
Git-Commit-ID: fbe346c280823783bd1e5eac1980a57667363c1b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:33:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbe346c280823783bd1e5eac1980a57667363c1b
Gitweb:     http://git.kernel.org/tip/fbe346c280823783bd1e5eac1980a57667363c1b
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Wed, 27 Jan 2010 21:05:54 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:25:37 +0100

perf: Ignore perf-archive temp file

Tell git to ignore perf-archive.

Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1264633557-17597-6-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 124760b..e1d60d7 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -14,6 +14,7 @@ perf*.html
 common-cmds.h
 perf.data
 perf.data.old
+perf-archive
 tags
 TAGS
 cscope*
