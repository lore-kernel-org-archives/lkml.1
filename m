Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbXH0U0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbXH0U0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbXH0UXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:09 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43356 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760120AbXH0UXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:23:01 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 12/15] nfsd warning fix
Date: Mon, 27 Aug 2007 16:22:53 -0400
Message-Id: <11882461772689-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <11882461773657-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
 <1188246177833-git-send-email-bfields@fieldses.org>
 <11882461773576-git-send-email-bfields@fieldses.org>
 <11882461771774-git-send-email-bfields@fieldses.org>
 <1188246177195-git-send-email-bfields@fieldses.org>
 <11882461773396-git-send-email-bfields@fieldses.org>
 <1188246177259-git-send-email-bfields@fieldses.org>
 <1188246177192-git-send-email-bfields@fieldses.org>
 <11882461773221-git-send-email-bfields@fieldses.org>
 <11882461773657-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

fs/nfsd/nfsctl.c: In function 'write_filehandle':
fs/nfsd/nfsctl.c:301: warning: 'maxsize' may be used uninitialized in this function

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/nfsctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index d135f5f..77dc989 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -298,7 +298,7 @@ static ssize_t write_filehandle(struct file *file, char *buf, size_t size)
 	 * qword quoting is used, so filehandle will be \x....
 	 */
 	char *dname, *path;
-	int maxsize;
+	int uninitialized_var(maxsize);
 	char *mesg = buf;
 	int len;
 	struct auth_domain *dom;
-- 
1.5.3.rc5.19.g0734d

