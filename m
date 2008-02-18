Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbYBRUyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbYBRUyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761549AbYBRUwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:52:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:16065 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761354AbYBRUwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LrGOcMTu20vhH/upVZwuZrk6k8J+ACaAV4EYsZE6RBEJnCd88FntPF4dUFYl4/5WSUsUb6TUZ0xKF8pioU85r8Z8h9420jTBCMDX8LhzYjVVqfWhSBPPnb7dKDXUGhy4zOnFy/WB36e12Mo8Zf/73eP2FCU+bey5G7pNZwDsvfo=
Subject: [PATCH 6/6] reiserfs: fix sparse warning in journal.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 12:52:43 -0800
Message-Id: <1203367963.5757.67.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/reiserfs/journal.c:4319:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/reiserfs/journal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index bb05a3e..005263d 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -4316,5 +4316,5 @@ static void __reiserfs_journal_abort_soft(struct super_block *sb, int errno)
 
 void reiserfs_journal_abort(struct super_block *sb, int errno)
 {
-	return __reiserfs_journal_abort_soft(sb, errno);
+	__reiserfs_journal_abort_soft(sb, errno);
 }
-- 
1.5.4.1.1278.gc75be

