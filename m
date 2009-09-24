Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbZIXMTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbZIXMTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZIXMT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:19:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:53383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZIXMT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:19:27 -0400
Date: Thu, 24 Sep 2009 12:18:38 GMT
From: tip-bot for Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org, kirr@mns.spb.ru, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, kirr@mns.spb.ru,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1253790022-10300-1-git-send-email-kirr@mns.spb.ru>
References: <1253790022-10300-1-git-send-email-kirr@mns.spb.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: .gitignore += perf*.html
Message-ID: <tip-67030036ebb370b0aa5561ae2fe31668ed1ccd1c@git.kernel.org>
Git-Commit-ID: 67030036ebb370b0aa5561ae2fe31668ed1ccd1c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 12:18:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67030036ebb370b0aa5561ae2fe31668ed1ccd1c
Gitweb:     http://git.kernel.org/tip/67030036ebb370b0aa5561ae2fe31668ed1ccd1c
Author:     Kirill Smelkov <kirr@mns.spb.ru>
AuthorDate: Thu, 24 Sep 2009 15:00:22 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 14:01:22 +0200

perf tools: .gitignore += perf*.html

I've tried building the docs in tools/perf/Documentation/ , and after
that `git status` showed dozen of untracked htmls. Let's ignore them.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
LKML-Reference: <1253790022-10300-1-git-send-email-kirr@mns.spb.ru>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
