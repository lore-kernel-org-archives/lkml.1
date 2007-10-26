Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbXJZXHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbXJZXHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXJZXHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:07:05 -0400
Received: from 70-56-216-30.albq.qwest.net ([70.56.216.30]:43039 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751545AbXJZXHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:07:03 -0400
Date: Fri, 26 Oct 2007 17:07:01 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: add missing end-of-options record for trans_fd
Message-ID: <20071026230701.GC23570@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The list of options that the fd transport accepts is missing end-of-options
marker. This patch adds it.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 70ec0c7936c2516d128fdb1a32d749071b8846ec
tree 8de5495f83b94096825f8bfe0767e4fcbaf36ef3
parent 25ed88ed319e40fb6426e2aaefcc5f136aadd4ee
author Latchesar Ionkov <lucho@ionkov.net> 1193438452 -0600
committer Latchesar Ionkov <lucho@ionkov.net> 1193438452 -0600

 net/9p/trans_fd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 30269a4..62332ed 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -62,13 +62,14 @@ struct p9_trans_fd {
 
 enum {
 	/* Options that take integer arguments */
-	Opt_port, Opt_rfdno, Opt_wfdno,
+	Opt_port, Opt_rfdno, Opt_wfdno, Opt_err,
 };
 
 static match_table_t tokens = {
 	{Opt_port, "port=%u"},
 	{Opt_rfdno, "rfdno=%u"},
 	{Opt_wfdno, "wfdno=%u"},
+	{Opt_err, NULL},
 };
 
 /**
