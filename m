Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZG3KZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZG3KZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZG3KZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:25:43 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:38002 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZG3KZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:25:41 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, mingo@elte.hu, acme@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de
Subject: [PATCH 4/4] [perf] fixed faulty check
Date: Thu, 30 Jul 2009 05:25:29 -0500
Message-ID: <1248949529-20891-1-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patche fixes a spelling error that has resulted from copy and pasting. The location of the error was found using a semantic patch but the semantic patch was not trying to find these errors. After looking things over it seemed logical that this change was needed. Please review it and then include the patch if it is in fact the correct change.

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
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
-- 
1.6.3.3

