Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383Ab0A0XGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0A0XGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265Ab0A0XGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:06:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0A0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:06:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf: Ignore perf-archive temp file
Date: Wed, 27 Jan 2010 21:05:54 -0200
Message-Id: <1264633557-17597-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264633557-17597-1-git-send-email-acme@infradead.org>
References: <1264633557-17597-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Kacur <jkacur@redhat.com>

Tell git to ignore perf-archive.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

