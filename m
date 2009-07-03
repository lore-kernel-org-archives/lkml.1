Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZGCGjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZGCGjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZGCGjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:39:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:49726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZGCGjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:39:44 -0400
Subject: [PATCH -tip] perf tools: gitignore *.data
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 12:09:07 +0530
Message-Id: <1246603147.2322.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf.data made by perf record is a data file and
need to be ignored by git

Added *.data so that perf.data and its friends will be ignored.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index d69a759..057deea 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -14,3 +14,4 @@ common-cmds.h
 tags
 TAGS
 cscope*
+*.data
-- 
1.6.2.5



