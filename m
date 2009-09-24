Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbZIXLWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbZIXLWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZIXLWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:22:43 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:35764 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZIXLWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:22:43 -0400
X-Greylist: delayed 1094 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 07:22:42 EDT
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH] perf_counter tools: .gitignore += perf*.html
Date: Thu, 24 Sep 2009 15:00:22 +0400
Message-Id: <1253790022-10300-1-git-send-email-kirr@mns.spb.ru>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tried building the docs in tools/perf/Documentation/ , and after
that `git status` showed dozen of untracked htmls. Let's ignore them.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 tools/perf/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index d69a759..0854f11 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -10,6 +10,7 @@ perf-stat
 perf-top
 perf*.1
 perf*.xml
+perf*.html
 common-cmds.h
 tags
 TAGS
-- 
1.6.5.rc2

