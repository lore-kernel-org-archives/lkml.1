Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYLEKYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYLEKYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbYLEKVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:21:13 -0500
Received: from vps1.tull.net ([66.180.172.116]:47134 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755706AbYLEKVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:21:02 -0500
Mail-From: nobody Fri Dec  5 14:08:07 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in aops.c
To: Anton Altaparmakov <aia21@cantab.net>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Andrew <nick@nick-andrew.net>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:07 +1100
Message-ID: <20081205030806.32267.34580.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in aops.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 fs/ntfs/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index b38f944..dc8aee9 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -1298,7 +1298,7 @@ done:
 	if (unlikely(err && err != -ENOMEM)) {
 		/*
 		 * Set page error if there is only one ntfs record in the page.
-		 * Otherwise we would loose per-record granularity.
+		 * Otherwise we would lose per-record granularity.
 		 */
 		if (ni->itype.index.block_size == PAGE_CACHE_SIZE)
 			SetPageError(page);


