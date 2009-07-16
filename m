Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbZGPTo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbZGPTo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbZGPToz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:44:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40062 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140AbZGPTox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:44:53 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] tracing: removing .globl in the scripts/recordmcount.pl doc
Date: Thu, 16 Jul 2009 21:44:28 +0200
Message-Id: <1247773468-11594-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1247773468-11594-1-git-send-email-jolsa@redhat.com>
References: <1247773468-11594-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was reading throught the recordmcount.pl starting comment,
and spot a tiny discrepancy.

The second example is about my_func not being global, but the example code
has the ".globl my_func" statement just moved. IMO it should be erased,
if not I'm curious what I'm missing.. :)

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

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
-- 
1.6.2.5

