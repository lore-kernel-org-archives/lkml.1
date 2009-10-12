Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbZJLUxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbZJLUxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbZJLUxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:53:34 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58657 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136AbZJLUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C6iThvSieMk1GiDZPVtlXYOGJfLjPapH2ropOTM25uCJMCgQgPSoowHaPRrJYwWRT0
         M+MgG5C1oo68xZQAiXXLmKxXny2xcull/ynR8EtIEX+nQJ9C/o2Zvv3KqwpBNZodNO4/
         +LKxebKSd9h1yJ3KVANc9ACyTj2Rd8XFWj2Co=
From: Tommi Rantala <tt.rantala@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] page-types: trivial typo fixes
Date: Mon, 12 Oct 2009 23:51:34 +0300
Message-Id: <1255380694-4122-2-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1255380694-4122-1-git-send-email-tt.rantala@gmail.com>
References: <1255380694-4122-1-git-send-email-tt.rantala@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial typo fixes.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 Documentation/vm/page-types.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index 16fb478..d6d21c2 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -301,7 +301,7 @@ static char *page_flag_name(uint64_t flags)
 		present = (flags >> i) & 1;
 		if (!page_flag_names[i]) {
 			if (present)
-				fatal("unkown flag bit %d\n", i);
+				fatal("unknown flag bit %d\n", i);
 			continue;
 		}
 		buf[j++] = present ? page_flag_names[i][0] : '_';
@@ -682,7 +682,7 @@ static void usage(void)
 #endif
 "            -l|--list                 Show page details in ranges\n"
 "            -L|--list-each            Show page details one by one\n"
-"            -N|--no-summary           Don't show summay info\n"
+"            -N|--no-summary           Don't show summary info\n"
 "            -X|--hwpoison             hwpoison pages\n"
 "            -x|--unpoison             unpoison pages\n"
 "            -h|--help                 Show this usage message\n"
-- 
1.5.6.5

