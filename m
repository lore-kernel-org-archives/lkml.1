Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbYFBRLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbYFBRLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYFBRLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:11:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:55196 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753228AbYFBRLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:11:14 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Add explicit include of <linux/quota.h> into ext4_jbd2.h
Date: Mon,  2 Jun 2008 19:11:08 +0200
Message-Id: <12124266722979-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124266712838-git-send-email-jack@suse.cz>
References: y
 <12124266712214-git-send-email-jack@suse.cz>
 <12124266711334-git-send-email-jack@suse.cz>
 <12124266712838-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need definitions from quota.h. So far we depended on fs.h on including
this file for us and this is going to change.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 9255a7d..be2301c 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -17,6 +17,7 @@
 
 #include <linux/fs.h>
 #include <linux/jbd2.h>
+#include <linux/quota.h>
 #include "ext4.h"
 
 #define EXT4_JOURNAL(inode)	(EXT4_SB((inode)->i_sb)->s_journal)
-- 
1.5.2.4

